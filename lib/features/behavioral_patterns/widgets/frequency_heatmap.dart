import 'package:flutter/material.dart';

class FrequencyHeatmap extends StatelessWidget {
  const FrequencyHeatmap({super.key, required this.frequencyHeatmap});

  final Map<int, Map<int, int>> frequencyHeatmap;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.5,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TimeLegend(),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              children: [
                _DayLabels(),
                const SizedBox(height: 4),
                Expanded(child: _HeatmapGrid(data: frequencyHeatmap)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TimeLegend extends StatelessWidget {
  const _TimeLegend();

  @override
  Widget build(BuildContext context) {
    final List<String> labels = ['12:00AM', '6:00AM', '12:00PM', '6:00PM'];

    return SizedBox(
      height: 210,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.end,
        children:
            labels
                .map(
                  (label) => Text(
                    label,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                )
                .toList(),
      ),
    );
  }
}

class _DayLabels extends StatelessWidget {
  const _DayLabels();

  @override
  Widget build(BuildContext context) {
    final List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Row(
      children:
          days
              .map(
                (day) => Expanded(
                  child: Center(
                    child: Text(
                      day,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
    );
  }
}

class _HeatmapGrid extends StatelessWidget {
  final Map<int, Map<int, int>> data;

  const _HeatmapGrid({required this.data});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 2,
        childAspectRatio: 6,
        crossAxisSpacing: 2,
      ),
      itemCount: 7 * 24,
      itemBuilder: (context, index) {
        final dayOfWeek = (index % 7) + 1;
        final hourOfDay = index ~/ 7;

        final intensity = data[dayOfWeek]?[hourOfDay] ?? 0;
        final baseColor = Theme.of(context).colorScheme.primary;

        return Container(
          decoration: BoxDecoration(
            color:
                intensity >= 0
                    ? baseColor.withAlpha(intensity)
                    : Theme.of(context).colorScheme.primary.withAlpha(10),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color:
                  Theme.of(context).colorScheme.brightness == Brightness.dark
                      ? Colors.white.withAlpha(50)
                      : Colors.black.withAlpha(50),
              width: 0.5,
            ),
          ),
        );
      },
    );
  }
}
