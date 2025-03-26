import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_recap/core/utils/time.dart';
import 'package:phone_recap/core/utils/utils.dart';
import 'package:phone_recap/features/contact_insights/contact_insights.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';

class ContactInsightsPage extends StatelessWidget {
  const ContactInsightsPage({super.key});
  static MaterialPageRoute<ContactInsightsPage> route() =>
      MaterialPageRoute(builder: (context) => const ContactInsightsPage());

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ContactInsightsBloc(),
      child: const ContactInsightsView(),
    );
  }
}

class ContactInsightsView extends StatefulWidget {
  const ContactInsightsView({super.key});

  @override
  State<ContactInsightsView> createState() => _ContactInsightsViewState();
}

class _ContactInsightsViewState extends State<ContactInsightsView> {
  @override
  void initState() {
    super.initState();
    context.read<ContactInsightsBloc>().add(ContactInsightsLoadContactsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contact Insights')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<ContactInsightsBloc, ContactInsightsState>(
          builder: (context, state) {
            if (state.status == Status.loading) {
              return Shimmer.fromColors(
                enabled: true,
                direction: ShimmerDirection.ltr,
                baseColor:
                    Theme.of(context).colorScheme.brightness == Brightness.dark
                        ? Theme.of(context).colorScheme.surfaceBright
                        : Theme.of(context).colorScheme.surfaceDim,
                highlightColor:
                    Theme.of(context).colorScheme.brightness == Brightness.dark
                        ? Theme.of(context).colorScheme.surfaceContainerHigh
                        : Theme.of(context).colorScheme.surfaceContainerHigh,

                child: Column(
                  children: [
                    Card.filled(
                      child: DropdownMenu<String>(
                        width: double.infinity,
                        leadingIcon: Icon(
                          Icons.contacts,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        inputDecorationTheme: const InputDecorationTheme(
                          border: InputBorder.none,
                        ),
                        initialSelection: "",
                        onSelected: (String? value) {},
                        dropdownMenuEntries: [],
                      ),
                    ),
                    Expanded(
                      child: Card(
                        child: SizedBox(
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else if (state.status == Status.error) {
              return SizedBox(child: Text("An error occurred"));
            } else {
              return Column(
                children: [
                  // Dropdown
                  Card.filled(
                    child: DropdownMenu<String>(
                      width: double.infinity,
                      leadingIcon: Icon(
                        Icons.contacts,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      inputDecorationTheme: const InputDecorationTheme(
                        border: InputBorder.none,
                      ),
                      initialSelection: state.selectedContactPhoneNumber,
                      onSelected: (String? value) {
                        context.read<ContactInsightsBloc>().add(
                          ContactInsightsCalculateEvent(
                            phoneNumber: value ?? "",
                            contacts: state.contacts,
                          ),
                        );
                      },
                      dropdownMenuEntries:
                          state.contacts.map((contact) {
                            final displayName =
                                "${contact["displayName"]} - ${contact["phoneNumber"]}";
                            final phoneNumber = contact["phoneNumber"] ?? '';
                            return DropdownMenuEntry<String>(
                              label: displayName,
                              value: phoneNumber,
                            );
                          }).toList(),
                    ),
                  ),
                  // Expanded
                  Expanded(
                    child: Card(
                      child: SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:
                              state.status == Status.empty
                                  ? Center(child: Text("No Data"))
                                  : SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        ListTile(
                                          title: Text(
                                            "Total Calls",
                                            style: TextStyle(
                                              color:
                                                  Theme.of(
                                                    context,
                                                  ).colorScheme.primary,
                                            ),
                                          ),
                                        ),
                                        ListTile(
                                          title: Text(
                                            state.totalCalls.toString(),
                                            style:
                                                Theme.of(
                                                  context,
                                                ).textTheme.titleLarge,
                                          ),
                                          subtitle: Text(
                                            TimeUtils.formatDuration(
                                              state.totalDuration,
                                            ),
                                          ),
                                        ),
                                        Divider(),
                                        ListTile(
                                          title: Text(
                                            "Average Call Duration",
                                            style: TextStyle(
                                              color:
                                                  Theme.of(
                                                    context,
                                                  ).colorScheme.primary,
                                            ),
                                          ),
                                        ),
                                        ListTile(
                                          title: Text(
                                            TimeUtils.formatDuration(
                                              state.averageDuration.toInt(),
                                            ),
                                            style:
                                                Theme.of(
                                                  context,
                                                ).textTheme.titleLarge,
                                          ),
                                        ),
                                        Divider(),
                                        ListTile(
                                          title: Text(
                                            "Response Rate",
                                            style: TextStyle(
                                              color:
                                                  Theme.of(
                                                    context,
                                                  ).colorScheme.primary,
                                            ),
                                          ),
                                        ),
                                        ListTile(
                                          title: Text(
                                            "${Utils.persent(state.answeredCalls, state.totalCalls)}%",
                                            style:
                                                Theme.of(
                                                  context,
                                                ).textTheme.titleLarge,
                                          ),
                                          subtitle: Text(
                                            "${state.answeredCalls} calls have been answered out of ${state.totalCalls} calls",
                                          ),
                                        ),
                                        Divider(),
                                        ListTile(
                                          title: Text(
                                            "Longest Streak",
                                            style: TextStyle(
                                              color:
                                                  Theme.of(
                                                    context,
                                                  ).colorScheme.primary,
                                            ),
                                          ),
                                        ),
                                        ListTile(
                                          title: Text(
                                            "${state.longestStreak.length} days",
                                            style:
                                                Theme.of(
                                                  context,
                                                ).textTheme.titleLarge,
                                          ),
                                          subtitle: Text(
                                            state.longestStreak.isNotEmpty &&
                                                    state
                                                            .longestStreak
                                                            .first
                                                            .timestamp !=
                                                        null &&
                                                    state
                                                            .longestStreak
                                                            .last
                                                            .timestamp !=
                                                        null &&
                                                    state
                                                            .longestStreak
                                                            .first
                                                            .timestamp! >=
                                                        0 &&
                                                    state
                                                            .longestStreak
                                                            .last
                                                            .timestamp! >=
                                                        0
                                                ? "Longest streak was recorded from ${DateFormat('yyyy-MM-dd').format(DateTime.fromMillisecondsSinceEpoch(state.longestStreak.first.timestamp!))} to ${DateFormat('yyyy-MM-dd').format(DateTime.fromMillisecondsSinceEpoch(state.longestStreak.last.timestamp!))}"
                                                : "Longest streak data unavailable",
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                        ),
                      ),
                    ),
                  ),
                  // Expanded
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
