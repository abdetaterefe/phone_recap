import 'package:fl_chart/fl_chart.dart';
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
  var visibilty = true;
  @override
  void initState() {
    super.initState();
    context.read<ContactInsightsBloc>().add(ContactInsightsLoadContactsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: BlocBuilder<ContactInsightsBloc, ContactInsightsState>(
            builder: (context, state) {
              if (state.status == Status.loading) {
                return Shimmer.fromColors(
                  enabled: true,
                  direction: ShimmerDirection.ltr,
                  baseColor:
                      Theme.of(context).colorScheme.brightness ==
                              Brightness.dark
                          ? Theme.of(context).colorScheme.surfaceBright
                          : Theme.of(context).colorScheme.surfaceDim,
                  highlightColor:
                      Theme.of(context).colorScheme.brightness ==
                              Brightness.dark
                          ? Theme.of(context).colorScheme.surfaceContainerHigh
                          : Theme.of(context).colorScheme.surfaceContainerHigh,

                  child: Column(
                    children: [
                      Card.filled(
                        child: DropdownMenu<String>(
                          width: double.infinity,
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
                    Card.filled(
                      child: Row(
                        children: [
                          Expanded(
                            child: DropdownMenu<String>(
                              key: ValueKey(visibilty),
                              width: double.infinity,
                              leadingIcon: Icon(
                                Icons.contacts,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              inputDecorationTheme: const InputDecorationTheme(
                                border: InputBorder.none,
                              ),
                              initialSelection:
                                  state.selectedContactPhoneNumber,
                              onSelected: (String? value) {
                                var displayName =
                                    state.contacts.firstWhere(
                                      (contact) =>
                                          contact["phoneNumber"] == value,
                                    )["displayName"];
                                context.read<ContactInsightsBloc>().add(
                                  ContactInsightsCalculateEvent(
                                    displayName: displayName ?? "",
                                    phoneNumber: value ?? "",
                                    contacts: state.contacts,
                                  ),
                                );
                              },
                              dropdownMenuEntries:
                                  state.contacts.map((contact) {
                                    return DropdownMenuEntry<String>(
                                      label:
                                          "${contact["displayName"]} ${visibilty ? contact["phoneNumber"] : ""}",
                                      value: contact["phoneNumber"] ?? '',
                                    );
                                  }).toList(),
                            ),
                          ),
                          IconButton.filled(
                            onPressed: () {
                              setState(() {
                                visibilty = !visibilty;
                              });
                            },
                            icon: Icon(
                              visibilty
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Card(
                        child: SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child:
                                state.status == Status.empty
                                    ? Center(
                                      child: Text(
                                        "No Data",
                                        style:
                                            Theme.of(
                                              context,
                                            ).textTheme.titleLarge,
                                      ),
                                    )
                                    : SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Total",
                                            style: TextStyle(
                                              color:
                                                  Theme.of(
                                                    context,
                                                  ).colorScheme.primary,
                                              fontSize: 16,
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            "${state.totalCalls.toString()} Calls",
                                            style:
                                                Theme.of(
                                                  context,
                                                ).textTheme.titleLarge,
                                          ),
                                          Text(
                                            TimeUtils.formatDuration(
                                              state.totalDuration,
                                            ),
                                          ),
                                          Divider(),
                                          Text(
                                            "Average Call Duration",
                                            style: TextStyle(
                                              color:
                                                  Theme.of(
                                                    context,
                                                  ).colorScheme.primary,
                                              fontSize: 16,
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            TimeUtils.formatDuration(
                                              state.averageDuration.toInt(),
                                            ),
                                            style:
                                                Theme.of(
                                                  context,
                                                ).textTheme.titleLarge,
                                          ),
                                          Divider(),
                                          Text(
                                            "Response Rate",
                                            style: TextStyle(
                                              color:
                                                  Theme.of(
                                                    context,
                                                  ).colorScheme.primary,
                                              fontSize: 16,
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            "${Utils.persent(state.answeredCalls, state.outgoingCalls)}%",
                                            style:
                                                Theme.of(
                                                  context,
                                                ).textTheme.titleLarge,
                                          ),
                                          Text(
                                            "${state.answeredCalls} calls have been answered out of ${state.outgoingCalls} calls",
                                          ),
                                          Divider(),
                                          Text(
                                            "Longest Streak",
                                            style: TextStyle(
                                              color:
                                                  Theme.of(
                                                    context,
                                                  ).colorScheme.primary,
                                              fontSize: 16,
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            "${state.longestStreak.length} days",
                                            style:
                                                Theme.of(
                                                  context,
                                                ).textTheme.titleLarge,
                                          ),
                                          Text(
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
                                          Divider(),
                                          Text(
                                            "Call Distribution",
                                            style: TextStyle(
                                              color:
                                                  Theme.of(
                                                    context,
                                                  ).colorScheme.primary,
                                              fontSize: 16,
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          AspectRatio(
                                            aspectRatio: 2,
                                            child: BarChart(
                                              BarChartData(
                                                barGroups: [
                                                  BarChartGroupData(
                                                    x: 0,

                                                    barRods: [
                                                      BarChartRodData(
                                                        width: 100,
                                                        color:
                                                            Theme.of(context)
                                                                .colorScheme
                                                                .primary,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                              Radius.circular(
                                                                5,
                                                              ),
                                                            ),
                                                        toY:
                                                            state.incomingCalls
                                                                .toDouble(),
                                                      ),
                                                    ],
                                                    showingTooltipIndicators: [
                                                      0,
                                                    ],
                                                  ),
                                                  BarChartGroupData(
                                                    x: 1,
                                                    barRods: [
                                                      BarChartRodData(
                                                        width: 100,
                                                        color:
                                                            Theme.of(context)
                                                                .colorScheme
                                                                .secondary,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                              Radius.circular(
                                                                5,
                                                              ),
                                                            ),
                                                        toY:
                                                            state.outgoingCalls
                                                                .toDouble(),
                                                      ),
                                                    ],
                                                    showingTooltipIndicators: [
                                                      0,
                                                    ],
                                                  ),
                                                ],
                                                barTouchData: BarTouchData(
                                                  enabled: false,
                                                  touchTooltipData:
                                                      BarTouchTooltipData(
                                                        getTooltipColor:
                                                            (group) =>
                                                                Colors
                                                                    .transparent,
                                                        tooltipPadding:
                                                            EdgeInsets.zero,
                                                        tooltipMargin: 8,
                                                        getTooltipItem: (
                                                          BarChartGroupData
                                                          group,
                                                          int groupIndex,
                                                          BarChartRodData rod,
                                                          int rodIndex,
                                                        ) {
                                                          return BarTooltipItem(
                                                            rod.toY
                                                                .round()
                                                                .toString(),
                                                            const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                ),
                                                titlesData: FlTitlesData(
                                                  show: true,
                                                  bottomTitles: AxisTitles(
                                                    sideTitles: SideTitles(
                                                      showTitles: true,
                                                      reservedSize: 30,
                                                      getTitlesWidget: (
                                                        value,
                                                        meta,
                                                      ) {
                                                        switch (value.toInt()) {
                                                          case 0:
                                                            return const Text(
                                                              "Incoming",
                                                            );
                                                          case 1:
                                                            return const Text(
                                                              "Outgoing",
                                                            );
                                                          default:
                                                            return const SizedBox();
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                  leftTitles: const AxisTitles(
                                                    sideTitles: SideTitles(
                                                      showTitles: false,
                                                    ),
                                                  ),
                                                  topTitles: const AxisTitles(
                                                    sideTitles: SideTitles(
                                                      showTitles: false,
                                                    ),
                                                  ),
                                                  rightTitles: const AxisTitles(
                                                    sideTitles: SideTitles(
                                                      showTitles: false,
                                                    ),
                                                  ),
                                                ),
                                                borderData: FlBorderData(
                                                  show: false,
                                                ),
                                                gridData: const FlGridData(
                                                  show: false,
                                                ),
                                                alignment:
                                                    BarChartAlignment
                                                        .spaceAround,
                                                maxY:
                                                    state.incomingCalls >
                                                            state.outgoingCalls
                                                        ? state.incomingCalls
                                                                .toDouble() +
                                                            25
                                                        : state.outgoingCalls
                                                                .toDouble() +
                                                            25,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
