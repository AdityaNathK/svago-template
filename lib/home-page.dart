import 'package:admobtest/sticker-list.dart';
import 'package:flutter/material.dart';
import 'package:admobtest/custom-admob.dart';
import 'package:admobtest/string-resources.dart';
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    List<Widget> fakeBottomButtons = new List<Widget>();
    fakeBottomButtons.add(
      Container(
        height: 50.0,
      ),
    );

    return WillPopScope(
      // onWillPop: ()=> Future.value(false), Back press will not be activated
      onWillPop: () async {
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(Strings.mainAppBarTitle),
          centerTitle: true,
        ),
        persistentFooterButtons: fakeBottomButtons,
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     Navigator.pushNamed(context, Strings.creditsPageRoute);
        //   },
        // ),
        body: StaticContent(),
      ),
    );
  }
}
