import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';

class TotalTime extends StatefulWidget {
  const TotalTime({
    Key? key,
    required this.callLogEntries,
  }) : super(key: key);

  final List<CallLogEntry> callLogEntries;

  @override
  State<TotalTime> createState() => _TotalTimeState();
}

class _TotalTimeState extends State<TotalTime> {
  String formatSeconds(int seconds) {
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

  int totalTime() {
    int totalTime = 0;
    int? logEntryLength = widget.callLogEntries.length;
    for (var i = 0; i < logEntryLength; i++) {
      totalTime += widget.callLogEntries.elementAt(i).duration!;
    }
    return totalTime;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text("Total time: "),
        Text(
          formatSeconds(totalTime()),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
