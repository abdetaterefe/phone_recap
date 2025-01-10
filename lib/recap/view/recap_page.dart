import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.year.toString()),
      ),
      body: BlocBuilder<recap.RecapBloc, recap.RecapState>(
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
              separatorBuilder: (context, index) {
                return const SizedBox(
                  height: 10,
                );
              },
              itemBuilder: (context, index) {
                final month = state.recapList.keys.elementAt(index);
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
                          callLogEntries: state.recapList[month]!,
                        ),
                      ),
                      const Divider(),
                      IncomingOutgoingCalls(
                        callLogEntries: state.recapList[month]!,
                      ),
                      const Divider(),
                      BusiestDay(
                        month: month,
                        callLogEntries: state.recapList[month]!,
                      ),
                      const Divider(),
                      MostTalkedPerson(
                        callLogEntries: state.recapList[month]!,
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context
              .read<recap.RecapBloc>()
              .add(recap.RecapGetCallRecap(year: widget.year));
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
