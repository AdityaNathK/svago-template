import 'file:///D:/svago-fun/admobtest/lib/services/responses-page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_whatsapp_stickers/flutter_whatsapp_stickers.dart';
import 'file:///D:/svago-fun/admobtest/lib/services/custom-admob.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:admobtest/utils/string-resources.dart';
class StickerPackInformation extends StatefulWidget {
  final List stickerPack;

  StickerPackInformation(this.stickerPack);
  @override
  _StickerPackInformationState createState() => _StickerPackInformationState(stickerPack);
}

class _StickerPackInformationState extends State<StickerPackInformation> {

  CustomAdMob customAdMob = CustomAdMob();
  InterstitialAd _interstitialAd;
  BannerAd _bannerAd;

  List stickerPack;
  final WhatsAppStickers _waStickers = WhatsAppStickers();

  _StickerPackInformationState(this. stickerPack);  //constructor

  void _checkInstallationStatuses() async {
    print("Total Stickers : ${stickerPack.length}");
    var tempName = stickerPack[0];
    bool tempInstall = await WhatsAppStickers().isStickerPackInstalled(tempName);

    if(tempInstall==true){
      if(!stickerPack[6].contains(tempName)){
        setState(() {
          stickerPack[6].add(tempName);
        });
      }
    }else{
      if(stickerPack[6].contains(tempName)){
        setState(() {
          stickerPack[6].remove(tempName);
        });
      }
    }
    print("${stickerPack[6]}");
  }

  @override
  void initState() {
    super.initState();
    _bannerAd = customAdMob.bannerAd()..load()..show();
    _interstitialAd = customAdMob.interstitialAd()..load();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _bannerAd?.dispose();
    _interstitialAd.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 5),(){
      _interstitialAd.show();
    });
    List totalStickers = stickerPack[4];
    List<Widget> fakeBottomButtons = new List<Widget>();
    fakeBottomButtons.add(
      Container(
        height: 50.0,
        child: Text(
            Strings.bottomAdSpace.toUpperCase()
        ),
      ),
    );
    Widget depInstallWidget;
    if (stickerPack[5]==true) {
      depInstallWidget =  Padding(
        padding: const EdgeInsets.symmetric(vertical:8.0),
        child: Text("Sticker Added",style: TextStyle(
            color: Colors.teal,
            fontSize: 16.0,
            fontWeight: FontWeight.bold
        ),),
      );
    } else {
      depInstallWidget =RaisedButton(
        child: Text(Strings.addNow),
        textColor: Colors.white,
        color: Colors.teal[900],
        onPressed: () async {
          _interstitialAd?.show();
          _waStickers.addStickerPack(
            packageName: WhatsAppPackage.Consumer,
            stickerPackIdentifier: stickerPack[0],
            stickerPackName: stickerPack[1],
            listener: (action, result, {error}) => processResponse(
              action: action,
              result: result,
              error: error,
              successCallback: () async{
                setState(() {
                  _checkInstallationStatuses();
                });
              },
              context: context,
            ),
          );
        },
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("${stickerPack[1]} "),
      ),
      body: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Image.asset("sticker_packs/${stickerPack[0]}/${stickerPack[3]}",
                  width: 100,
                  height: 100,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("${stickerPack[1]}",style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal[900],
                    ),),
                    Text("${stickerPack[2]}",style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.black54,
                    ),),
                    depInstallWidget,
                  ],
                ),
              )

            ],
          ),
          Expanded(
            child: GridView.builder(
                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 1,
                ),
                itemCount: totalStickers.length,
                itemBuilder: (context, index) {
                  var stickerImg = "sticker_packs/${stickerPack[0]}/${totalStickers[index]['image_file']}";
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Image.asset(stickerImg,
                      width:100,
                      height: 100,
                    ),
                  );
                }
            ),
          ),
        ],
      ),
      persistentFooterButtons: fakeBottomButtons,

    );
  }
}
