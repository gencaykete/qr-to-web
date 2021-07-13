import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

//import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'admob.dart';

class ScannerResult extends StatefulWidget {
  Barcode result;

  ScannerResult(this.result, {Key? key}) : super(key: key);

  @override
  _ScannerResultState createState() => _ScannerResultState();
}

class _ScannerResultState extends State<ScannerResult> {
  Completer<WebViewController> _controller = Completer<WebViewController>();

  Future<bool> comeBackButton(BuildContext context) async {
    Navigator.of(context).popUntil((route) => route.isFirst);
    return false;
  }

  /*
  late BannerAd _bannerAd;
  bool _isBannerAdReady = false;

  Future<InitializationStatus> _initGoogleMobileAds() {
    return MobileAds.instance.initialize();
  }

  @override
  void initState() {
    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          _isBannerAdReady = false;
          ad.dispose();
        },
      ),
    );

    _bannerAd.load();
  }*/

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => comeBackButton(context),
      child: Stack(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(top: 40, bottom: 0, left: 10, right: 8),
            child: WebView(
              initialUrl: widget.result.code,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                _controller.complete(webViewController);
              },
            ),
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: FloatingActionButton(
                onPressed: () {
                  Navigator.pop(context);
                }, child: Icon(Icons.qr_code)),
          )
        ],
      ),
    );
  }
}
