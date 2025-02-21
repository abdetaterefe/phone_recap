import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:phone_recap/app/lib/ad_helper.dart';
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
  BannerAd? _bannerAd;
  @override
  void initState() {
    super.initState();
    context
        .read<recap.RecapBloc>()
        .add(recap.RecapGetCallRecap(year: widget.year));
    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    ).load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.year.toString()),
      ),
      body: Column(
        children: [
          Expanded(
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
          ),
          if (_bannerAd != null) // Banner Ad at the bottom
            Align(
              alignment: Alignment.bottomCenter, // Align to the bottom
              child: SizedBox(
                width: _bannerAd!.size.width.toDouble(),
                height: _bannerAd!.size.height.toDouble(),
                child: AdWidget(ad: _bannerAd!),
              ),
            ),
        ],
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
