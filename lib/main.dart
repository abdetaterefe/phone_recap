import 'package:flutter/material.dart';
import 'package:call_log/call_log.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Iterable<CallLogEntry> _callLogEntries = <CallLogEntry>[];
  var now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    const TextStyle mono = TextStyle(fontFamily: 'monospace');

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Phone Recap')),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      final Iterable<CallLogEntry> result =
                          await CallLog.query();
                      setState(() {
                        _callLogEntries = result;
                      });
                    },
                    child: const Text('Get all'),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
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
                              style: mono),
                          Text(
                              'NUMBER     : ${_callLogEntries.elementAt(i).number}',
                              style: mono),
                          Text(
                              'NAME       : ${_callLogEntries.elementAt(i).name}',
                              style: mono),
                          Text(
                              'TYPE       : ${_callLogEntries.elementAt(i).callType}',
                              style: mono),
                          Text(
                            'DATE       : ${DateTime.fromMillisecondsSinceEpoch(_callLogEntries.elementAt(i).timestamp!)}',
                            style: mono,
                          ),
                          Text(
                              'DURATION   : ${_callLogEntries.elementAt(i).duration}',
                              style: mono),
                          Text(
                              'SIM NAME   : ${_callLogEntries.elementAt(i).simDisplayName}',
                              style: mono),
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
        ),
      ),
    );
  }
}
