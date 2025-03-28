import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:phone_recap/features/advanced_metrics/advanced_metrics.dart';

class UnansweredCallsChart extends StatelessWidget {
  const UnansweredCallsChart({
    super.key,
    required this.missedCalls,
    required this.rejectedCalls,
    required this.blockedCalls,
  });

  final int missedCalls;
  final int rejectedCalls;
  final int blockedCalls;

  @override
  Widget build(BuildContext context) {
    final total = missedCalls + rejectedCalls + blockedCalls;
    final missedCallsPercentage = missedCalls / total * 100;
    final rejectedCallsPercentage = rejectedCalls / total * 100;
    final blockedCallsPercentage = blockedCalls / total * 100;
    return AspectRatio(
      aspectRatio: 1.3,
      child: Row(
        children: <Widget>[
          const SizedBox(height: 18),
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      color: Colors.red,
                      value: missedCalls.toDouble(),
                      title: '${missedCallsPercentage.toStringAsFixed(2)}%',
                      radius: 75,
                      titleStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color:
                            Theme.of(context).colorScheme.brightness ==
                                    Brightness.dark
                                ? Colors.black
                                : Colors.white,
                      ),
                    ),
                    PieChartSectionData(
                      color: Colors.green,
                      value: rejectedCalls.toDouble(),
                      title: '${rejectedCallsPercentage.toStringAsFixed(2)}%',
                      radius: 75,
                      titleStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color:
                            Theme.of(context).colorScheme.brightness ==
                                    Brightness.dark
                                ? Colors.black
                                : Colors.white,
                      ),
                    ),
                    PieChartSectionData(
                      color: Colors.blue,
                      value: blockedCalls.toDouble(),
                      title: '${blockedCallsPercentage.toStringAsFixed(2)}%',
                      radius: 75,
                      titleStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color:
                            Theme.of(context).colorScheme.brightness ==
                                    Brightness.dark
                                ? Colors.black
                                : Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Indicator(color: Colors.red, text: 'Missed'),
              SizedBox(height: 4),
              Indicator(color: Colors.green, text: 'Rejected'),
              SizedBox(height: 4),
              Indicator(color: Colors.blue, text: 'Blocked'),
              SizedBox(height: 4),
            ],
          ),
        ],
      ),
    );
  }
}
