import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scelteperte/fairs.dart';
import 'package:scelteperte/fuits_list.dart';
import 'package:scelteperte/gardens.dart';
import 'package:scelteperte/language.dart';
import 'package:scelteperte/news_list.dart';
import 'package:scelteperte/oroscope.dart';
import 'package:scelteperte/partials/drawer.dart';
import 'package:scelteperte/partials/home/home_slider.dart';
import 'package:scelteperte/partials/home/last_entries.dart';
import 'package:scelteperte/partials/home/nav_card.dart';
import 'package:scelteperte/plants_list.dart';
import 'package:scelteperte/promotions_list.dart';
import 'package:scelteperte/recipes_list.dart';
import 'package:scelteperte/src/models/recipe_model.dart';
import 'package:scelteperte/src/models/slide_model.dart';
import 'package:scelteperte/flyers_list.dart';
import 'package:scelteperte/flyers_webview.dart';


class Home extends StatefulWidget {
  final Future<bool> appReady;

  Home({Key key, this.appReady}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  Future<bool> appReady;
  Future<List<Slide>> slides;
  Future<Recipe> featuredRecipe;

  @override
  void initState() {
    super.initState();
    this.appReady = widget.appReady;
    this.appReady.whenComplete(() {
      setState(() {
        slides = Slide().getSlides();
      });
      setState(() {
        this.featuredRecipe = Recipe().getFeaturedRecipe();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scelte per Te',
      routes: {
        '/home': (context) => Home(appReady: this.appReady),
        '/volantini': (context) => FlyersList(),
        '/volantini/webview': (context) => VolantiniWebView(),
        '/frutta': (context) => FruitsList(),
        '/piante': (context) => PlantsList(),
        '/ricette': (context) => RecipesList(),
        '/news': (context) => NewsList(),
        '/oroscopo': (context) => Oroscope(),
        '/linguaggio': (context) => Language(),
        '/fiere': (context) => Fairs(),
        '/giardini': (context) => Gardens(),
        '/promozioni': (context) => PromotionsList()
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
                        return Visibility(
                            visible: false, child: Text('loaded'));
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
          body: Builder(builder: (context) =>
              ListView(children: [
                FutureBuilder(
                    future: slides,
                    builder: (context, AsyncSnapshot<List<Slide>> slides) {
                      if (slides.hasData) {
                        return SliderHome(slides : slides.data);
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
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 5.00),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/linguaggio');
                            },
                            child: MacroHomeSectionButton(
                                image: new AssetImage('images/linguaggio.jpg'),
                                title: 'Linguaggio dei Fiori')
                        ),
                        GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/oroscopo');
                            },
                            child: MacroHomeSectionButton(
                                image: new AssetImage('images/oroscopo.jpg'),
                                title: 'Oroscopo del verde'
                            )),
                        GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/giardini');
                            },
                            child: MacroHomeSectionButton(
                                image: new AssetImage('images/giardini.jpg'),
                                title: 'Giardini e Orti Botanici'
                            )),
                        FutureBuilder(
                          future: featuredRecipe,
                          builder: (context, AsyncSnapshot<Recipe> recipe) {
                            if (recipe.hasData) {
                              return GestureDetector(
                                  onTap: () {
                                    log('tap');
                                  },
                                  child: MacroHomeSectionButton(
                                      image: new NetworkImage(recipe.data.thumb),
                                      title: 'Ricetta del mese'
                                  ));
                            } else {
                              return GestureDetector(
                                  onTap: () {
                                    log('tap');
                                  },
                                  child: MacroHomeSectionButton(
                                      image: new AssetImage('images/ricetta.jpg'),
                                      title: 'Ricetta del mese'
                                  ));
                            }
                          },
                        )
                      ],
                    ),
                  ),
                  HomeNavCard(items: [
                    NavItem(title: 'Frutta e Verdura', subTitle: 'Scopri le nostre schede', namedRoute: '/frutta', image: 'http://www.scelteperte.it/wp-content/themes/natural/images/home-frutta-app.jpg'),
                    NavItem(title: 'Piante e Fiori', subTitle: 'Scopri come coltivare', namedRoute: '/piante', image: 'http://www.scelteperte.it/wp-content/themes/natural/images/home-fiori-app.jpg'),
                    NavItem(title: 'Ricette', subTitle: 'A base di frutta e verdura', namedRoute: '/ricette', image: 'http://www.scelteperte.it/wp-content/themes/natural/images/home-ricette-app.jpg')
                  ]),
                  Container(
                      margin: EdgeInsets.only(top: 20.00),
                      padding: EdgeInsets.all(10.00),
                      child: RaisedButton(
                          textColor: Colors.white,
                          color: Colors.green,
                          padding: EdgeInsets.symmetric(horizontal: 10.00),
                          onPressed: () {
                            Navigator.pushNamed(context, '/volantini');
                          },
                          child: ListTile(
                            contentPadding: EdgeInsets.all(0),
                            leading: CircleAvatar(
                                backgroundColor: Colors.green,
                                backgroundImage: new AssetImage('images/margherita.png')
                            ),
                            title: Text('Volantino Conad', style: TextStyle(color: Colors.white)),
                            subtitle: Text(
                                'Sfoglia il volantino e scopri le offerte',
                                style: TextStyle(color: Colors.white, fontSize: 10.00)
                            ),
                            trailing: Icon(Icons.chevron_right, color: Colors.white),
                          )
                      )
                  ),
                  HomeLastEntries(),
                  HomeNavCard(items: [
                    NavItem(title: 'Consigli e Curiosità', subTitle: 'Dal mondo di Flora', namedRoute: '/news', asset: 'images/flora.jpg'),
                    NavItem(title: 'Fiere ed Eventi', subTitle: 'Sul mondo del Giardinaggio e Floricoltura', namedRoute: '/fiere', asset: 'images/fiere.jpg')
                  ]),
          ])
        )
      ),
    );
  }
}

class MacroHomeSectionButton extends StatelessWidget{
  final ImageProvider image;
  final String title;

  MacroHomeSectionButton({this.image, this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            width: (MediaQuery.of(context).size.width * 0.20) -10,
            height: (MediaQuery.of(context).size.width * 0.20) -10,
            margin: EdgeInsets.only(bottom: 10),
            decoration: new BoxDecoration(
                shape: BoxShape.circle,
                image: new DecorationImage(fit: BoxFit.fill, image: image)
            )
        ),
        Container(
            width: (MediaQuery.of(context).size.width * 0.25) -10,
            child: Text(
              title,
              textAlign: TextAlign.center,
              overflow: TextOverflow.clip,
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 11.50),
            ))
      ],
    );
  }
}