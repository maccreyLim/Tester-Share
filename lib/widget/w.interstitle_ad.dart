import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class InterstitialAdController {
  AdManagerInterstitialAd? _interstitialAd;

  // 광고 로딩 및 표시를 한 번에 처리
  void loadAndShowAd() {
    AdManagerInterstitialAd.load(
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/1033173712'
          : 'ca-app-pub-3940256099942544/4411468910',
      request: const AdManagerAdRequest(),
      adLoadCallback: AdManagerInterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('$ad loaded.');
          _interstitialAd = ad;
          _interstitialAd?.show(); // 광고 로딩 후 바로 표시
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('AdManagerInterstitialAd failed to load: $error');
        },
      ),
    );
  }
}

class InterstitialAd extends StatefulWidget {
  @override
  State<InterstitialAd> createState() => _InterstitialAdState();
}

class _InterstitialAdState extends State<InterstitialAd> {
  final InterstitialAdController adController = InterstitialAdController();

  @override
  void initState() {
    super.initState();
    adController.loadAndShowAd(); // 광고 로딩과 동시에 표시
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Interstitial Ad Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Your Content Goes Here'),
            // 버튼을 누르면 다시 광고를 로딩하여 표시
            ElevatedButton(
              onPressed: () {
                adController.loadAndShowAd();
              },
              child: Text('Show Interstitial Ad Again'),
            ),
          ],
        ),
      ),
    );
  }
}
