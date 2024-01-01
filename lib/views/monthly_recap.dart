import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';

class MonthlyRecap extends StatefulWidget {
  const MonthlyRecap({super.key});

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

  int totalTime(String month) {
    int totalTime = 0;
    int? logEntryLength = _monthlyCallLogEntries[month]?.length;
    for (var i = 0; i < logEntryLength!; i++) {
      totalTime += _monthlyCallLogEntries[month]!.elementAt(i).duration!;
    }
    return totalTime;
  }

  String formatSeconds(int seconds) {
    if (seconds < 0) {
      return "Invalid input";
    }

    int hours = seconds ~/ 3600;
    int remainingMinutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;

    if (hours == 0) {
      if (remainingMinutes == 0) {
        return "$remainingSeconds second${remainingSeconds == 1 ? '' : 's'}";
      } else if (remainingSeconds == 0) {
        return "$remainingMinutes minute${remainingMinutes == 1 ? '' : 's'}";
      } else {
        return "$remainingMinutes minute${remainingMinutes == 1 ? '' : 's'} and $remainingSeconds second${remainingSeconds == 1 ? '' : 's'}";
      }
    } else {
      return "$hours hour${hours == 1 ? '' : 's'}, $remainingMinutes minute${remainingMinutes == 1 ? '' : 's'}, and $remainingSeconds second${remainingSeconds == 1 ? '' : 's'}";
    }
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
    var startingDate = DateTime(2023, 1, 1);
    var endingDate = DateTime(2024, 1, 1);
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
                itemBuilder: (context, i) {
                  return ListTile(
                    title: Text(_monthlyCallLogEntries.keys.elementAt(i)),
                    subtitle: Text(
                        "Total time: ${formatSeconds(totalTime(_monthlyCallLogEntries.keys.elementAt(i)))}"),
                    trailing: Column(
                      children: [
                        Text(
                          "Most talked to person: ${mostTalkedToPerson(_monthlyCallLogEntries.keys.elementAt(i)).name}",
                        ),
                        Text(
                          "Total Time: ${formatSeconds(mostTalkedToPerson(_monthlyCallLogEntries.keys.elementAt(i)).duration!)}",
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, i) {
                  return const Divider();
                },
                itemCount: _monthlyCallLogEntries.keys.length,
              ),
            ),
    );
  }
}
