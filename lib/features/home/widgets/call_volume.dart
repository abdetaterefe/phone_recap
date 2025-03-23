import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class CallVolumeChartSection extends StatelessWidget {
  const CallVolumeChartSection({super.key, required this.callVolumeChartData});

  final List<FlSpot> callVolumeChartData;

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Call Volume Trend',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Divider(),
            const SizedBox(height: 8),
            AspectRatio(
              aspectRatio: 2,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: true),
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.transparent),
                  ),
                  minX:
                      callVolumeChartData.isNotEmpty
                          ? callVolumeChartData.first.x
                          : 0,
                  maxX:
                      callVolumeChartData.isNotEmpty
                          ? callVolumeChartData.last.x
                          : 0,
                  minY: 0,
                  lineBarsData: [
                    LineChartBarData(
                      spots: callVolumeChartData,
                      isCurved: true,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      color: Theme.of(context).colorScheme.primary,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withOpacity(0.3),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
