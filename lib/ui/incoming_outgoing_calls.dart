import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';

class IncomingOutgoingCalls extends StatefulWidget {
  const IncomingOutgoingCalls({
    Key? key,
    required this.index,
    required this.monthlyCallLogEntries,
  }) : super(key: key);

  final int index;
  final Map<String, List<CallLogEntry>> monthlyCallLogEntries;

  @override
  State<IncomingOutgoingCalls> createState() => _IncomingOutgoingCallsState();
}

class _IncomingOutgoingCallsState extends State<IncomingOutgoingCalls> {
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

  int getTotalCount(String month, int callTypeIndex) {
    int totalCount = 0;
    final logEntries = widget.monthlyCallLogEntries[month];
    if (logEntries != null) {
      for (final entry in logEntries) {
        if (entry.callType?.index == callTypeIndex) {
          totalCount += 1;
        }
      }
    }
    return totalCount;
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
            Container(
              height: 10,
              decoration: const BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(0),
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(0),
                ),
              ),
              width: MediaQuery.of(context).size.width * result[0] * .1,
            ),
            Container(
              height: 10,
              decoration: const BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(0),
                  topRight: Radius.circular(8),
                  bottomLeft: Radius.circular(0),
                  bottomRight: Radius.circular(8),
                ),
              ),
              width: MediaQuery.of(context).size.width * result[1] * .1,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              children: [
                const Text("Incoming Calls: "),
                Text(
                  getTotalCount(month, 0).toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Text("Outgoing Calls: "),
                Text(
                  getTotalCount(month, 1).toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
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
