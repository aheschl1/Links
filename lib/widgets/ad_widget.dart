import 'package:flutter/material.dart';
import 'package:links/constants/ad_ids.dart';
import 'package:native_admob_flutter/native_admob_flutter.dart';

/*class AdControl extends StatefulWidget {
  const AdControl({Key key}) : super(key: key);

  @override
  _AdControlState createState() => _AdControlState();
}

class _AdControlState extends State<AdControl> {

  BannerAd bannerAd;
  bool adReady = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: adReady ? AdWidget(ad: bannerAd) : Text(''),
      width: bannerAd.size.width.toDouble(),
      height: bannerAd.size.height.toDouble(),
    );
  }

  @override
  void initState() {

   final BannerAdListener listener = BannerAdListener(
     // Called when an ad is successfully received.
     onAdLoaded: (Ad ad){
       setState(() {
         adReady = true;
       });
     },
     // Called when an ad request failed.
     onAdFailedToLoad: (Ad ad, LoadAdError error) {
       // Dispose the ad here to free resources.
       ad.dispose();
       print('Ad failed to load: $error');
     },
     // Called when an ad opens an overlay that covers the screen.
     onAdOpened: (Ad ad) => print('Ad opened.'),
     // Called when an ad removes an overlay that covers the screen.
     onAdClosed: (Ad ad) => print('Ad closed.'),
     // Called when an impression occurs on the ad.
     onAdImpression: (Ad ad) => print('Ad impression.'),
   );

   bannerAd = BannerAd(
     adUnitId: AdIds().publicEventAdId,
     size: AdSize.banner,
     request: AdRequest(),
     listener: listener,
   );

   bannerAd.load();

   super.initState();
  }
}*/
class AdControl extends StatefulWidget {
  const AdControl({Key key}) : super(key: key);

  @override
  _AdControlState createState() => _AdControlState();
}

class _AdControlState extends State<AdControl> {

  bool adReady = false;
  final bannerController = BannerAdController();

  @override
  void initState() {
    bannerController.onEvent.listen((e) {
      final event = e.keys.first;
      switch (event) {
        case BannerAdEvent.loaded:
          print('loaded');
          setState(() {
            adReady = true;
          });
          break;
        case BannerAdEvent.loadFailed:
          final errorCode = e.values.first;
          print('loadFailed $errorCode');
          break;
        case BannerAdEvent.loading:
          print('loading');
          break;
        default:
          break;
      }
    });
    bannerController.load();
    super.initState();

  }

  @override
  void dispose() {
    bannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BannerAd(
      builder: (context, child) {
        return Container(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          color: Colors.transparent,
          child: child,
        );
      },
      controller: bannerController,
      size: BannerSize.ADAPTIVE,
      unitId: AdIds().publicEventAdId,
    );
  }
}

