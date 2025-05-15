import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_recap/features/comparative_analytics/comparative_analytics.dart';
import 'package:shimmer/shimmer.dart';

class ComparativeAnalyticsPage extends StatelessWidget {
  const ComparativeAnalyticsPage({super.key});
  static MaterialPageRoute<ComparativeAnalyticsPage> route() =>
      MaterialPageRoute(builder: (context) => ComparativeAnalyticsPage());

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ComparativeAnalyticsBloc(),
      child: const ComparativeAnalyticsView(),
    );
  }
}

class ComparativeAnalyticsView extends StatefulWidget {
  const ComparativeAnalyticsView({super.key});

  @override
  State<ComparativeAnalyticsView> createState() =>
      _ComparativeAnalyticsViewState();
}

class _ComparativeAnalyticsViewState extends State<ComparativeAnalyticsView> {
  var visibilty = true;
  @override
  void initState() {
    super.initState();
    context.read<ComparativeAnalyticsBloc>().add(
      const ComparativeAnalyticsLoadContactsEvent(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocBuilder<
            ComparativeAnalyticsBloc,
            ComparativeAnalyticsState
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
                          ? Theme.of(context).colorScheme.surfaceContainerHigh
                          : Theme.of(context).colorScheme.surfaceContainerHigh,

                  child: Column(
                    children: [
                      Card.filled(
                        child: DropdownMenu<String>(
                          width: double.infinity,
                          initialSelection: "",
                          onSelected: (String? value) {},
                          dropdownMenuEntries: [],
                        ),
                      ),
                      Expanded(
                        child: Card(
                          child: SizedBox(
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Column(
                  children: [
                    Card.filled(
                      child: Row(
                        children: [
                          Expanded(
                            child: DropdownMenu<String>(
                              key: ValueKey(visibilty),
                              width: double.infinity,
                              leadingIcon: Icon(
                                Icons.contacts,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              inputDecorationTheme: InputDecorationTheme(
                                border: InputBorder.none,
                              ),
                              initialSelection: state.firstNumber,
                              onSelected: (String? value) {
                                context.read<ComparativeAnalyticsBloc>().add(
                                  ComparativeAnalyticsCalculateEvent(
                                    firstPhoneNumber: value ?? "",
                                    secondPhoneNumber: state.secondNumber,
                                    contacts: state.contacts,
                                  ),
                                );
                              },
                              dropdownMenuEntries:
                                  state.contacts.map((contact) {
                                    return DropdownMenuEntry<String>(
                                      value: contact['phoneNumber']!,
                                      label:
                                          "${contact["displayName"]} ${visibilty ? contact["phoneNumber"] : ""}",
                                    );
                                  }).toList(),
                            ),
                          ),
                          Expanded(
                            child: DropdownMenu<String>(
                              key: ValueKey(visibilty),
                              width: double.infinity,
                              leadingIcon: Icon(
                                Icons.contacts,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              inputDecorationTheme: InputDecorationTheme(
                                border: InputBorder.none,
                              ),
                              initialSelection: state.secondNumber,
                              onSelected: (String? value) {
                                context.read<ComparativeAnalyticsBloc>().add(
                                  ComparativeAnalyticsCalculateEvent(
                                    firstPhoneNumber: state.firstNumber,
                                    secondPhoneNumber: value ?? "",
                                    contacts: state.contacts,
                                  ),
                                );
                              },
                              dropdownMenuEntries:
                                  state.contacts.map((contact) {
                                    return DropdownMenuEntry<String>(
                                      value: contact['phoneNumber']!,
                                      label:
                                          "${contact["displayName"]} ${visibilty ? contact["phoneNumber"] : ""}",
                                    );
                                  }).toList(),
                            ),
                          ),
                          IconButton.filled(
                            onPressed: () {
                              setState(() {
                                visibilty = !visibilty;
                              });
                            },
                            icon: Icon(
                              visibilty
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Card(
                        child: SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child:
                                state.status == Status.error
                                    ? ListTile(
                                      title: Text("An error occurred"),
                                      subtitle: Text(state.errorMessage),
                                    )
                                    : SingleChildScrollView(
                                      child: Comparison(state: state),
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
