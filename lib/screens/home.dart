import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:phone_recap/screens/about.dart';
import 'package:phone_recap/screens/recap.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<int> years = [];
  bool loading = true;

  Future<void> getYears() async {
    final Iterable<CallLogEntry> result = await CallLog.query();
    List<CallLogEntry> sortedEntries = result.toList()
      ..sort((a, b) => a.timestamp!.compareTo(b.timestamp!));

    DateTime lastCallDate =
        DateTime.fromMillisecondsSinceEpoch(sortedEntries.last.timestamp!);
    int lastCallYear = lastCallDate.year;

    DateTime firstCallDate =
        DateTime.fromMillisecondsSinceEpoch(sortedEntries.first.timestamp!);
    int firstCallYear = firstCallDate.year;

    for (int year = firstCallYear; year <= lastCallYear; year++) {
      years.add(year);
    }

    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();

    getYears();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phone Recap'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AboutScreen(),
                ),
              );
            },
            icon: const Icon(Icons.info_outline),
          ),
        ],
      ),
      body: loading
          ? const CircularProgressIndicator()
          : Container(
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            title: Text(
                              years[index].toString(),
                              style: const TextStyle(
                                fontSize: 25,
                              ),
                            ),
                            subtitle: const Text(
                              'View recap of how you have talked to your friends over the phone this year.',
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              FilledButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => RecapScreen(
                                        year: years[index],
                                      ),
                                    ),
                                  );
                                },
                                child: const Text("View Recap"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    height: 10,
                  );
                },
                itemCount: years.length,
              ),
            ),
    );
  }
}
