import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scelteperte/src/providers/spt_provider.dart';

class Home extends StatefulWidget {

  final Future<bool> appReady;

  Home({ Key key, this.appReady }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  Future<bool> appReady;

  @override
  void initState(){
    super.initState();
    this.appReady = widget.appReady;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Welcome to Flutter'),
          actions: <Widget>[
            FutureBuilder<bool>(
              future: appReady,
              builder: (context, AsyncSnapshot<bool> ready) {
                // ignore: missing_return
                if(ready.hasData){
                  log('d');
                  return Visibility(
                      visible: false,
                      child: Text('loaded')
                  );
                }
                log('c');
                return IconButton(
                  icon: const Icon(Icons.navigate_next),
                  tooltip: 'Next page'
                );
              })
          ]
        ),
        body: Center(
          child: Text('Hello Worlds'),
        ),
      ),
    );
  }
}