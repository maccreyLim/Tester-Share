import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class RewardAd {
  AdRequest _adRequest = AdRequest();

  String getAdUnitId() {
    // 플랫폼에 따라 광고 단위 ID를 반환
    return Platform.isAndroid
        ? 'ca-app-pub-3940256099942544/5354046379'
        : 'your_ios_ad_unit_id';
  }

  Future<void> showRewardFullBanner(Function callback) async {
    await RewardedAd.load(
      adUnitId: getAdUnitId(),
      request: _adRequest,
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (RewardedAd ad) {
              ad.dispose();
            },
            onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
              ad.dispose();
            },
          );
          ad.show(onUserEarnedReward: (ad, reward) {
            callback();
          });
        },
        onAdFailedToLoad: (LoadAdError error) {
          callback();
        },
      ),
    );
  }
}
