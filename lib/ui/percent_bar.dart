import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';

class PercentBar extends StatefulWidget {
  const PercentBar({
    Key? key,
    required this.index,
    required this.monthlyCallLogEntries,
  }) : super(key: key);

  final int index;
  final Map<String, List<CallLogEntry>> monthlyCallLogEntries;

  @override
  State<PercentBar> createState() => _PercentBarState();
}

class _PercentBarState extends State<PercentBar> {
  int getTotalTime(String month, int callTypeIndex) {
    int totalTime = 0;
    final logEntries = widget.monthlyCallLogEntries[month];
    if (logEntries != null) {
      for (final entry in logEntries) {
        if (entry.callType?.index == callTypeIndex) {
          totalTime += entry.duration ?? 0;
        }
      }
    }
    return totalTime;
  }

  String formatSeconds(int seconds) {
    final hours = seconds ~/ 3600;
    final remainingMinutes = (seconds % 3600) ~/ 60;

    if (hours == 0) {
      return "$remainingMinutes minute${remainingMinutes == 1 ? '' : 's'}";
    } else {
      return "$hours hour${hours == 1 ? '' : 's'}, $remainingMinutes minute${remainingMinutes == 1 ? '' : 's'}";
    }
  }

  @override
  Widget build(BuildContext context) {
    final month = widget.monthlyCallLogEntries.keys.elementAt(widget.index);
    final incoming = getTotalTime(month, 0);
    final outgoing = getTotalTime(month, 1);

    List<int> calculateRatio() {
      final incomingRatio = (incoming / (incoming + outgoing)) * 8;
      final outgoingRatio = (outgoing / (incoming + outgoing)) * 8;

      return [incomingRatio.round(), outgoingRatio.round()];
    }

    final result = calculateRatio();
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 20,
              width: MediaQuery.of(context).size.width * result[0] * .1,
              child: Card(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                ),
              ),
            ),
            SizedBox(
              height: 20,
              width: MediaQuery.of(context).size.width * result[1] * .1,
              child: Card(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                ),
              ),
            ),
          ],
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("Incoming Calls"),
            Text("Outgoing Calls"),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              formatSeconds(incoming),
              style: const TextStyle(fontSize: 10),
            ),
            Text(
              formatSeconds(outgoing),
              style: const TextStyle(fontSize: 10),
            ),
          ],
        )
      ],
    );
  }
}
