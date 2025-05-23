import 'package:call_log/call_log.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'contact_insights_event.dart';
part 'contact_insights_state.dart';

class ContactInsightsBloc
    extends Bloc<ContactInsightsEvent, ContactInsightsState> {
  ContactInsightsBloc() : super(const ContactInsightsState()) {
    on<ContactInsightsLoadContactsEvent>(_onLoadContacts);
    on<ContactInsightsCalculateEvent>(_onCalculate);
  }

  Future<void> _onLoadContacts(
    ContactInsightsLoadContactsEvent event,
    Emitter<ContactInsightsState> emit,
  ) async {
    emit(ContactInsightsState());
    try {
      final permissionStatus = await Permission.contacts.request();
      if (!permissionStatus.isGranted) {
        return emit(
          ContactInsightsState(
            status: Status.error,
            errorMessage: 'Contacts permission not granted',
          ),
        );
      }
      final contacts = await FlutterContacts.getContacts(withProperties: true);

      final List<Map<String, String>> contactsList = [];
      contacts.where((contact) => contact.phones.isNotEmpty).forEach((contact) {
        final phones =
            contact.phones
                .where((phone) => !phone.number.contains("*"))
                .toList();

        for (var phone in phones) {
          contactsList.add({
            "displayName": contact.displayName,
            "phoneNumber": phone.number,
          });
        }
      });

      if (contactsList.isEmpty) {
        return emit(
          ContactInsightsState(
            status: Status.error,
            errorMessage: 'No contacts found',
          ),
        );
      }

      final Iterable<CallLogEntry> entries = await CallLog.query();

      final contactsWithData =
          contactsList
              .where(
                (c) => entries.any(
                  (entry) =>
                      entry.number == c['phoneNumber']!.replaceAll(' ', ''),
                ),
              )
              .toList();

      if (contactsWithData.length < 2) {
        return emit(
          ContactInsightsState(
            status: Status.error,
            errorMessage: 'Not enough contacts with call log data found',
          ),
        );
      }

      final prefs = await SharedPreferences.getInstance();
      final selectedNumber =
          prefs.getString("contact_insights_selected_phone_number") ??
          contactsWithData[0]['phoneNumber']!;
      final selectedDisplayName =
          prefs.getString("contact_insights_selected_display_name") ??
          contactsWithData[0]['displayName']!;

      add(
        ContactInsightsCalculateEvent(
          phoneNumber: selectedNumber,
          displayName: selectedDisplayName,
          contacts: contactsWithData,
        ),
      );
    } catch (e) {
      emit(ContactInsightsState(status: Status.error));
    }
  }

  Future<void> _onCalculate(
    ContactInsightsCalculateEvent event,
    Emitter<ContactInsightsState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      "contact_insights_selected_phone_number",
      event.phoneNumber,
    );
    await prefs.setString(
      "contact_insights_selected_display_name",
      event.displayName,
    );
    emit(
      ContactInsightsState(
        status: Status.loading,
        selectedContactPhoneNumber: event.phoneNumber,
      ),
    );
    try {
      final callLogPermissionStatus = await Permission.phone.request();
      if (callLogPermissionStatus.isGranted) {
        final Iterable<CallLogEntry> entries = await CallLog.query();

        if (entries.isEmpty) {
          emit(
            ContactInsightsState(
              status: Status.empty,
              contacts: event.contacts,
            ),
          );
          return;
        }
        final filteredCalls =
            entries
                .where(
                  (entry) =>
                      entry.number == event.phoneNumber.replaceAll(" ", "") ||
                      entry.name == event.displayName,
                )
                .toList()
              ..sort((a, b) => a.timestamp!.compareTo(b.timestamp!));

        if (filteredCalls.isEmpty) {
          emit(
            ContactInsightsState(
              status: Status.empty,
              contacts: event.contacts,
            ),
          );
        } else {
          final totalCalls = filteredCalls.length;
          final totalDuration = filteredCalls.fold<int>(
            0,
            (sum, entry) => sum + (entry.duration ?? 0),
          );
          final averageDuration = totalDuration / totalCalls;

          final outgoingCalls =
              filteredCalls
                  .where((entry) => entry.callType == CallType.outgoing)
                  .length;

          final incomingCalls =
              filteredCalls
                  .where((entry) => entry.callType == CallType.incoming)
                  .length;

          final answeredCalls =
              filteredCalls
                  .where(
                    (entry) =>
                        entry.duration != null &&
                        entry.duration! > 0 &&
                        entry.callType == CallType.outgoing,
                  )
                  .length;

          List<List<CallLogEntry>> streaks = [];

          List<CallLogEntry> currentStreak = [filteredCalls.first];

          for (int i = 1; i < filteredCalls.length; i++) {
            final currentEntry = filteredCalls[i];
            final currentDate = DateTime.fromMillisecondsSinceEpoch(
              currentEntry.timestamp!,
            );

            final lastStreakDate = DateTime.fromMillisecondsSinceEpoch(
              currentStreak.last.timestamp!,
            );
            final dayDifference = currentDate.difference(lastStreakDate).inDays;

            if (dayDifference == 0) {
              continue;
            } else if (dayDifference == 1) {
              currentStreak.add(currentEntry);
            } else {
              streaks.add(currentStreak);
              currentStreak = [currentEntry];
            }
          }

          streaks.add(currentStreak);

          streaks.removeWhere((streak) => streak.isEmpty);
          streaks.sort((a, b) => b.length.compareTo(a.length));

          emit(
            ContactInsightsState(
              status: Status.complete,
              contacts: event.contacts,
              averageDuration: averageDuration,
              totalCalls: totalCalls,
              totalDuration: totalDuration,
              selectedContactPhoneNumber: event.phoneNumber,
              answeredCalls: answeredCalls,
              outgoingCalls: outgoingCalls,
              incomingCalls: incomingCalls,
              longestStreak: streaks.first,
            ),
          );
        }
      } else {
        emit(ContactInsightsState(status: Status.error));
      }
    } catch (e) {
      emit(ContactInsightsState(status: Status.error));
    }
  }
}
