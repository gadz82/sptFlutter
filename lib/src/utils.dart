import 'dart:developer';
import 'dart:io' show Platform;
import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scelteperte/flyers_list.dart';
import 'package:scelteperte/fruits_item.dart';
import 'package:scelteperte/news_item.dart';
import 'package:scelteperte/plants_item.dart';
import 'package:scelteperte/promotions_item.dart';
import 'package:scelteperte/recipes_item.dart';
import 'package:scelteperte/src/providers/spt_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Utils {

  String parseHtmlString(String htmlString) {
    RegExp exp = RegExp(
        r"<[^>]*>",
        multiLine: true,
        caseSensitive: true
    );
    return htmlString.replaceAll(exp, '');
  }

  String getDeviceType() {
    final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
    return data.size.shortestSide < 600 ? 'phone' :'tablet';
  }

  void launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  showSnackBar(BuildContext context, String text){
    return Scaffold.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  void initFirebase(BuildContext context) async {

    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

    String _deviceId = await this.getDeviceId();

    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      String _deviceToken = token;
      log(_deviceToken);
      SptProvider.registerDevice(deviceId: _deviceId, regId: _deviceToken, deviceType: Platform.isIOS ? 'ios' : 'android');
    });

  }

  Future<String> getDeviceId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) { // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId; // unique ID on Android
    }
  }

  void handlePushNotification(String event, Map<String, dynamic> notification){
    log(event);
    log(notification.toString());
    String title;
    String body;
    String type;
    String postId;

    log(notification['data'].toString());

    if(Platform.isIOS){
      title = notification['title'];
      body = notification['body'];
      type = notification['type'];
      postId = notification['postId'];
    } else {
      title = notification['data']['title'];
      body = notification['data']['body'];
      type = notification['data']['type'];
      postId = notification['data']['postId'];
    }
    if(event == 'onMessage'){

        Get.snackbar(title, body,
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 5),
            barBlur: 15,
            titleText: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            mainButton: FlatButton(child: Text('Scopri'),onPressed: (){
              this.getNotificationClickEventRoute(type, postId, title);
            })
        );
    } else {
        this.getNotificationClickEventRoute(type, postId, title);
    }
  }

  getNotificationClickEventRoute(type, postId, title){
    switch(type){
      case 'prodotti':
        return Get.to(PlantsItem(postId : int.parse(postId), appBarTitle: title));
        break;
      case 'frutta-verdura':
        return Get.to(FruitsItem(postId : int.parse(postId), appBarTitle: title));
        break;
      case 'ricette':
        return Get.to(RecipesItem(postId : int.parse(postId), appBarTitle: title));
        break;
      case 'post':
        return Get.to(NewsItem(postId : int.parse(postId), appBarTitle: title));
        break;
      case 'promozioni-app':
        return Get.to(PromotionsItem(postId : int.parse(postId), appBarTitle: title));
        break;
      case 'volantini':
        return Get.to(FlyersList());
        break;
    }
  }

  static Future<dynamic> sptnBackgroundMessageHandler(Map<String, dynamic> message) async {}

}