import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:admobtest/utils/string-resources.dart';
import 'pages/home-page.dart';
import 'package:admobtest/utils/styling.dart';
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
      theme: ThemeData(
        primaryColor: AppTheme.primaryColor,
      ),
      home: HomePage(),
    );
  }
}
