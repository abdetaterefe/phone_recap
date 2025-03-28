import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_recap/features/advanced_metrics/advanced_metrics.dart';
import 'package:shimmer/shimmer.dart';

class AdvancedMetricsPage extends StatelessWidget {
  const AdvancedMetricsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AdvancedMetricsBloc(),
      child: AdvancedMetricsView(),
    );
  }
}

class AdvancedMetricsView extends StatefulWidget {
  const AdvancedMetricsView({super.key});

  @override
  State<AdvancedMetricsView> createState() => _AdvancedMetricsViewState();
}

class _AdvancedMetricsViewState extends State<AdvancedMetricsView> {
  @override
  void initState() {
    super.initState();
    context.read<AdvancedMetricsBloc>().add(AdvancedMetricsLoadEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Advanced Metrics')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: BlocBuilder<AdvancedMetricsBloc, AdvancedMetricsState>(
          builder: (context, state) {
            if (state.status == Status.loading) {
              return Shimmer.fromColors(
                enabled: true,
                direction: ShimmerDirection.ltr,
                baseColor:
                    Theme.of(context).colorScheme.brightness == Brightness.dark
                        ? Theme.of(context).colorScheme.surfaceBright
                        : Theme.of(context).colorScheme.surfaceDim,
                highlightColor:
                    Theme.of(context).colorScheme.brightness == Brightness.dark
                        ? Theme.of(context).colorScheme.surfaceContainerHigh
                        : Theme.of(context).colorScheme.surfaceContainerHigh,
                child: Card(
                  child: SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              );
            } else if (state.status == Status.error) {
              return const Center(child: Text("Error"));
            } else {
              return Card(
                child: SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            title: Text(
                              "Unanswered Calls Percentage",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                          UnansweredCallsChart(
                            missedCalls: state.missedCalls,
                            rejectedCalls: state.rejectedCalls,
                            blockedCalls: state.blockedCalls,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
