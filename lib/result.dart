import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_to_web/scanner.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'admob.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

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

  InterstitialAd? _interstitialAd;

  bool _isInterstitialAdReady = false;

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          this._interstitialAd = ad;
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ScannerPage()
                  )
              );
            },
          );

          _isInterstitialAdReady = true;
        },
        onAdFailedToLoad: (err) {
          print('Failed to load an interstitial ad: ${err.message}');
          _isInterstitialAdReady = false;
        },
      ),
    );
  }

  void initState() {
    _loadInterstitialAd();
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
  }

  double dx = 0;
  double dy = 0;

  @override
  Widget build(BuildContext context) {
    var screen = MediaQuery.of(context);
    double w = screen.size.width;
    double h = screen.size.height;

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
              left: dx == 0 ? w - 70 : dx,
              top: dy == 0 ? h - 70 : dy,
              child: Draggable(
                  feedback: Container(
                      child: FloatingActionButton(
                          child: Icon(Icons.qr_code),
                          onPressed: () {})),
                  child: Container(
                    child: FloatingActionButton(
                        child: Icon(Icons.qr_code),
                        onPressed: () {
                          _interstitialAd?.show();
                        }),
                  ),
                  childWhenDragging: Container(),
                  onDragEnd: (details) {
                    setState(() {
                      dx = details.offset.dx;
                      dy = details.offset.dy;
                    });
                  })),
        ],
      ),
    );
  }
}
