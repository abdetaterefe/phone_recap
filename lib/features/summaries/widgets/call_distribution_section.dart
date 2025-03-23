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
        ListTile(
          title: Text(
            "Call Distribution",
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
        ),
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
                      ListTile(
                        title: Text(
                          incommingCalls.length.toString(),
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        subtitle: Text(
                          TimeUtils.formatDuration(incommingCallsDuration),
                          style: TextStyle(fontSize: 12),
                        ),
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
                      ListTile(
                        title: Text(
                          outgoingCalls.length.toString(),
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        subtitle: Text(
                          TimeUtils.formatDuration(outgoingCallsDuration),
                          style: TextStyle(fontSize: 12),
                        ),
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
