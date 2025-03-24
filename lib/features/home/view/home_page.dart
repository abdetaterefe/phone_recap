import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_recap/features/home/home.dart';
import 'package:shimmer/shimmer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  static MaterialPageRoute<HomePage> route() =>
      MaterialPageRoute(builder: (context) => HomePage());

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => HomeBloc(), child: const HomeView());
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
    context.read<HomeBloc>().add(HomeLoadTotalStatsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: BlocBuilder<HomeBloc, HomeState>(
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
                child: Column(
                  children: <Widget>[
                    SummarySection(
                      totalDuration: state.totalDuration,
                      averageDuration: state.averageDuration,
                    ),
                    TopContactsSection(
                      topContactsByDuration: state.topContactsByDuration,
                    ),
                    CallVolumeChartSection(
                      callVolumeChartData: state.callVolumeChartData,
                    ),
                  ],
                ),
              );
            }
            if (state.status == Status.error) {
              return const Center(child: Text('Error fetching data'));
            } else {
              return Column(
                children: <Widget>[
                  SummarySection(
                    totalDuration: state.totalDuration,
                    averageDuration: state.averageDuration,
                  ),
                  TopContactsSection(
                    topContactsByDuration: state.topContactsByDuration,
                  ),
                  CallVolumeChartSection(
                    callVolumeChartData: state.callVolumeChartData,
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
