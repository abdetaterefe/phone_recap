import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';

class IncomingOutgoingCalls extends StatefulWidget {
  const IncomingOutgoingCalls({
    required this.callLogEntries,
    super.key,
  });

  final List<CallLogEntry> callLogEntries;

  @override
  State<IncomingOutgoingCalls> createState() => _IncomingOutgoingCallsState();
}

class _IncomingOutgoingCallsState extends State<IncomingOutgoingCalls> {
  int getTotalTime(int callTypeIndex) {
    var totalTime = 0;
    final logEntries = widget.callLogEntries;
    for (final entry in logEntries) {
      if (entry.callType?.index == callTypeIndex) {
        totalTime += entry.duration ?? 0;
      }
    }
    return totalTime;
  }

  int getTotalCount(int callTypeIndex) {
    var totalCount = 0;
    final logEntries = widget.callLogEntries;
    for (final entry in logEntries) {
      if (entry.callType?.index == callTypeIndex) {
        totalCount += 1;
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
      // ignore: lines_longer_than_80_chars
      return "$hours hour${hours == 1 ? '' : 's'}, $remainingMinutes minute${remainingMinutes == 1 ? '' : 's'}";
    }
  }

  @override
  Widget build(BuildContext context) {
    final incoming = getTotalTime(0);
    final outgoing = getTotalTime(1);

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
              height: 20,
              decoration: const BoxDecoration(
                color: Colors.lightGreenAccent,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4),
                  bottomLeft: Radius.circular(4),
                ),
              ),
              width: MediaQuery.of(context).size.width * result[0] * .1,
            ),
            Container(
              height: 20,
              decoration: const BoxDecoration(
                color: Colors.greenAccent,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(4),
                  bottomRight: Radius.circular(4),
                ),
              ),
              width: MediaQuery.of(context).size.width * result[1] * .1,
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              children: [
                const Text('Incoming Calls: '),
                Text(
                  getTotalCount(0).toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Text('Outgoing Calls: '),
                Text(
                  getTotalCount(1).toString(),
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
        ),
      ],
    );
  }
}
