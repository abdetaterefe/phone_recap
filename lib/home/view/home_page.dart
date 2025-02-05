import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_recap/settings/settings.dart' as settings;
import 'package:phone_recap/home/home.dart' as home;
import 'package:phone_recap/recap/recap.dart' as recap;

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => home.HomeBloc(),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    context.read<home.HomeBloc>().add(home.HomeGetCallYears());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, settings.SettingsPage.route());
            },
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: BlocBuilder<home.HomeBloc, home.HomeState>(
        builder: (context, state) {
          if (state.yearsListStatus == home.Status.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.yearsListStatus == home.Status.error) {
            return const Center(child: Text('Failed to load years.'));
          } else if (state.yearsList.isEmpty) {
            return const Center(child: Text('No call data available.'));
          } else {
            return ListView.separated(
              itemCount: state.yearsList.length,
              separatorBuilder: (context, index) {
                return const SizedBox(height: 10);
              },
              itemBuilder: (context, index) {
                final year = state.yearsList[index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          title: Text(
                            year.toString(),
                            style: const TextStyle(fontSize: 25),
                          ),
                          subtitle: const Text('View recap of this year.'),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            FilledButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  recap.RecapPage.route(year),
                                );
                              },
                              child: const Text('View Recap'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<home.HomeBloc>().add(home.HomeGetCallYears());
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
