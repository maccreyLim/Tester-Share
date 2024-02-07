// banner_ad_example.dart

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdExample extends StatefulWidget {
  @override
  State<BannerAdExample> createState() => _BannerAdExampleState();
}

class _BannerAdExampleState extends State<BannerAdExample> {
  BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();
    loadBannerAd();
  }

  void loadBannerAd() {
    _bannerAd = BannerAd(
      //테스트 ID
      adUnitId: 'ca-app-pub-3940256099942544/6300978111',
      //실제 ID
      // adUnitId: 'ca-app-pub-9128371394963939/1280574841',
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          debugPrint('$ad loaded.');
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          debugPrint('BannerAd failed to load: $error');
        },
      ),
    );

    _bannerAd?.load();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      child: AdWidget(ad: _bannerAd!),
      width: _bannerAd?.size.width.toDouble(),
      height: _bannerAd?.size.height.toDouble(),
    );
  }
}
