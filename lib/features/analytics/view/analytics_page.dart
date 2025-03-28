import 'package:flutter/material.dart';
import 'package:phone_recap/features/advanced_metrics/view/advanced_metrics_page.dart';
import 'package:phone_recap/features/behavioral_patterns/view/behavioral_patterns_page.dart';
import 'package:phone_recap/features/comparative_analytics/view/comparative_analytics_page.dart';
import 'package:phone_recap/features/contact_insights/view/contact_insights_page.dart';
import 'package:phone_recap/features/summaries/view/summaries_page.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});
  static MaterialPageRoute<AnalyticsPage> route() =>
      MaterialPageRoute(builder: (context) => AnalyticsPage());

  @override
  Widget build(BuildContext context) {
    return AnalyticsView();
  }
}

class AnalyticsView extends StatefulWidget {
  const AnalyticsView({super.key});

  @override
  State<AnalyticsView> createState() => _AnalyticsViewState();
}

class _AnalyticsViewState extends State<AnalyticsView> {
  final List<Map<String, dynamic>> _tabs = [
    {
      'title': 'Summaries',
      'subtitle': 'Datailed analysis of call patterns for each Month.',
      'icon': Icons.summarize,
      'page': SummariesPage(),
    },
    {
      'title': 'Contact-Specific Insights',
      'subtitle': 'Detailed analysis of call patterns for individual contacts.',
      'icon': Icons.person_search,
      'page': ContactInsightsPage(),
    },
    {
      'title': 'Behavioral Patterns',
      'subtitle': 'Understand your call habits based on time and day.',
      'icon': Icons.timeline,
      'page': BehavioralPatternsPage(),
    },
    {
      'title': 'Advanced Metrics',
      'subtitle': 'Explore deeper metrics beyond basic call analysis.',
      'icon': Icons.insights,
      'page': AdvancedMetricsPage(),
    },
    {
      'title': 'Comparative Analytics',
      'subtitle': 'Datailed comparison of call patterns for two contacts.',
      'icon': Icons.compare_arrows,
      'page': ComparativeAnalyticsPage(),
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Analytics')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: _tabs.length,
          itemBuilder: (context, index) {
            return Card.filled(
              child: ListTile(
                leading: Card(
                  color: Theme.of(context).colorScheme.primary,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      _tabs[index]['icon'],
                      color:
                          Theme.of(context).colorScheme.brightness ==
                                  Brightness.dark
                              ? Colors.black
                              : Colors.white,
                    ),
                  ),
                ),
                title: Text(
                  _tabs[index]['title'],
                  style: TextStyle(fontSize: 18),
                ),
                subtitle: Text(_tabs[index]['subtitle']),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => _tabs[index]['page'],
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
