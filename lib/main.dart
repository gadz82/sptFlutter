import 'package:flutter/material.dart';
import 'package:scelteperte/home.dart';
import 'package:scelteperte/src/providers/spt_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';

void main() {
  runApp(AppSplashLoader());
}


class AppSplashLoader extends StatefulWidget {
  @override
  _AppSplashLoaderState createState() => _AppSplashLoaderState();
}

class _AppSplashLoaderState extends State<AppSplashLoader> {

  Future<bool> appReady;
  Future<SharedPreferences> localStorage;

  @override
  void initState(){
    super.initState();
    appReady = SptProvider.fetchData();
    localStorage = SptProvider.localStorage;
  }

  @override
  Widget build(BuildContext buildContext) {
    return FutureBuilder<SharedPreferences>(
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
                              child: Text(
                                'Inizializzazione Scelte per Te',
                                textDirection: TextDirection.ltr,
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
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
      );
  }
}

