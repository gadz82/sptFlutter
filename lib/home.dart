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

Column macroHomeSectionButton({String image, String title}){
  return Column(
    children: [
      Container(
          width: 75.0,
          height: 75.0,
          margin: EdgeInsets.only(bottom: 10),
          decoration: new BoxDecoration(
              shape: BoxShape.circle,
              image: new DecorationImage(
                  fit: BoxFit.fill,
                  image: new AssetImage(image)))),
      Container(
          width: 100.0,
          child: Text(
            title,
            textAlign: TextAlign.center,
            overflow: TextOverflow.clip,
            style: TextStyle(fontWeight: FontWeight.bold),
          ))
    ],
  );
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
      title: 'Scelte per Te',
      home: Scaffold(
        appBar: AppBar(
            title: Text('Scelte per Te'),
            backgroundColor: Colors.green,
            actions: <Widget>[
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
            ]
        ),
        body: FutureBuilder(
            future: Slide().getSlides(),
            builder: (context, AsyncSnapshot<List<Slide>> slides) {
              if (slides.hasData) {
                return Wrap(children: [
                  Container(
                      alignment: Alignment.topCenter,
                      child: CarouselSlider.builder(
                        itemCount: slides.data.length,
                        options: CarouselOptions(
                            autoPlay: false,
                            aspectRatio: 2.5,
                            viewportFraction: 1.0,
                            enlargeCenterPage: false),
                        itemBuilder: (context, index) {
                          return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.network(slides.data[index].image,
                                    fit: BoxFit.cover, width: 1000)
                              ]);
                        },
                      )),
                  Container(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: (){log('tap');},
                          child: macroHomeSectionButton(image: 'images/linguaggio.jpg', title: 'Linguaggio dei Fiori')
                        ),
                        GestureDetector(
                            onTap: (){log('tap');},
                            child: macroHomeSectionButton(image: 'images/oroscopo.jpg', title: 'Oroscopo del verde')
                        ),
                        GestureDetector(
                            onTap: (){log('tap');},
                            child: macroHomeSectionButton(image: 'images/giardini.jpg', title: 'Giardini e Orti Botanici')
                        ),
                        GestureDetector(
                            onTap: (){log('tap');},
                            child: macroHomeSectionButton(image: 'images/ricetta.jpg', title: 'Ricetta del mese')
                        )
                      ],
                    ),
                  )
                ]);
              } else {
                return Container(
                    child: Column(
                  children: [
                    Center(
                        child: Padding(
                            padding: EdgeInsets.only(top: 50.00),
                            child: CircularProgressIndicator())),
                    Text('Caricamento...')
                  ],
                ));
              }
            }),
      ),
    );
  }
}

