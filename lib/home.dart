import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:scelteperte/drawer.dart';
import 'package:scelteperte/src/models/recipe_model.dart';
import 'package:scelteperte/src/models/slide_model.dart';

class Home extends StatefulWidget {
  final Future<bool> appReady;

  Home({Key key, this.appReady}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

Column macroHomeSectionButton({ImageProvider image, String title, BuildContext context}) {
  return Column(
    children: [
      Container(
          width: MediaQuery.of(context).size.width * 0.20,
          height: MediaQuery.of(context).size.width * 0.20,
          margin: EdgeInsets.only(bottom: 10),
          decoration: new BoxDecoration(
              shape: BoxShape.circle,
              image: new DecorationImage(fit: BoxFit.fill, image: image)
          )
      ),
      Container(
          width: MediaQuery.of(context).size.width * 0.25,
          child: Text(
            title,
            textAlign: TextAlign.center,
            overflow: TextOverflow.clip,
            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 11.50 ),
          )
      )
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
            ]),
        drawer: SptDrawer(),
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
                                  Image.network(slides.data[index].image, fit: BoxFit.cover, width: 1000)
                                ]);
                            },
                      )),
                  Container(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                            onTap: () {
                              log('tap');
                            },
                            child: macroHomeSectionButton(
                                image: new AssetImage('images/linguaggio.jpg'),
                                title: 'Linguaggio dei Fiori',
                                context : context
                            )
                        ),
                        GestureDetector(
                            onTap: () {
                              log('tap');
                            },
                            child: macroHomeSectionButton(
                                image: new AssetImage('images/oroscopo.jpg'),
                                title: 'Oroscopo del verde',
                                context : context
                            )
                        ),
                        GestureDetector(
                            onTap: () {
                              log('tap');
                            },
                            child: macroHomeSectionButton(
                                image: new AssetImage('images/giardini.jpg'),
                                title: 'Giardini e Orti Botanici',
                                context : context
                            )
                        ),
                        FutureBuilder(
                          future: Recipe().getFeaturedRecipe(),
                          builder: (context, AsyncSnapshot<Recipe> recipe) {
                            if (recipe.hasData) {
                              return GestureDetector(
                                  onTap: () {
                                    log('tap');
                                  },
                                  child: macroHomeSectionButton(
                                      image: new NetworkImage(recipe.data.image),
                                      title: 'Ricetta del mese',
                                      context : context
                                  )
                              );
                            } else {
                              return GestureDetector(
                                  onTap: () {
                                    log('tap');
                                  },
                                  child: macroHomeSectionButton(
                                      image: new AssetImage('images/ricetta.jpg'),
                                      title: 'Ricetta del mese',
                                      context : context
                                  )
                              );
                            }
                          },
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
