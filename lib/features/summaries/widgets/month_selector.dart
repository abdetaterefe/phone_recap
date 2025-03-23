import 'package:flutter/material.dart';

class MonthSelector extends StatelessWidget {
  const MonthSelector({
    super.key,
    required this.date,
    required this.onPreviousMonth,
    required this.onNextMonth,
  });

  final String date;
  final Function onPreviousMonth;
  final Function onNextMonth;

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
            IconButton.filled(
              onPressed: () => onNextMonth(),
              icon: const Icon(Icons.arrow_right_rounded),
            ),
          ],
        ),
      ),
    );
  }
}
