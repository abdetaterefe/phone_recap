import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:phone_recap/app/lib/ad_helper.dart';

class PersistentBannerAdScaffold extends StatefulWidget {
  final Widget child;
  final String appBarTitle;
  final List<Widget>? appBarActions;
  final Widget? floatingActionButton;
  const PersistentBannerAdScaffold({
    super.key,
    required this.child,
    required this.appBarTitle,
    this.appBarActions,
    this.floatingActionButton,
  });

  @override
  State<PersistentBannerAdScaffold> createState() =>
      _PersistentBannerAdScaffoldState();
}

class _PersistentBannerAdScaffoldState
    extends State<PersistentBannerAdScaffold> {
  BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();

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
        title: Text(widget.appBarTitle),
        actions: widget.appBarActions,
      ),
      body: widget.child,
      bottomNavigationBar: _bannerAd != null
          ? SizedBox(
              width: _bannerAd!.size.width.toDouble(),
              height: _bannerAd!.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd!),
            )
          : Container(
              height: AdSize.banner.height.toDouble(),
            ),
      floatingActionButton: widget.floatingActionButton,
    );
  }
}
