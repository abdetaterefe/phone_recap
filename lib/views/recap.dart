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

  @override
  void initState() {
    super.initState();
    readCallLog();
  }

  @override
  Widget build(BuildContext context) {
    const TextStyle mono = TextStyle(fontFamily: 'monospace');
    return Scaffold(
      appBar: AppBar(title: const Text('Phone Recap')),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: ListView.separated(
                    scrollDirection: Axis.vertical,
                    itemBuilder: (ctx, i) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            const Divider(),
                            Text(
                              'F. NUMBER  : ${_callLogEntries.elementAt(i).formattedNumber}',
                              style: mono,
                            ),
                            Text(
                              'NUMBER     : ${_callLogEntries.elementAt(i).number}',
                              style: mono,
                            ),
                            Text(
                                'NAME       : ${_callLogEntries.elementAt(i).name}',
                                style: mono),
                            Text(
                              'TYPE       : ${_callLogEntries.elementAt(i).callType}',
                              style: mono,
                            ),
                            Text(
                              'DATE       : ${DateTime.fromMillisecondsSinceEpoch(_callLogEntries.elementAt(i).timestamp!)}',
                              style: mono,
                            ),
                            Text(
                              'DURATION   : ${_callLogEntries.elementAt(i).duration}',
                              style: mono,
                            ),
                            Text(
                              'SIM NAME   : ${_callLogEntries.elementAt(i).simDisplayName}',
                              style: mono,
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (ctx, i) {
                      return const SizedBox(
                        height: 10,
                      );
                    },
                    itemCount: _callLogEntries.length,
                  ),
                ),
              ],
            ),
    );
  }
}
