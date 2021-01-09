import 'package:admobtest/custom-admob.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:admobtest/string-resources.dart';

import 'home-page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseAdMob.instance.initialize(appId: Strings.adMobAppId);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  CustomAdMob customAdMob = CustomAdMob();

  @override
  void initState() {
    super.initState();
    showBannerAd();
  }

  showBannerAd() {
    customAdMob.bannerAd()
      // typically this happens well before the ad is shown
      ..load()
      ..show(
        // Positions the banner ad 60 pixels from the bottom of the screen
        anchorOffset: 10.0,
        // Positions the banner ad 10 pixels from the center of the screen to the right
        // Banner Position
        anchorType: AnchorType.bottom,
      );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "new App",
      home: HomePage(),
    );
  }
}
