import 'package:flutter/material.dart';

class PercentBar extends StatelessWidget {
  const PercentBar({super.key, required this.incoming, required this.outgoing});

  final int incoming;
  final int outgoing;

  List<int> calculateRatio() {
    // Calculate the ratio
    double incomingratio = (incoming / (incoming + outgoing)) * 8;
    double outgoingratio = (outgoing / (incoming + outgoing)) * 8;

    // Return the result as a list
    return [incomingratio.round(), outgoingratio.round()];
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

  @override
  Widget build(BuildContext context) {
    List<int> result = calculateRatio();
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
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
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
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
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
