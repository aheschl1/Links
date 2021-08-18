import 'package:flutter/material.dart';
import 'package:native_admob_flutter/native_admob_flutter.dart';

class AdControl extends StatefulWidget {
  final String adId;
  const AdControl({Key key, this.adId}) : super(key: key);

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
      unitId: widget.adId,
    );
  }
}

