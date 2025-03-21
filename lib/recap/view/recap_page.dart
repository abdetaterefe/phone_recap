import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_recap/app/view/ads.dart';
import 'package:phone_recap/recap/recap.dart' as recap;
import 'package:phone_recap/recap/recap.dart';

class RecapPage extends StatelessWidget {
  const RecapPage({required this.year, super.key});
  final int year;
  static MaterialPageRoute<RecapPage> route(int year) => MaterialPageRoute(
        builder: (context) => RecapPage(year: year),
      );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => recap.RecapBloc(),
      child: RecapView(year: year),
    );
  }
}

class RecapView extends StatefulWidget {
  const RecapView({required this.year, super.key});
  final int year;

  @override
  State<RecapView> createState() => _RecapViewState();
}

class _RecapViewState extends State<RecapView> {
  @override
  void initState() {
    super.initState();
    context
        .read<recap.RecapBloc>()
        .add(recap.RecapGetCallRecap(year: widget.year));
  }

  @override
  Widget build(BuildContext context) {
    return PersistentBannerAdScaffold(
      appBarTitle: widget.year.toString(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context
              .read<recap.RecapBloc>()
              .add(recap.RecapGetCallRecap(year: widget.year));
        },
        child: const Icon(Icons.refresh),
      ),
      child: BlocBuilder<recap.RecapBloc, recap.RecapState>(
        builder: (context, state) {
          if (state.recapListStatus == recap.Status.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.recapListStatus == recap.Status.error) {
            return const Center(child: Text('Failed to load Recap.'));
          } else if (state.recapList.isEmpty) {
            return const Center(child: Text('No call data available.'));
          } else {
            return ListView.separated(
              itemCount: state.recapList.length,
              padding: const EdgeInsets.all(8),
              separatorBuilder: (context, index) {
                return const SizedBox(
                  height: 10,
                );
              },
              itemBuilder: (context, index) {
                final month = state.recapList.keys.elementAt(index);
                final callLogEntries = state.recapList[month] ?? [];
                return Card(
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          month,
                          style: const TextStyle(
                            fontSize: 25,
                          ),
                        ),
                        subtitle: TotalTime(
                          callLogEntries: callLogEntries,
                        ),
                      ),
                      const Divider(),
                      IncomingOutgoingCalls(
                        callLogEntries: callLogEntries,
                      ),
                      const Divider(),
                      BusiestDay(
                        month: month,
                        callLogEntries: callLogEntries,
                      ),
                      const Divider(),
                      MostTalkedPerson(
                        callLogEntries: callLogEntries,
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
