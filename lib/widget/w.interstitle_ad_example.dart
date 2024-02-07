import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class InterstitialAdExample extends StatefulWidget {
  @override
  State<InterstitialAdExample> createState() => _InterstitialAdExampleState();
}

class _InterstitialAdExampleState extends State<InterstitialAdExample> {
  AdManagerInterstitialAd? _interstitialAd;

  @override
  void initState() {
    super.initState();
    loadInterstitialAd();
  }

  void loadInterstitialAd() {
    AdManagerInterstitialAd.load(
      adUnitId: Platform.isAndroid
          //테스트 ID
          ? 'ca-app-pub-3940256099942544/1033173712'
          //실제 ID
          // ? 'ca-app-pub-9128371394963939/2528075897'
          : 'ca-app-pub-3940256099942544/4411468910',
      request: const AdManagerAdRequest(),
      adLoadCallback: AdManagerInterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('$ad loaded.');
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('AdManagerInterstitialAd failed to load: $error');
        },
      ),
    );
  }

  void showInterstitialAd() {
    _interstitialAd?.show();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Your Content Goes Here'),
          ElevatedButton(
            onPressed: () {
              showInterstitialAd();
            },
            child: Text('Show Interstitial Ad'),
          ),
        ],
      ),
    );
  }
}
