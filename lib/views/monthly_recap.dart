import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:phone_recap/ui/incoming_outgoing_calls.dart';
import 'package:phone_recap/ui/total_time.dart';

class MonthlyRecap extends StatefulWidget {
  const MonthlyRecap({Key? key, required this.year}) : super(key: key);

  final int year;

  @override
  State<MonthlyRecap> createState() => _MonthlyRecapState();
}

class _MonthlyRecapState extends State<MonthlyRecap> {
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

  CallLogEntry mostTalkedToPerson(String month) {
    CallLogEntry mostTalkedToPerson =
        _monthlyCallLogEntries[month]!.elementAt(0);
    int? logEntryLength = _monthlyCallLogEntries[month]?.length;
    for (var i = 0; i < logEntryLength!; i++) {
      if (mostTalkedToPerson.duration! <
          _monthlyCallLogEntries[month]!.elementAt(i).duration!) {
        mostTalkedToPerson = _monthlyCallLogEntries[month]!.elementAt(i);
      }
    }
    return mostTalkedToPerson;
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
        title: const Text("Monthly Recap"),
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SizedBox(
              height: MediaQuery.of(context).size.height,
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                    ),
                    child: SizedBox(
                      width: 300,
                      height: 300,
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(
                              _monthlyCallLogEntries.keys.elementAt(index),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                              ),
                            ),
                          ),
                          const Divider(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                TotalTime(
                                  monthlyCallLogEntries: _monthlyCallLogEntries,
                                  index: index,
                                ),
                                IncomingOutgoingCalls(
                                  monthlyCallLogEntries: _monthlyCallLogEntries,
                                  index: index,
                                ),
                                const Divider(),
                              ],
                            ),
                          ),
                        ],
                      ),
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
