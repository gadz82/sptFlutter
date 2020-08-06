import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:scelteperte/home.dart';
import 'package:scelteperte/src/providers/spt_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(AppSplashLoader());
}


class AppSplashLoader extends StatefulWidget {
  @override
  _AppSplashLoaderState createState() => _AppSplashLoaderState();
}

class _AppSplashLoaderState extends State<AppSplashLoader> {

  Future<dynamic> appData;
  Future<SharedPreferences> localStorage;

  @override
  void initState(){
    super.initState();
    appData = SptProvider.fetchData();
    localStorage = SptProvider.localStorage;
  }

  @override
  Widget build(BuildContext buildContext) {
    return FutureBuilder<SharedPreferences>(
        future: localStorage,
        builder: (context, AsyncSnapshot<SharedPreferences> storage) {
          if(storage.hasData && storage.data.containsKey('boot') && storage.data.getBool('boot')){
            return Home();
          } else {
            return FutureBuilder<dynamic>(
                future: appData,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    storage.data.setBool('boot', true);
                    return Home();
                  } else if (snapshot.hasError) {

                    return Text("${snapshot.error}", textDirection: TextDirection.ltr,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black87));

                  } else {

                    return DecoratedBox(
                      decoration: const BoxDecoration(color: Colors.white),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          textDirection: TextDirection.ltr,
                          children: <Widget>[
                            FlutterLogo(size: 48),
                            Padding(
                              padding: EdgeInsets.all(32),
                              child: Text(
                                'This app is only meant to be run under the Flutter debugger',
                                textDirection: TextDirection.ltr,
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.black87),
                              ),
                            ),
                            Column(
                              children: <Widget>[
                                CircularProgressIndicator(),
                                Text(
                                    'Caricamento Dati',
                                    textDirection: TextDirection.ltr,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.black87)
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

