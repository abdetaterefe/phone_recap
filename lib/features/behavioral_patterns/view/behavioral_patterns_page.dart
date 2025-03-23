import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class BehavioralPatternsPage extends StatelessWidget {
  const BehavioralPatternsPage({super.key});
  static MaterialPageRoute<BehavioralPatternsPage> route() =>
      MaterialPageRoute(builder: (context) => BehavioralPatternsPage());

  @override
  Widget build(BuildContext context) {
    return BehavioralPatternsView();
  }
}

class BehavioralPatternsView extends StatefulWidget {
  const BehavioralPatternsView({super.key});

  @override
  State<BehavioralPatternsView> createState() => _BehavioralPatternsViewState();
}

const List<String> list = <String>['All', 'Incoming', 'Outgoing'];
typedef MenuEntry = DropdownMenuEntry<String>;

class _BehavioralPatternsViewState extends State<BehavioralPatternsView> {
  DateTimeRange _selectedDateRange = DateTimeRange(
    start: DateTime.now().subtract(Duration(days: 30)),
    end: DateTime.now(),
  );
  Map<DateTime, int> _callFrequency = {};
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
        random % 2 == 0 ? CallType.incoming : CallType.outgoing,
      );
    });

    _callFrequency = {};
    for (final record in _callRecords) {
      final date = DateTime(
        record.time.year,
        record.time.month,
        record.time.day,
      );
      _callFrequency[date] = (_callFrequency[date] ?? 0) + 1;
    }
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
      appBar: AppBar(title: Text('Behavioral Patterns')),
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
                        children: [
                          ListTile(
                            title: Text(
                              "Time-of-Day Habits",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                          _buildTimeOfDayChart(),
                          Divider(),
                          ListTile(
                            title: Text(
                              "Day-of-Week Trends",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                          _buildDayOfWeekChart(),
                          Divider(),
                          ListTile(
                            title: Text(
                              "Short vs. Long Calls",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                          _buildCallDurationPieChart(),
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

  Widget _buildTimeOfDayChart() {
    Map<int, int> hourlyCalls = {};
    for (final record in _callRecords) {
      final hour = record.time.hour;
      hourlyCalls[hour] = (hourlyCalls[hour] ?? 0) + 1;
    }

    List<BarChartGroupData> barGroups =
        hourlyCalls.entries
            .map(
              (entry) => BarChartGroupData(
                x: entry.key,
                barRods: [BarChartRodData(toY: entry.value.toDouble())],
              ),
            )
            .toList();

    return SizedBox(
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

  Widget _buildDayOfWeekChart() {
    Map<int, int> dayOfWeekCalls = {};
    for (final record in _callRecords) {
      final day = record.time.weekday;
      dayOfWeekCalls[day] = (dayOfWeekCalls[day] ?? 0) + 1;
    }

    List<BarChartGroupData> barGroups =
        dayOfWeekCalls.entries
            .map(
              (entry) => BarChartGroupData(
                x: entry.key,
                barRods: [
                  BarChartRodData(
                    fromY: entry.value.toDouble(),
                    color: Colors.blue,
                    toY: entry.value.toDouble(),
                  ),
                ],
              ),
            )
            .toList();

    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          barGroups: barGroups,
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                // getTitles: (value) =>
                //     DateFormat('E').format(DateTime(2023, 1, value.toInt())),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCallDurationPieChart() {
    int shortCalls =
        _callRecords.where((record) => record.duration < 120).length;
    int longCalls =
        _callRecords.where((record) => record.duration >= 120).length;

    return SizedBox(
      height: 200,
      child: PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(
              value: shortCalls.toDouble(),
              title: 'Short',
              color: Colors.blue,
            ),
            PieChartSectionData(
              value: longCalls.toDouble(),
              title: 'Long',
              color: Colors.green,
            ),
          ],
        ),
      ),
    );
  }
}

enum CallType { incoming, outgoing }

class CallRecord {
  final DateTime time;
  final int duration;
  final CallType type;

  CallRecord(this.time, this.duration, this.type);
}
