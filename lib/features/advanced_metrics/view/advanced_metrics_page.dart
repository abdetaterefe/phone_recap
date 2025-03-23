import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AdvancedMetricsPage extends StatelessWidget {
  const AdvancedMetricsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdvancedMetricsView();
  }
}

class AdvancedMetricsView extends StatefulWidget {
  const AdvancedMetricsView({super.key});

  @override
  State<AdvancedMetricsView> createState() => _AdvancedMetricsViewState();
}

const List<String> list = <String>['All', 'Incoming', 'Outgoing', 'Missed'];
typedef MenuEntry = DropdownMenuEntry<String>;

class _AdvancedMetricsViewState extends State<AdvancedMetricsView> {
  DateTimeRange _selectedDateRange = DateTimeRange(
    start: DateTime.now().subtract(Duration(days: 30)),
    end: DateTime.now(),
  );
  List<CallRecord> _callRecords = [];

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
    final random = DateTime.now().millisecondsSinceEpoch % 100;
    _callRecords = List.generate(100, (index) {
      final time = DateTime.now().subtract(
        Duration(days: random % 30, hours: random % 24, minutes: random % 60),
      );
      return CallRecord(
        time,
        random % 300,
        random % 3 == 0
            ? CallType.missed
            : random % 2 == 0
            ? CallType.incoming
            : CallType.outgoing,
      );
    });
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _selectedDateRange,
    );
    if (picked != null && picked != _selectedDateRange) {
      setState(() {
        _selectedDateRange = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Advanced Metrics')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: () => _selectDateRange(context),
                    label: Text("Date Range"),
                    icon: Icon(Icons.calendar_today),
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
                    padding: EdgeInsets.all(8),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            title: Text(
                              "Unanswered Calls Percentage",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                          _buildUnansweredCallsPieChart(),
                          Divider(),
                          ListTile(
                            title: Text(
                              "Repeated Call Attempts",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                          _buildRepeatedCallAttemptsBarChart(),
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

  Widget _buildUnansweredCallsPieChart() {
    int unansweredCalls =
        _callRecords.where((record) => record.type == CallType.missed).length;
    int answeredCalls =
        _callRecords.where((record) => record.type != CallType.missed).length;

    return Container(
      height: 200,
      child: PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(
              value: unansweredCalls.toDouble(),
              title: 'Unanswered',
              color: Colors.red,
            ),
            PieChartSectionData(
              value: answeredCalls.toDouble(),
              title: 'Answered',
              color: Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRepeatedCallAttemptsBarChart() {
    // Example: Group calls by hour and count repeated calls (same hour, same type)
    Map<int, int> repeatedCalls = {};
    for (int i = 1; i < _callRecords.length; i++) {
      if (_callRecords[i].time.hour == _callRecords[i - 1].time.hour &&
          _callRecords[i].type == _callRecords[i - 1].type) {
        repeatedCalls[_callRecords[i].time.hour] =
            (repeatedCalls[_callRecords[i].time.hour] ?? 0) + 1;
      }
    }

    List<BarChartGroupData> barGroups =
        repeatedCalls.entries
            .map(
              (entry) => BarChartGroupData(
                x: entry.key,
                barRods: [
                  BarChartRodData(
                    color: Colors.blue,
                    toY: entry.value.toDouble(),
                  ),
                ],
              ),
            )
            .toList();

    return Container(
      height: 200,
      child: BarChart(
        BarChartData(
          barGroups: barGroups,
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                // getTitles: (value) => '${value.toInt()}:00',
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum CallType { incoming, outgoing, missed }

class CallRecord {
  final DateTime time;
  final int duration;
  final CallType type;

  CallRecord(this.time, this.duration, this.type);
}
