import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scelteperte/home.dart';
import 'package:scelteperte/src/providers/spt_provider.dart';
import 'package:scelteperte/src/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:developer';


Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
    log(data.toString());
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
    log(notification.toString());
  }
  log(message.toString());
  // Or do other work.
}
void main() {
  runApp(GetMaterialApp(home: AppSplashLoader(),debugShowCheckedModeBanner: false));
}

class AppSplashLoader extends StatefulWidget {
  @override
  _AppSplashLoaderState createState() => _AppSplashLoaderState();
}

class _AppSplashLoaderState extends State<AppSplashLoader> {

  Future<bool> appReady;
  Future<SharedPreferences> localStorage;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState(){
    super.initState();
    appReady = SptProvider.fetchData();
    localStorage = SptProvider.localStorage;
    this.appReady.whenComplete(() {
      _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          Utils().handlePushNotification('onMessage', message);
        },
        onLaunch: (Map<String, dynamic> message) async {
          Utils().handlePushNotification('onLaunch', message);
        },
        onResume: (Map<String, dynamic> message) async {
          Utils().handlePushNotification('onResume', message);
        },
        onBackgroundMessage: Utils.sptnBackgroundMessageHandler
      );
      Utils().initFirebase(context);
    });
  }

  @override
  Widget build(BuildContext buildContext) {
    return Scaffold(
      body : FutureBuilder<SharedPreferences>(
          future: localStorage,
          builder: (context, AsyncSnapshot<SharedPreferences> storage) {
            if(storage.hasData && storage.data.containsKey('boot') && storage.data.getBool('boot')){
              log('App Already booted, rendering home page during appa sync');
              return Home(appReady : appReady);
            } else {
              return FutureBuilder<dynamic>(
                  future: appReady,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      storage.data.setBool('boot', true);
                      log('App Ready, Home first time rendering');
                      return Home(appReady: appReady);
                    } else if (snapshot.hasError) {

                      return Text("${snapshot.error}", textDirection: TextDirection.ltr,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black87));

                    } else {
                      log('App First Boot, waiting for first data sync');
                      return DecoratedBox(
                        decoration: const BoxDecoration(
                          color: Colors.lightGreen,
                          gradient:  RadialGradient(
                              radius: 1.4,
                              colors: [
                                Colors.green,
                                Colors.black
                              ]
                          ),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            textDirection: TextDirection.ltr,
                            children: <Widget>[
                              Padding(
                                  padding: EdgeInsets.all(100),
                                  child:  Image.asset('images/logo.png')
                              ),
                              Padding(
                                  padding: EdgeInsets.all(32),
                                  child: Container(child: Text(
                                    'Inizializzazione Scelte per Te',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white),
                                  ))
                              ),
                              Column(
                                children: <Widget>[
                                  CircularProgressIndicator(
                                      backgroundColor: Colors.green,
                                      valueColor: new AlwaysStoppedAnimation<Color>(Colors.white)
                                  )

                                ],
                              )
                            ],
                          ),
                        ),
                      );

                    }
                  }
              );
            }
          }
      )
    );
  }
}

