import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:scelteperte/home.dart';

void main() {
  runApp(AppSplashLoader());
}

Future<dynamic> fetchData() async {
  final response =  await http.get('http://www.scelteperte.it/sptrapi/initialize?mtoken=FNmZbp6nR7EEs7Eg&ts=');
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load data');
  }
}

class AppSplashLoader extends StatefulWidget {
  @override
  _AppSplashLoaderState createState() => _AppSplashLoaderState();
}

class _AppSplashLoaderState extends State<AppSplashLoader> {
  Future<dynamic> appData;

  @override
  void initState() {
    super.initState();
    appData = fetchData();
  }

  @override
  Widget build(BuildContext buildContext) {
    return Container(
      child: FutureBuilder<dynamic>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
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
      ),
    );
  }
}

