import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:phone_recap/views/monthly_recap.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
      appBar: AppBar(title: const Text('Phone Recap')),
      body: loading
          ? const CircularProgressIndicator()
          : Container(
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.all(8.0),
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MonthlyRecap(
                            year: years[index],
                          ),
                        ),
                      );
                    },
                    child: Text(years[index].toString()),
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
