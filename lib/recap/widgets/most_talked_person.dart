import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';

class MostTalkedPerson extends StatefulWidget {
  const MostTalkedPerson({required this.callLogEntries, super.key});

  final List<CallLogEntry> callLogEntries;

  @override
  State<MostTalkedPerson> createState() => _MostTalkedPersonState();
}

class _MostTalkedPersonState extends State<MostTalkedPerson> {
  String formatSeconds(int seconds) {
    final hours = seconds ~/ 3600;
    final remainingMinutes = (seconds % 3600) ~/ 60;

    if (hours == 0) {
      return "$remainingMinutes minute${remainingMinutes == 1 ? '' : 's'}";
    } else {
      return "$hours hour${hours == 1 ? '' : 's'}, $remainingMinutes minute${remainingMinutes == 1 ? '' : 's'}";
    }
  }

  CallLogEntry longestCalledPerson() {
    var longestCalledPerson = widget.callLogEntries.first;
    for (var i = 1; i < widget.callLogEntries.length; i++) {
      if (longestCalledPerson.duration! < widget.callLogEntries[i].duration!) {
        longestCalledPerson = widget.callLogEntries[i];
      }
    }

    return longestCalledPerson;
  }

  Map<String, int> mostTalkedPerson() {
    final mostTalkedToPersonMap = <String, int>{};
    for (var i = 0; i < widget.callLogEntries.length; i++) {
      final callLogEntry = widget.callLogEntries[i];
      final key = callLogEntry.name ?? callLogEntry.number!;
      mostTalkedToPersonMap[key] ??= 0;
      mostTalkedToPersonMap[key] =
          mostTalkedToPersonMap[key]! + callLogEntry.duration!;
    }
    final sortedEntries = mostTalkedToPersonMap.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final sortedMap = Map.fromEntries(sortedEntries);
    return sortedMap;
  }

  Map<String, int> mostCalledPerson(int callTypeIndex) {
    final mostCalledPersonMap = <String, int>{};

    for (var i = 0; i < widget.callLogEntries.length; i++) {
      final callLogEntry = widget.callLogEntries[i];
      final key = callLogEntry.name ?? callLogEntry.number!;
      if (widget.callLogEntries[i].callType?.index == callTypeIndex) {
        mostCalledPersonMap[key] ??= 0;
        mostCalledPersonMap[key] = mostCalledPersonMap[key]! + 1;
      }
    }

    final sortedEntries = mostCalledPersonMap.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final sortedMap = Map.fromEntries(sortedEntries);
    return sortedMap;
  }

  @override
  Widget build(BuildContext context) {
    final incoming = mostCalledPerson(0);
    final outgoing = mostCalledPerson(1);
    return Column(
      children: [
        ListTile(
          title: const Text('Longest Call'),
          subtitle: Text(
            "${longestCalledPerson().name ?? longestCalledPerson().number!}: ${longestCalledPerson().callType?.index == 0 ? "incoming" : "outgoing"}",
          ),
          trailing: Text(
            formatSeconds(
              longestCalledPerson().duration!,
            ),
          ),
        ),
        ListTile(
          title: const Text('Most Called'),
          subtitle: Text(
            mostTalkedPerson().keys.first,
          ),
          trailing: Text(
            formatSeconds(
              mostTalkedPerson()[mostTalkedPerson().keys.first]!,
            ),
          ),
        ),
        ListTile(
          title: const Text('Most Incoming'),
          subtitle: Text(
            incoming.keys.first,
          ),
          trailing: Text(
            '${incoming[incoming.keys.first]} times',
          ),
        ),
        ListTile(
          title: const Text('Most Outgoing'),
          subtitle: Text(
            outgoing.keys.first,
          ),
          trailing: Text(
            '${outgoing[outgoing.keys.first]} times',
          ),
        ),
      ],
    );
  }
}
