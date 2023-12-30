import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';

class RecapScreen extends StatefulWidget {
  const RecapScreen({Key? key, required this.recap}) : super(key: key);

  final String recap;

  @override
  State<RecapScreen> createState() => _RecapScreenState();
}

class _RecapScreenState extends State<RecapScreen> {
  Iterable<CallLogEntry> _callLogEntries = <CallLogEntry>[];
  int nowYear = DateTime.now().year;
  int nowMonth = DateTime.now().month;
  int nowDay = DateTime.now().day;
  int nowHour = DateTime.now().hour;
  int nowMinute = DateTime.now().minute;
  int nowSecond = DateTime.now().second;
  bool loading = true;

  Future<void> readCallLog() async {
    var thisMonthStartingDate = DateTime(nowYear, nowMonth, 1);
    var thisMonthEndingDate =
        DateTime(nowYear, nowMonth, nowDay, nowHour, nowMinute, nowSecond);
    final Iterable<CallLogEntry> result = await CallLog.query(
      dateFrom: thisMonthStartingDate.millisecondsSinceEpoch,
      dateTo: thisMonthEndingDate.millisecondsSinceEpoch,
    );

    setState(() {
      _callLogEntries = result;
      loading = false;
    });
  }

  int totalTime() {
    int totalTime = 0;
    for (var i = 0; i < _callLogEntries.length; i++) {
      totalTime += _callLogEntries.elementAt(i).duration!;
    }
    return totalTime;
  }

  CallLogEntry mostTalkedToPerson() {
    CallLogEntry mostTalkedToPerson = _callLogEntries.elementAt(0);
    for (var i = 0; i < _callLogEntries.length; i++) {
      if (mostTalkedToPerson.duration! <
          _callLogEntries.elementAt(i).duration!) {
        mostTalkedToPerson = _callLogEntries.elementAt(i);
      }
    }
    return mostTalkedToPerson;
  }

  @override
  void initState() {
    super.initState();
    readCallLog();
  }

  @override
  Widget build(BuildContext context) {
    const TextStyle mono = TextStyle(fontFamily: 'monospace');
    var totalTimeInMinutes = totalTime() / 60;
    var totalTimeInHours = totalTime() / 60 / 60;
    return Scaffold(
      appBar: AppBar(title: const Text('Monlthy Phone Recap')),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Text("Total Time In Minutes: $totalTimeInMinutes"),
                Text("Total Time In Hours: $totalTimeInHours"),
                SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          const Divider(),
                          Text(
                            'F. NUMBER  : ${mostTalkedToPerson().formattedNumber}',
                            style: mono,
                          ),
                          Text(
                            'NUMBER     : ${mostTalkedToPerson().number}',
                            style: mono,
                          ),
                          Text(
                            'NAME       : ${mostTalkedToPerson().name}',
                            style: mono,
                          ),
                          Text(
                            'TYPE       : ${mostTalkedToPerson().callType}',
                            style: mono,
                          ),
                          Text(
                            'DATE       : ${DateTime.fromMillisecondsSinceEpoch(mostTalkedToPerson().timestamp!)}',
                            style: mono,
                          ),
                          Text(
                            'DURATION   : ${mostTalkedToPerson().duration}',
                            style: mono,
                          ),
                          Text(
                            'SIM NAME   : ${mostTalkedToPerson().simDisplayName}',
                            style: mono,
                          ),
                        ],
                      ),
                    ))
              ],
            ),
    );
  }
}
