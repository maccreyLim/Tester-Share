import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class RewardAdManager {
  AdRequest _adRequest = AdRequest();

  String getAdUnitId() {
    // 플랫폼에 따라 광고 단위 ID를 반환
    return Platform.isAndroid
        ? 'ca-app-pub-9128371394963939/2602642218'
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
