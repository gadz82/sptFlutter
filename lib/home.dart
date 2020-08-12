import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:scelteperte/drawer.dart';
import 'package:scelteperte/src/models/recipe_model.dart';
import 'package:scelteperte/src/models/slide_model.dart';
import 'package:scelteperte/volantini.dart';
import 'package:scelteperte/volantini_webview.dart';

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
  Future<List<Slide>> slides;

  @override
  void initState() {
    super.initState();
    this.appReady = widget.appReady;
    this.appReady.whenComplete((){
      setState(() {
        slides = Slide().getSlides();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scelte per Te',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/home': (context) => Home(appReady: this.appReady),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/volantini': (context) => Volantini(),
        '/volantini/webview' : (context) => VolantiniWebView()
      },
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
                    return Container(
                        width: 60.0,
                        height: 20.0,
                        padding: EdgeInsets.all(15.00),
                        color: Colors.green,
                        child: new CircularProgressIndicator(
                            backgroundColor: Colors.white,
                            valueColor: new AlwaysStoppedAnimation<Color>(Colors.lightGreen)
                        )
                    );
                  })
            ]),
        drawer: SptDrawer(),
        body: FutureBuilder(
            future: slides,
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
                  ),
                  Container(
                    margin: EdgeInsets.only(top:20.00),
                    padding: EdgeInsets.all(10.00),
                    child: RaisedButton(
                        textColor: Colors.white,
                        color: Colors.green,
                        padding: EdgeInsets.symmetric(horizontal: 10.00),
                        onPressed: () {
                          // Navigate back to the first screen by popping the current route
                          // off the stack.
                          Navigator.pushNamed(context, '/volantini');
                        },
                        child: ListTile(
                          contentPadding: EdgeInsets.all(0),
                          leading: CircleAvatar(
                            backgroundColor: Colors.green,
                            backgroundImage: new AssetImage('images/margherita.png')
                          ),
                          title: Text('Volantino Conad', style: TextStyle(color: Colors.white)),
                          subtitle: Text('Sfoglia il volantino e scopri le offerte', style: TextStyle(color: Colors.white, fontSize: 10.00)),
                          trailing: Icon(Icons.chevron_right, color: Colors.white),
                        )
                    )
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
