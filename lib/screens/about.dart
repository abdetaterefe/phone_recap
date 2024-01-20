import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Phone Recap",
              style: TextStyle(
                fontSize: 32,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * .4,
              height: 3,
              decoration: const BoxDecoration(
                color: Colors.green,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text("Made by"),
              subtitle: const Text("Abdeta Terefe"),
              trailing: IconButton.filledTonal(
                onPressed: () async {
                  final Uri url = Uri.parse('https://abdeta.vercel.app');
                  if (!await launchUrl(url)) {
                    throw Exception('Could not launch $url');
                  }
                },
                icon: const Icon(Icons.open_in_browser),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text("Github"),
              subtitle: const Text(
                "This app is open source, click to find more information.",
              ),
              trailing: IconButton.filledTonal(
                onPressed: () async {
                  final Uri url = Uri.parse(
                    'https://github.com/abdetaterefe/phone_recap',
                  );
                  if (!await launchUrl(url)) {
                    throw Exception('Could not launch $url');
                  }
                },
                icon: const Icon(Icons.open_in_browser),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text("Version"),
              subtitle: const Text(
                "1.0.0",
              ),
              trailing: IconButton.filledTonal(
                onPressed: () async {
                  final Uri url = Uri.parse(
                    'https://github.com/abdetaterefe/phone_recap/releases',
                  );
                  if (!await launchUrl(url)) {
                    throw Exception('Could not launch $url');
                  }
                },
                icon: const Icon(Icons.open_in_browser),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
