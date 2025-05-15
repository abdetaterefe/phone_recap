import 'package:flutter/material.dart';

class MonthSelector extends StatelessWidget {
  const MonthSelector({
    super.key,
    required this.date,
    required this.onPreviousMonth,
    required this.onNextMonth,
    required this.onToday,
  });

  final String date;
  final Function onPreviousMonth;
  final Function onNextMonth;
  final Function onToday;

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton.filled(
              onPressed: () => onPreviousMonth(),
              icon: const Icon(Icons.arrow_left_rounded),
            ),
            Text(date, style: Theme.of(context).textTheme.titleLarge),
            Row(
              children: [
                IconButton.filled(
                  onPressed: () => onNextMonth(),
                  icon: const Icon(Icons.arrow_right_rounded),
                ),
                IconButton.filled(
                  onPressed: () => onToday(),
                  icon: const Icon(Icons.today_rounded),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
