import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_recap/features/behavioral_patterns/behavioral_patterns.dart';
import 'package:shimmer/shimmer.dart';

class BehavioralPatternsPage extends StatelessWidget {
  const BehavioralPatternsPage({super.key});

  static MaterialPageRoute<BehavioralPatternsPage> route() =>
      MaterialPageRoute(builder: (context) => const BehavioralPatternsPage());

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BehavioralPatternsBloc(),
      child: const BehavioralPatternsView(),
    );
  }
}

class BehavioralPatternsView extends StatefulWidget {
  const BehavioralPatternsView({super.key});

  @override
  State<BehavioralPatternsView> createState() => _BehavioralPatternsViewState();
}

class _BehavioralPatternsViewState extends State<BehavioralPatternsView> {
  @override
  void initState() {
    super.initState();
    context.read<BehavioralPatternsBloc>().add(
      BehavioralPatternsFrequencyHeatmapEvent(callType: "all"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Behavioral Patterns'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            BlocBuilder<BehavioralPatternsBloc, BehavioralPatternsState>(
              builder: (context, state) {
                return Card(
                  child: DropdownMenu<String>(
                    width: double.infinity,
                    leadingIcon: Icon(
                      Icons.filter_alt,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    inputDecorationTheme: const InputDecorationTheme(
                      border: InputBorder.none,
                    ),
                    initialSelection: "all",
                    onSelected: (String? value) {
                      context.read<BehavioralPatternsBloc>().add(
                        BehavioralPatternsFrequencyHeatmapEvent(
                          callType: value ?? "all",
                        ),
                      );
                    },
                    dropdownMenuEntries: [
                      DropdownMenuEntry(value: "all", label: "All"),
                      DropdownMenuEntry(
                        value: CallType.incoming.name,
                        label: "Incoming",
                      ),
                      DropdownMenuEntry(
                        value: CallType.outgoing.name,
                        label: "Outgoing",
                      ),
                    ],
                  ),
                );
              },
            ),
            Expanded(
              child: Card(
                child: BlocBuilder<
                  BehavioralPatternsBloc,
                  BehavioralPatternsState
                >(
                  builder: (context, state) {
                    if (state.status == Status.loading) {
                      return Shimmer.fromColors(
                        enabled: true,
                        direction: ShimmerDirection.ltr,
                        baseColor:
                            Theme.of(context).colorScheme.brightness ==
                                    Brightness.dark
                                ? Theme.of(context).colorScheme.surfaceBright
                                : Theme.of(context).colorScheme.surfaceDim,
                        highlightColor:
                            Theme.of(context).colorScheme.brightness ==
                                    Brightness.dark
                                ? Theme.of(
                                  context,
                                ).colorScheme.surfaceContainerHigh
                                : Theme.of(
                                  context,
                                ).colorScheme.surfaceContainerHigh,
                        child: SizedBox(width: double.infinity),
                      );
                    } else if (state.status == Status.error) {
                      return const Center(child: Text("Error"));
                    } else {
                      return SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                ListTile(
                                  title: Text(
                                    "When is the time you call most often?",
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ),
                                FrequencyHeatmap(
                                  frequencyHeatmap: state.frequencyHeatmap,
                                ),
                                Divider(),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
