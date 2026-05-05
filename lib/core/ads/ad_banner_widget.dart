import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdBannerWidget extends StatefulWidget {
  const AdBannerWidget({super.key});

  @override
  State<AdBannerWidget> createState() => _AdBannerWidgetState();
}

class _AdBannerWidgetState extends State<AdBannerWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  // debug 빌드: Google 공식 테스트 광고 ID / release 빌드: 실제 광고 ID
  static const String _adUnitId = kDebugMode
      ? 'ca-app-pub-3940256099942544/6300978111'
      : 'ca-app-pub-9991463854626958/4964479268';

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  void _loadAd() {
    if (kDebugMode) {
      MobileAds.instance.updateRequestConfiguration(
        RequestConfiguration(testDeviceIds: ['103233D06F91A58F7C93BC0E2E16E552']),
      );
    }
    _bannerAd = BannerAd(
      adUnitId: _adUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          if (mounted) setState(() => _isLoaded = true);
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          _bannerAd = null;
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  // AdSize.banner 고정 높이 — 광고 로드 전후 레이아웃 변화 방지
  static const double _reservedHeight = 50.0;

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded || _bannerAd == null) {
      // 광고 공간을 미리 예약해두어 로드 후 레이아웃 이동 없음
      return const SizedBox(height: _reservedHeight);
    }
    return SizedBox(
      height: _reservedHeight,
      width: double.infinity,
      child: AdWidget(ad: _bannerAd!),
    );
  }
}
