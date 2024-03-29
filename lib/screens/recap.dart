import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:phone_recap/ui/busiest_day.dart';
import 'package:phone_recap/ui/incoming_outgoing_calls.dart';
import 'package:phone_recap/ui/most_talked_person.dart';
import 'package:phone_recap/ui/total_time.dart';

class RecapScreen extends StatefulWidget {
  const RecapScreen({Key? key, required this.year}) : super(key: key);

  final int year;

  @override
  State<RecapScreen> createState() => _RecapScreenState();
}

class _RecapScreenState extends State<RecapScreen> {
  Map<String, List<CallLogEntry>> _monthlyCallLogEntries = {};

  bool loading = true;

  String _getMonthName(DateTime dateTime) {
    final monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return monthNames[dateTime.month - 1];
  }

  Future<void> readCallLog() async {
    var startingDate = DateTime(widget.year, 1, 1);
    var endingDate = DateTime(widget.year + 1, 1, 1);
    final Iterable<CallLogEntry> result = await CallLog.query(
      dateFrom: startingDate.millisecondsSinceEpoch,
      dateTo: endingDate.millisecondsSinceEpoch,
    );

    for (var i = 0; i < result.length; i++) {
      var monthName = _getMonthName(DateTime.fromMillisecondsSinceEpoch(
          result.elementAtOrNull(i)?.timestamp ?? 0));

      _monthlyCallLogEntries[monthName] ??= [];
      _monthlyCallLogEntries[monthName]!.add(result.elementAtOrNull(i)!);
    }

    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _monthlyCallLogEntries = {};
    readCallLog();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.year} Recap"),
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ListView.separated(
                itemBuilder: (context, index) {
                  String month = _monthlyCallLogEntries.keys.elementAt(index);
                  return Card(
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(
                            month,
                            style: const TextStyle(
                              fontSize: 25,
                            ),
                          ),
                          subtitle: TotalTime(
                            callLogEntries: _monthlyCallLogEntries[month]!,
                          ),
                        ),
                        const Divider(),
                        IncomingOutgoingCalls(
                          callLogEntries: _monthlyCallLogEntries[month]!,
                        ),
                        const Divider(),
                        BusiestDay(
                          month: month,
                          callLogEntries: _monthlyCallLogEntries[month]!,
                        ),
                        const Divider(),
                        MostTalkedPerson(
                          callLogEntries: _monthlyCallLogEntries[month]!,
                        )
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    height: 10,
                  );
                },
                itemCount: _monthlyCallLogEntries.keys.length,
              ),
            ),
    );
  }
}
