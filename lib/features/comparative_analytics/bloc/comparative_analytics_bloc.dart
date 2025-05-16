import 'package:call_log/call_log.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:phone_recap/core/utils/time.dart';
import 'package:phone_recap/features/comparative_analytics/comparative_analytics.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'comparative_analytics_event.dart';
part 'comparative_analytics_state.dart';

class ComparativeAnalyticsBloc
    extends Bloc<ComparativeAnalyticsEvent, ComparativeAnalyticsState> {
  ComparativeAnalyticsBloc() : super(ComparativeAnalyticsState()) {
    on<ComparativeAnalyticsLoadContactsEvent>(_onLoadContactsEvent);
    on<ComparativeAnalyticsCalculateEvent>(_onCalculateEvent);
  }

  Future<void> _onLoadContactsEvent(
    ComparativeAnalyticsLoadContactsEvent event,
    Emitter<ComparativeAnalyticsState> emit,
  ) async {
    emit(ComparativeAnalyticsState());
    try {
      final permissionStatus = await Permission.contacts.request();
      if (!permissionStatus.isGranted) {
        return emit(
          ComparativeAnalyticsState(
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
          ComparativeAnalyticsState(
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
          ComparativeAnalyticsState(
            status: Status.error,
            errorMessage: 'Not enough contacts with call log data found',
          ),
        );
      }

      final prefs = await SharedPreferences.getInstance();
      final firstNumber =
          prefs.getString("comparative_analytics_first_phone_number") ??
          contactsWithData[0]['phoneNumber']!;
      final firstDisplayName =
          prefs.getString('comparative_analytics_first_display_name') ??
          contactsWithData[0]['displayName']!;
      final secondNumber =
          prefs.getString('comparative_analytics_second_phone_number') ??
          contactsWithData[1]['phoneNumber']!;
      final secondDisplayName =
          prefs.getString('comparative_analytics_second_display_name') ??
          contactsWithData[1]['displayName']!;

      add(
        ComparativeAnalyticsCalculateEvent(
          firstPhoneNumber: firstNumber,
          secondPhoneNumber: secondNumber,
          firstDisplayName: firstDisplayName,
          secondDisplayName: secondDisplayName,
          contacts: contactsWithData,
        ),
      );
    } catch (e) {
      emit(
        ComparativeAnalyticsState(
          status: Status.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onCalculateEvent(
    ComparativeAnalyticsCalculateEvent event,
    Emitter<ComparativeAnalyticsState> emit,
  ) async {
    emit(ComparativeAnalyticsState());

    try {
      if (event.firstPhoneNumber == event.secondPhoneNumber) {
        return emit(
          ComparativeAnalyticsState(
            status: Status.error,
            errorMessage: 'Phone numbers cannot be the same',
            contacts: event.contacts,
          ),
        );
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        "comparative_analytics_first_phone_number",
        event.firstPhoneNumber,
      );
      await prefs.setString(
        "comparative_analytics_second_phone_number",
        event.secondPhoneNumber,
      );
      await prefs.setString(
        "comparative_analytics_first_display_name",
        event.firstDisplayName,
      );
      await prefs.setString(
        "comparative_analytics_second_display_name",
        event.secondDisplayName,
      );

      final comparisonResult = await _compareTwoNumbers(
        event.firstPhoneNumber,
        event.secondPhoneNumber,
        event.firstDisplayName,
        event.secondDisplayName,
      );

      getDisplayName(String phoneNumber) {
        final contact = event.contacts.firstWhere(
          (c) => c["phoneNumber"] == phoneNumber,
          orElse: () => {"displayName": phoneNumber},
        );
        return contact["displayName"];
      }

      if (comparisonResult.firstStats.totalCalls == 0 &&
          comparisonResult.secondStats.totalCalls == 0) {
        emit(
          ComparativeAnalyticsState(
            status: Status.error,
            errorMessage:
                'No call data found for ${getDisplayName(event.firstPhoneNumber)} and ${getDisplayName(event.secondPhoneNumber)}',
            contacts: event.contacts,
            firstNumber: event.firstPhoneNumber,
            secondNumber: event.secondPhoneNumber,
          ),
        );
      } else if (comparisonResult.firstStats.totalCalls == 0) {
        emit(
          ComparativeAnalyticsState(
            status: Status.error,
            errorMessage:
                'No call data were found for ${getDisplayName(event.firstPhoneNumber)}',
            contacts: event.contacts,
            firstNumber: event.firstPhoneNumber,
            secondNumber: event.secondPhoneNumber,
          ),
        );
      } else if (comparisonResult.secondStats.totalCalls == 0) {
        emit(
          ComparativeAnalyticsState(
            status: Status.error,
            errorMessage:
                'No call data were found for ${getDisplayName(event.secondPhoneNumber)}',
            contacts: event.contacts,
            firstNumber: event.firstPhoneNumber,
            secondNumber: event.secondPhoneNumber,
          ),
        );
      } else {
        emit(
          ComparativeAnalyticsState(
            status: Status.complete,
            contacts: event.contacts,
            comparisonResult: comparisonResult,
            firstNumber: event.firstPhoneNumber,
            secondNumber: event.secondPhoneNumber,
          ),
        );
      }
    } catch (e) {
      emit(
        ComparativeAnalyticsState(
          status: Status.error,
          contacts: event.contacts,
          errorMessage: e.toString(),
          firstNumber: event.firstPhoneNumber,
          secondNumber: event.secondPhoneNumber,
        ),
      );
    }
  }

  List<CallLogEntry> _filterEntriesForNumber(
    Iterable<CallLogEntry> entries,
    String number,
    String displayName,
  ) {
    return entries
        .where(
          (entry) =>
              entry.number == number.replaceAll(' ', '') ||
              entry.name == displayName,
        )
        .toList()
      ..sort((a, b) => a.timestamp!.compareTo(b.timestamp!));
  }

  Future<ComparisonResult> _compareTwoNumbers(
    String first,
    String second,
    String firstDisplayName,
    String secondDisplayName,
  ) async {
    final entries = await CallLog.query();

    final firstCalls = _filterEntriesForNumber(
      entries,
      first,
      firstDisplayName,
    );
    final secondCalls = _filterEntriesForNumber(
      entries,
      second,
      secondDisplayName,
    );

    if (firstCalls.isEmpty && secondCalls.isEmpty) {
      return ComparisonResult();
    } else if (firstCalls.isEmpty) {
      return ComparisonResult(secondStats: _analyzeCalls(secondCalls));
    } else if (secondCalls.isEmpty) {
      return ComparisonResult(firstStats: _analyzeCalls(firstCalls));
    }

    return ComparisonResult(
      firstStats: _analyzeCalls(firstCalls),
      secondStats: _analyzeCalls(secondCalls),
    );
  }

  CallStatistics _analyzeCalls(Iterable<CallLogEntry> entries) {
    final duration = entries.fold<int>(0, (sum, e) => sum + (e.duration ?? 0));
    final count = entries.length;

    return CallStatistics(
      totalCalls: count,
      totalDuration: duration,
      averageDuration: count > 0 ? duration / count : 0,
      dayOfWeekPreference: _getMostCommon(entries, _extractDayOfWeek),
      timePreference: _getMostCommon(entries, _extractHour),
      incomingCalls:
          entries.where((e) => e.callType == CallType.incoming).length,
      outgoingCalls:
          entries.where((e) => e.callType == CallType.outgoing).length,
    );
  }

  String _getMostCommon(
    Iterable<CallLogEntry> entries,
    String Function(CallLogEntry) extractor,
  ) {
    final counts = <String, int>{};
    for (final entry in entries) {
      final key = extractor(entry);
      counts[key] = (counts[key] ?? 0) + 1;
    }
    return counts.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }

  String _extractDayOfWeek(CallLogEntry entry) => TimeUtils.getDayOfWeek(
    DateTime.fromMillisecondsSinceEpoch(entry.timestamp!),
  );

  String _extractHour(CallLogEntry entry) =>
      DateTime.fromMillisecondsSinceEpoch(entry.timestamp!).hour.toString();
}
