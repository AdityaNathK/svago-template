import 'dart:convert';
import 'dart:async';
import 'file:///D:/svago-fun/admobtest/lib/services/custom-admob.dart';
import 'file:///D:/svago-fun/admobtest/lib/services/responses-page.dart';
import 'file:///D:/svago-fun/admobtest/lib/pages/sticker-info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:flutter_whatsapp_stickers/flutter_whatsapp_stickers.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:admobtest/utils/string-resources.dart';

class StaticContent extends StatefulWidget {
  @override
  _StaticContentState createState() => _StaticContentState();
}

class _StaticContentState extends State<StaticContent> {

  CustomAdMob customAdMob = CustomAdMob();
  InterstitialAd _interstitialAd;
  BannerAd _bannerAd;
  final _nativeAdController = NativeAdmobController();

  final WhatsAppStickers _waStickers = WhatsAppStickers();
  List stickerList = new List();
  List installedStickers = new List();

  void _loadStickers() async{
    String data = await rootBundle.loadString("sticker_packs/sticker_packs.json");
    final response = json.decode(data);
    List tempList = new List();

    for (int i = 0; i< response['sticker_packs'].length; i++) {
      tempList.add(response['sticker_packs'][i]);
    }
    setState(() {
      stickerList.addAll(tempList);
    });
    _checkInstallationStatuses();
  }

  void _checkInstallationStatuses() async {
    print("Total Stickers : ${stickerList.length}");
    for(var j=0;j<stickerList.length;j++){
      var tempName = stickerList[j]['identifier'];
      bool tempInstall = await WhatsAppStickers().isStickerPackInstalled(tempName);

      if(tempInstall==true){
        if(!installedStickers.contains(tempName)){
          setState(() {
            installedStickers.add(tempName);
          });
        }
      }else{
        if(installedStickers.contains(tempName)){
          setState(() {
            installedStickers.remove(tempName);
          });
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadStickers();
    _bannerAd = customAdMob.bannerAd()..load();
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
    Timer(Duration(seconds: 10),(){
      _bannerAd.show();
    });
    Timer(Duration(seconds: 15),(){
      _interstitialAd.show();
    });
    return ListView.separated(
        itemCount: stickerList.length,
        itemBuilder: (context, index){
          if(stickerList.length==0){
            return Container(
              child: CircularProgressIndicator(),
            );
          }
          else{
            var stickerId = stickerList[index]['identifier'];
            var stickerName = stickerList[index]['name'];
            var stickerPublisher = stickerList[index]['publisher'];
            var stickerTrayIcon = stickerList[index]['tray_image_file'];
            var stickerNumber = stickerList[index]['total_stickers'];
            var tempStickerList = List();


            bool stickerInstalled = false;
            if(installedStickers.contains(stickerId)){
              stickerInstalled = true;
            }else{
              stickerInstalled = false;
            }
            tempStickerList.add(stickerList[index]['identifier']);
            tempStickerList.add(stickerList[index]['name']);
            tempStickerList.add(stickerList[index]['publisher']);
            tempStickerList.add(stickerList[index]['tray_image_file']);
            tempStickerList.add(stickerList[index]['stickers']);
            tempStickerList.add(stickerList[index]['total_stickers']);
            tempStickerList.add(stickerInstalled);
            tempStickerList.add(installedStickers);

            return stickerPack(
              tempStickerList,
              stickerName,
              stickerPublisher,
              stickerId,
              stickerTrayIcon,
              stickerInstalled,
              stickerNumber
            );
          }
        },
      separatorBuilder: (context, index){
          return index % 4== 0? Container(
            margin: EdgeInsets.all(10),
            height: 60,
            child: NativeAdmob(
              adUnitID: NativeAd.testAdUnitId,
              controller: _nativeAdController,
              type: NativeAdmobType.banner,
              loading: Center(
                child: CircularProgressIndicator(),
              ),
              error: Text("No Ads to show Today"),
            )
          ):Container();
      },
    );
  }

  Widget stickerPack(List stickerList, String name,String publisher, String
  identifier, String stickerTrayIcon, bool installed,String total) {
    Widget depInstallWidget;
    if (installed==true) {
      depInstallWidget = IconButton(
        icon: Icon(
          Icons.check,
        ),
        color: Colors.teal,
        tooltip: Strings.addToWhatsApp,
        onPressed: (){},
      );
    } else {
      depInstallWidget =IconButton(
        icon: Icon(
          Icons.add,
        ),
        color: Colors.teal,
        tooltip: Strings.addToWhatsApp,
        onPressed: () async {
          _interstitialAd..show();
          _waStickers.addStickerPack(
            packageName: WhatsAppPackage.Consumer,
            stickerPackIdentifier: identifier,
            stickerPackName: name,
            listener: (action, result, {error}) => processResponse(
              action: action,
              result: result,
              error: error,
              successCallback: () async{
                _checkInstallationStatuses();
              },
              context: context,
            ),
          );
        },
      );
    }

    return Container(
      padding: EdgeInsets.all(10.0),
      child: Container(
        child: ListTile(
          onTap: (){
            _interstitialAd?.show();
            Navigator.of(context).push( MaterialPageRoute(
              builder: (BuildContext context) =>StickerPackInformation(stickerList),
            ));
          },
          title: Text("$name"),
          subtitle: Text("$publisher" + " | $total Stickers"),
          leading: Image.asset("sticker_packs/$identifier/$stickerTrayIcon"),
          // Column(
          //   children: <Widget>[
          //     // depInstallWidget,
          //   ],
          // ),
        ),
      ),
    );
  }
}
