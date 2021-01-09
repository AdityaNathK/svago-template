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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Strings.mainTitle,
      home: HomePage(),
    );
  }
}
