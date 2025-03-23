import 'dart:collection';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ComparativeAnalyticsPage extends StatelessWidget {
  const ComparativeAnalyticsPage({super.key});
  static MaterialPageRoute<ComparativeAnalyticsPage> route() =>
      MaterialPageRoute(builder: (context) => ComparativeAnalyticsPage());

  @override
  Widget build(BuildContext context) {
    return ComparativeAnalyticsView();
  }
}

class ComparativeAnalyticsView extends StatefulWidget {
  const ComparativeAnalyticsView({super.key});

  @override
  State<ComparativeAnalyticsView> createState() =>
      _ComparativeAnalyticsViewState();
}

const List<String> list = <String>['One', 'Two', 'Three', 'Four'];
typedef MenuEntry = DropdownMenuEntry<String>;

class _ComparativeAnalyticsViewState extends State<ComparativeAnalyticsView> {
  List<MonthlyData> _monthlyData = [];

  static final List<MenuEntry> menuEntries = UnmodifiableListView<MenuEntry>(
    list.map<MenuEntry>((String name) => MenuEntry(value: name, label: name)),
  );
  String dropdownValue = list.first;

  @override
  void initState() {
    super.initState();
    _generateDummyData();
  }

  void _generateDummyData() {
    final now = DateTime.now();
    _monthlyData = List.generate(6, (index) {
      final month = DateTime(now.year, now.month - index);
      final random = (month.millisecondsSinceEpoch % 100).toDouble();
      return MonthlyData(
        month,
        (random * 10).toInt(), // Call volume
        random * 50, // Average duration
        {
          'John Doe': (random * 3).toInt(),
          'Jane Smith': (random * 2).toInt(),
          'Alice Johnson': (random * 1).toInt(),
        }, // Contact engagement
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Comparative Analytics')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card.filled(
              child: Row(
                children: [
                  Expanded(
                    child: DropdownMenu<String>(
                      width: double.infinity,
                      leadingIcon: Icon(
                        Icons.contacts,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      inputDecorationTheme: InputDecorationTheme(
                        border: InputBorder.none,
                      ),
                      initialSelection: list.first,
                      onSelected: (String? value) {
                        setState(() {
                          dropdownValue = value!;
                        });
                      },
                      dropdownMenuEntries: menuEntries,
                    ),
                  ),
                  Expanded(
                    child: DropdownMenu<String>(
                      width: double.infinity,
                      leadingIcon: Icon(
                        Icons.contacts,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      inputDecorationTheme: InputDecorationTheme(
                        border: InputBorder.none,
                      ),
                      initialSelection: list.first,
                      onSelected: (String? value) {
                        setState(() {
                          dropdownValue = value!;
                        });
                      },
                      dropdownMenuEntries: menuEntries,
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
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            title: Text(
                              "Call Volume Comparison",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                          _buildCallVolumeChart(),
                          Divider(),
                          ListTile(
                            title: Text(
                              "Average Call Duration Comparison",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                          _buildCallDurationChart(),
                          Divider(),
                          ListTile(
                            title: Text(
                              "Contact Engagement Trends",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                          _buildContactEngagementChart(),
                          Divider(),
                          ListTile(
                            title: Text(
                              "Interaction Pattern Changes",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                          _buildInteractionPatterns(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCallVolumeChart() {
    List<FlSpot> spots =
        _monthlyData
            .map(
              (data) => FlSpot(
                _monthlyData.indexOf(data).toDouble(),
                data.callVolume.toDouble(),
              ),
            )
            .toList();

    return Container(
      height: 200,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(spots: spots, isCurved: true, color: Colors.blue),
          ],
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                // getTitles: (value) => DateFormat('MMM')
                //     .format(_monthlyData[value.toInt()].month))),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCallDurationChart() {
    List<FlSpot> spots =
        _monthlyData
            .map(
              (data) => FlSpot(
                _monthlyData.indexOf(data).toDouble(),
                data.averageDuration,
              ),
            )
            .toList();

    return Container(
      height: 200,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(spots: spots, isCurved: true, color: Colors.green),
          ],
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                // getTitles: (value) => DateFormat('MMM')
                //     .format(_monthlyData[value.toInt()].month))),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContactEngagementChart() {
    List<BarChartGroupData> barGroups = [];
    final now = DateTime.now();
    final currentMonth = DateTime(now.year, now.month);

    _monthlyData.forEach((monthData) {
      if (monthData.month.month == currentMonth.month &&
          monthData.month.year == currentMonth.year) {
        monthData.contactEngagement.forEach((contact, count) {
          barGroups.add(
            BarChartGroupData(
              x: monthData.contactEngagement.keys.toList().indexOf(contact),
              barRods: [
                BarChartRodData(color: Colors.orange, toY: count.toDouble()),
              ],
            ),
          );
        });
      }
    });

    return Container(
      height: 200,
      child: BarChart(
        BarChartData(
          barGroups: barGroups,
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                // getTitles: (value) => _monthlyData.first.contactEngagement.keys
                //     .toList()[value.toInt()],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInteractionPatterns() {
    // Example: Displaying changes in call volume between current and previous month
    if (_monthlyData.length < 2) {
      return Text('Insufficient data for comparison.');
    }

    final currentMonthVolume = _monthlyData[0].callVolume;
    final previousMonthVolume = _monthlyData[1].callVolume;
    final difference = currentMonthVolume - previousMonthVolume;

    return Text(
      'Call volume change: ${difference > 0 ? '+' : ''}$difference calls',
    );
  }
}

class MonthlyData {
  final DateTime month;
  final int callVolume;
  final double averageDuration;
  final Map<String, int> contactEngagement;

  MonthlyData(
    this.month,
    this.callVolume,
    this.averageDuration,
    this.contactEngagement,
  );
}
