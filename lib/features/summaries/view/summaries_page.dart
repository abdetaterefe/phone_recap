import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_recap/features/summaries/summaries.dart';
import 'package:shimmer/shimmer.dart';

class SummariesPage extends StatelessWidget {
  const SummariesPage({super.key});
  static MaterialPageRoute<SummariesPage> route() =>
      MaterialPageRoute(builder: (context) => SummariesPage());

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => SummariesBloc(), child: SummariesView());
  }
}

class SummariesView extends StatefulWidget {
  const SummariesView({super.key});

  @override
  State<SummariesView> createState() => _SummariesViewState();
}

class _SummariesViewState extends State<SummariesView> {
  @override
  void initState() {
    super.initState();
    context.read<SummariesBloc>().add(SummariesLoadEvent());
  }

  String _currentMonth = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: BlocConsumer<SummariesBloc, SummariesState>(
            listenWhen:
                (previous, current) =>
                    current.status == Status.complete &&
                    current.summaries.isNotEmpty &&
                    _currentMonth.isEmpty,
            listener: (context, state) {
              if (state.status == Status.complete &&
                  state.summaries.isNotEmpty &&
                  _currentMonth.isEmpty) {
                setState(() {
                  _currentMonth = state.summaries.keys.last;
                });
              }
            },
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
                          ? Theme.of(context).colorScheme.surfaceContainerHigh
                          : Theme.of(context).colorScheme.surfaceContainerHigh,
                  child: Column(
                    children: [
                      MonthSelector(
                        date: "",
                        onPreviousMonth: () {},
                        onNextMonth: () {},
                        onToday: () {},
                      ),
                      Expanded(
                        child: Card(
                          child: SizedBox(
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const TotalSummaryTile(entries: []),
                                    const Divider(),
                                    CallDistributionSection(entries: []),
                                    const Divider(),
                                    MoreSection(entries: []),
                                    const Divider(),
                                    CalendarSection(
                                      entries: [],
                                      currentMonth: "",
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
              if (state.status == Status.error) {
                return const Center(child: Text('Error fetching data'));
              } else {
                final months = state.summaries.keys.toList();
                final currentIndex = months.indexOf(_currentMonth);
                return Column(
                  children: [
                    MonthSelector(
                      date: _currentMonth,
                      onPreviousMonth: () {
                        if (currentIndex > 0) {
                          setState(() {
                            _currentMonth = months[currentIndex - 1];
                          });
                        }
                      },
                      onNextMonth: () {
                        if (currentIndex < months.length - 1) {
                          setState(() {
                            _currentMonth = months[currentIndex + 1];
                          });
                        }
                      },
                      onToday: () {
                        setState(() {
                          _currentMonth =
                              context
                                  .read<SummariesBloc>()
                                  .state
                                  .summaries
                                  .keys
                                  .last;
                        });
                      },
                    ),
                    Expanded(
                      child: Card(
                        child: SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TotalSummaryTile(
                                    entries:
                                        state.summaries[_currentMonth] ?? [],
                                  ),
                                  const Divider(),
                                  CallDistributionSection(
                                    entries:
                                        state.summaries[_currentMonth] ?? [],
                                  ),
                                  const Divider(),
                                  MoreSection(
                                    entries:
                                        state.summaries[_currentMonth] ?? [],
                                  ),
                                  const Divider(),
                                  CalendarSection(
                                    entries:
                                        state.summaries[_currentMonth] ?? [],
                                    currentMonth: _currentMonth,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
