import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:scelteperte/src/models/slide_model.dart';

class Home extends StatefulWidget {
  final Future<bool> appReady;

  Home({Key key, this.appReady}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<bool> appReady;

  @override
  void initState() {
    super.initState();
    this.appReady = widget.appReady;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Welcome to Flutter',
        home: Scaffold(
          appBar: AppBar(title: Text('Welcome to Flutter'), actions: <Widget>[
            FutureBuilder<bool>(
                future: appReady,
                builder: (context, AsyncSnapshot<bool> ready) {
                  // ignore: missing_return
                  if (ready.hasData) {
                    log('App Sync with remote completed');
                    return Visibility(visible: false, child: Text('loaded'));
                  }
                  log('App Sync with remote in progress during Home rendering');
                  return IconButton(
                      icon: const Icon(Icons.navigate_next),
                      tooltip: 'Next page',
                      onPressed: null);
                })
          ]),
          body: Center(
            child: FutureBuilder(
                future: Slide().getSlides(),
                builder: (context, AsyncSnapshot<List<Slide>> slides) {
                  if (slides.hasData) {
                    return Container(
                        child: CarouselSlider.builder(
                            itemCount: slides.data.length,
                            options: CarouselOptions(
                                autoPlay: true,
                                aspectRatio: 2.0,
                                enlargeCenterPage: true,
                            ),
                            itemBuilder: (context, index) {
                              return Container(
                                child: Center(
                                    child: Image.network(slides.data[index].image, fit: BoxFit.cover, width: 1000)),
                              );
                            },
                        ));
                  } else {
                    return Column(
                      children: [
                        CircularProgressIndicator(),
                        Text('Caricamento...')
                      ],
                    );
                  }
                }),
          ),
        ));
  }
}
