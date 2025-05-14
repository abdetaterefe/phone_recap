import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:phone_recap/core/utils/time.dart';
import 'package:phone_recap/features/comparative_analytics/comparative_analytics.dart';

class Comparison extends StatelessWidget {
  const Comparison({super.key, required this.state});

  final ComparativeAnalyticsState state;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(
            "Total Calls",
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
        ),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  state.comparisonResult.firstStats.totalCalls.toString(),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  state.comparisonResult.secondStats.totalCalls.toString(),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            Text(
              "Difference: ${state.comparisonResult.firstStats.totalCalls - state.comparisonResult.secondStats.totalCalls}",
            ),
          ],
        ),
        Divider(),
        ListTile(
          title: Text(
            "Total Duration",
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
        ),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ListTile(
                    title: Text(
                      TimeUtils.formatDuration(
                        state.comparisonResult.firstStats.totalDuration,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: Text(
                      TimeUtils.formatDuration(
                        state.comparisonResult.secondStats.totalDuration,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Text(
              "Difference: ${TimeUtils.formatDuration(state.comparisonResult.firstStats.totalDuration - state.comparisonResult.secondStats.totalDuration)}",
            ),
          ],
        ),
        Divider(),
        ListTile(
          title: Text(
            "Average Duration",
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
        ),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ListTile(
                    title: Text(
                      TimeUtils.formatDuration(
                        state.comparisonResult.firstStats.averageDuration
                            .toInt(),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: Text(
                      TimeUtils.formatDuration(
                        state.comparisonResult.secondStats.averageDuration
                            .toInt(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Text(
              "Difference: ${TimeUtils.formatDuration(state.comparisonResult.firstStats.averageDuration.toInt() - state.comparisonResult.secondStats.averageDuration.toInt())}",
            ),
          ],
        ),
        Divider(),
        ListTile(
          title: Text(
            "Call Distribution",
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: BarChart(
                  BarChartData(
                    barGroups: [
                      BarChartGroupData(
                        x: 0,

                        barRods: [
                          BarChartRodData(
                            width: 50,
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            toY:
                                state.comparisonResult.firstStats.incomingCalls
                                    .toDouble(),
                          ),
                        ],
                        showingTooltipIndicators: [0],
                      ),
                      BarChartGroupData(
                        x: 1,
                        barRods: [
                          BarChartRodData(
                            width: 50,
                            color: Theme.of(context).colorScheme.secondary,
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            toY:
                                state.comparisonResult.firstStats.outgoingCalls
                                    .toDouble(),
                          ),
                        ],
                        showingTooltipIndicators: [0],
                      ),
                    ],
                    barTouchData: BarTouchData(
                      enabled: false,
                      touchTooltipData: BarTouchTooltipData(
                        getTooltipColor: (group) => Colors.transparent,
                        tooltipPadding: EdgeInsets.zero,
                        tooltipMargin: 8,
                        getTooltipItem: (
                          BarChartGroupData group,
                          int groupIndex,
                          BarChartRodData rod,
                          int rodIndex,
                        ) {
                          return BarTooltipItem(
                            rod.toY.round().toString(),
                            const TextStyle(fontWeight: FontWeight.bold),
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
                          getTitlesWidget: (value, meta) {
                            switch (value.toInt()) {
                              case 0:
                                return const Text("Incoming");
                              case 1:
                                return const Text("Outgoing");
                              default:
                                return const SizedBox();
                            }
                          },
                        ),
                      ),
                      leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    gridData: const FlGridData(show: false),
                    alignment: BarChartAlignment.spaceAround,
                    maxY:
                        state.comparisonResult.firstStats.incomingCalls >
                                state.comparisonResult.firstStats.outgoingCalls
                            ? state.comparisonResult.firstStats.incomingCalls
                                    .toDouble() +
                                25
                            : state.comparisonResult.firstStats.outgoingCalls
                                    .toDouble() +
                                25,
                  ),
                ),
              ),
            ),
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: BarChart(
                  BarChartData(
                    barGroups: [
                      BarChartGroupData(
                        x: 0,
                        barRods: [
                          BarChartRodData(
                            width: 50,
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            toY:
                                state.comparisonResult.secondStats.incomingCalls
                                    .toDouble(),
                          ),
                        ],
                        showingTooltipIndicators: [0],
                      ),
                      BarChartGroupData(
                        x: 1,
                        barRods: [
                          BarChartRodData(
                            width: 50,
                            color: Theme.of(context).colorScheme.secondary,
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            toY:
                                state.comparisonResult.secondStats.outgoingCalls
                                    .toDouble(),
                          ),
                        ],
                        showingTooltipIndicators: [0],
                      ),
                    ],
                    barTouchData: BarTouchData(
                      enabled: false,
                      touchTooltipData: BarTouchTooltipData(
                        getTooltipColor: (group) => Colors.transparent,
                        tooltipPadding: EdgeInsets.zero,
                        tooltipMargin: 8,
                        getTooltipItem: (
                          BarChartGroupData group,
                          int groupIndex,
                          BarChartRodData rod,
                          int rodIndex,
                        ) {
                          return BarTooltipItem(
                            rod.toY.round().toString(),
                            const TextStyle(fontWeight: FontWeight.bold),
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
                          getTitlesWidget: (value, meta) {
                            switch (value.toInt()) {
                              case 0:
                                return const Text("Incoming");
                              case 1:
                                return const Text("Outgoing");
                              default:
                                return const SizedBox();
                            }
                          },
                        ),
                      ),
                      leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    gridData: const FlGridData(show: false),
                    alignment: BarChartAlignment.spaceAround,
                    maxY:
                        state.comparisonResult.secondStats.incomingCalls >
                                state.comparisonResult.secondStats.outgoingCalls
                            ? state.comparisonResult.secondStats.incomingCalls
                                    .toDouble() +
                                25
                            : state.comparisonResult.secondStats.outgoingCalls
                                    .toDouble() +
                                25,
                  ),
                ),
              ),
            ),
          ],
        ),
        Divider(),
        ListTile(
          title: Text(
            "Call Presences",
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: ListTile(
                title: Text(
                  state.comparisonResult.firstStats.dayOfWeekPreference,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                subtitle: Text(
                  "${state.comparisonResult.firstStats.timePreference}:00",
                ),
              ),
            ),
            Expanded(
              child: ListTile(
                title: Text(
                  state.comparisonResult.secondStats.dayOfWeekPreference,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                subtitle: Text(
                  "${state.comparisonResult.secondStats.timePreference}:00",
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
