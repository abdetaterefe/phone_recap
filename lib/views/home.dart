import 'package:flutter/material.dart';
import 'package:phone_recap/views/monthly_recap.dart';
import 'package:phone_recap/views/recap.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Phone Recap')),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RecapScreen(
                        recap: "weekly",
                      ),
                    ),
                  );
                },
                child: const Text('Weekly Recap'),
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MonthlyRecap(),
                    ),
                  );
                },
                child: const Text('Monthly Recap'),
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MonthlyRecap(),
                    ),
                  );
                },
                child: const Text('Yearly Recap'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
