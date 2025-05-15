import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:phone_recap/core/utils/time.dart';

class CallDistributionSection extends StatelessWidget {
  const CallDistributionSection({super.key, required this.entries});

  final List<CallLogEntry> entries;

  Iterable<CallLogEntry> get incommingCalls =>
      entries.where((entry) => entry.callType == CallType.incoming);

  int get incommingCallsDuration =>
      incommingCalls.fold<int>(0, (sum, entry) => sum + (entry.duration ?? 0));

  Iterable<CallLogEntry> get outgoingCalls =>
      entries.where((entry) => entry.callType == CallType.outgoing);

  int get outgoingCallsDuration =>
      outgoingCalls.fold<int>(0, (sum, entry) => sum + (entry.duration ?? 0));

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Call Distribution",
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Card.outlined(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const Text("Incoming"),
                      const Divider(),
                      Text(
                        "${incommingCalls.length.toString()} Calls",
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      Text(
                        TimeUtils.formatDuration(incommingCallsDuration),
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Card.outlined(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const Text("Outgoing"),
                      const Divider(),
                      Text(
                        "${outgoingCalls.length.toString()} Calls",
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      Text(
                        TimeUtils.formatDuration(outgoingCallsDuration),
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
