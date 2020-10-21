import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scelteperte/contact.dart';
import 'package:scelteperte/fairs.dart';
import 'package:scelteperte/fuits_list.dart';
import 'package:scelteperte/gardens.dart';
import 'package:scelteperte/language.dart';
import 'package:scelteperte/news_list.dart';
import 'package:scelteperte/oroscope.dart';
import 'package:scelteperte/partials/bottom_banner.dart';
import 'package:scelteperte/partials/drawer.dart';
import 'package:scelteperte/partials/home/home_slider.dart';
import 'package:scelteperte/partials/home/last_entries.dart';
import 'package:scelteperte/partials/home/nav_card.dart';
import 'package:scelteperte/plants_list.dart';
import 'package:scelteperte/promotions_list.dart';
import 'package:scelteperte/recipes_item.dart';
import 'package:scelteperte/recipes_list.dart';
import 'package:scelteperte/src/models/recipe_model.dart';
import 'package:scelteperte/src/models/slide_model.dart';
import 'package:scelteperte/flyers_list.dart';
import 'package:scelteperte/flyers_webview.dart';
import 'package:scelteperte/src/utils.dart';

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

  String homeRecipesApp = 'http://www.scelteperte.it/wp-content/themes/natural/images/home-ricette-app.jpg';

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
        this.featuredRecipe.then((r){
          setState(() {
            this.homeRecipesApp = r.image;
          });
        });
      });

    });

  }

  @override
  Widget build(BuildContext context) {

    Widget navItemRicetta = FutureBuilder(
      future: featuredRecipe,
      builder: (context, AsyncSnapshot<Recipe> recipe) {
        if (recipe.hasData) {
          return GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => RecipesItem(postId: recipe.data.postId, appBarTitle: recipe.data.title)));
              },
              child: MacroHomeSectionButton(
                  image: new NetworkImage(recipe.data.thumb),
                  title: 'Ricetta del mese'
              ));
        } else {
          return GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/ricette'),
              child: MacroHomeSectionButton(
                  image: new AssetImage('images/ricetta.jpg'),
                  title: 'Ricetta del mese'
              ));
        }
      },
    );

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
        '/promozioni': (context) => PromotionsList(),
        '/contatti': (context) => Contact()
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
                        return SizedBox();
                      }
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
          bottomNavigationBar: BottomBanner(),
          body: Builder(builder: (context) =>
              ListView(children: [
                FutureBuilder(
                    future: slides,
                    builder: (context, AsyncSnapshot<List<Slide>> slides) {
                      if (slides.hasData) {
                        return SliderHome(slides : slides.data);
                      } else {
                        Size size = MediaQuery.of(context).size;
                        final double containerHeight = (size.height - kToolbarHeight - 300) / 2;

                        return Container(
                            height: containerHeight,
                            child:  Center(
                              child: CircularProgressIndicator(),
                            )
                        );
                      }
                    }),
                    Container(
                        margin: EdgeInsets.only(top: 0.00),
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

                  HomeNavCard(items: [
                    NavItem(title: 'Frutta e Verdura', subTitle: 'Scopri le nostre schede', namedRoute: '/frutta', image: 'http://www.scelteperte.it/wp-content/themes/natural/images/home-frutta-app.jpg'),
                    NavItem(title: 'Piante e Fiori', subTitle: 'Scopri come coltivare', namedRoute: '/piante', image: 'http://www.scelteperte.it/wp-content/themes/natural/images/home-fiori-app.jpg'),
                    NavItem(title: 'Ricette', subTitle: 'A base di frutta e verdura', namedRoute: '/ricette', image: this.homeRecipesApp),
                    NavItem(title: 'Sconti Esclusivi', subTitle: 'Per i possessori dell\'App Scelte per Te', namedRoute: '/promozioni', image: 'http://www.scelteperte.it/wp-content/themes/natural/images/icona-flora.png')
                  ]),

                  HomeLastEntries(),
                  Container(
                    margin: EdgeInsets.only(bottom: 15),
                    child: HomeNavCard(items: [
                      NavItem(title: 'Consigli e Curiosità', subTitle: 'Dal mondo di Flora', namedRoute: '/news', asset: 'images/flora.jpg'),
                      NavItem(title: 'Fiere ed Eventi', subTitle: 'Sul mondo del Giardinaggio e Floricoltura', namedRoute: '/fiere', asset: 'images/fiere.jpg'),
                      NavItem(title: 'Linguaggio dei Fiori', subTitle: 'Scopri il significato di piante e fiori', namedRoute: '/linguaggio', asset: 'images/linguaggio.jpg'),
                      NavItem(title: 'Oroscopo del verde', subTitle: 'Scopri la pianta del tuo segno zodiacale', namedRoute: '/linguaggio', asset: 'images/oroscopo.jpg'),
                      NavItem(title: 'Giardini e Orti Botanici', subTitle: 'Meravigliosi angoli da visitare in Italia', namedRoute: '/giardini', asset: 'images/giardini.jpg')
                    ])
                  )

                  /*Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 5.00),
                    margin: EdgeInsets.symmetric(vertical:15),
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

                      ],
                    ),
                  ),*/
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
                boxShadow: [BoxShadow(blurRadius: 5,color: Colors.grey)],
                shape: BoxShape.rectangle,
                image: new DecorationImage(fit: BoxFit.fill, image: image)
            )
        ),
        Container(
            width: (MediaQuery.of(context).size.width * 0.25) -10,
            child: Text(
              title,
              textAlign: TextAlign.center,
              overflow: TextOverflow.clip,
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: Utils().getDeviceType() == 'phone' ? 11.50 : 16),
            ))
      ],
    );
  }
}