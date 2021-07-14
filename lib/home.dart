import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:qr_to_web/admob.dart';
import 'package:qr_to_web/scanner.dart';
import 'Helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

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

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('images/android.png'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if(Helper.isScanned){
            _interstitialAd?.show();
            /*if(_isInterstitialAdReady){
              _interstitialAd?.show();
            }else {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => ScannerPage()));
            }*/
          }else {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => ScannerPage()));
          }
        },
        child: Icon(Icons.qr_code),
      ),
    );
  }

}
