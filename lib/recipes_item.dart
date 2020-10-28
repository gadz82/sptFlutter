import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:scelteperte/partials/bottom_banner.dart';
import 'package:scelteperte/partials/item/download_button.dart';
import 'package:scelteperte/partials/item/frutta/item_linked_fruit.dart';
import 'package:scelteperte/partials/item/item_card.dart';
import 'package:scelteperte/partials/item/ricette/card_igredients.dart';
import 'package:scelteperte/partials/item/ricette/recipe_table.dart';
import 'package:scelteperte/src/models/fruit_model.dart';
import 'package:scelteperte/src/models/recipe_model.dart';
import 'package:scelteperte/src/utils.dart';
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';

class RecipesItem extends StatefulWidget {

  final int postId;
  final String appBarTitle;

  RecipesItem({this.postId, this.appBarTitle});

  @override
  _RecipesItemState createState() => _RecipesItemState();
}

class _RecipesItemState extends State<RecipesItem> {

  Future<bool> recipeReady;

  Recipe recipe;

  bool hasRelatedFruits = false;
  List<Fruit> relatedFruits = [];

  @override
  initState() {
    super.initState();
    this.recipeReady = getPlant();
  }

  getPlant(){
    return Recipe().getRecipe(widget.postId).then((value){
      setState((){
        recipe = value;
      });
      var futures = <Future>[];

      futures.add(Recipe().getRelatedFruits(recipe).then((value) {
        setState(() {
          this.relatedFruits.addAll(value);
          this.hasRelatedFruits = value.length > 0 ? true : false;
        });
      }));

      return Future.wait(futures).then((value){
        return true;
      }).catchError((err){
        return true;
      });

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.appBarTitle),
          backgroundColor: Colors.green,
          actions: [
            FutureBuilder(
                future: recipeReady,
                builder: (context, AsyncSnapshot<bool> recipeReady) {
                  if (recipeReady.hasData && recipeReady.data == true) {
                    return Container(
                        margin: EdgeInsets.only(right: 10),
                        child: InkWell(
                          child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Icon(Icons.share)
                          ),
                          onTap: () async => await Utils().isIpad() ? Share.share(recipe.url, sharePositionOrigin: Rect.fromCenter(center: Offset(MediaQuery.of(context).size.width, 0), width: 100, height: 100)) : Share.share(recipe.url),
                        )
                    );

                  } else {
                    return SizedBox();
                  }
                }
            )
          ],
        ),
        bottomNavigationBar: BottomBanner(),
        body: Container(
            child: FutureBuilder(
                future: recipeReady,
                builder: (context, AsyncSnapshot<bool> rReady){
                  if(rReady.hasData && rReady.data == true){
                    return ListView(
                      children: [
                        Container(
                          height: Utils().getDeviceType() == 'phone' ? 250 : 500,
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children:[
                                Expanded(
                                  child: FadeInImage.memoryNetwork(
                                      placeholder: kTransparentImage,
                                      image: recipe.image,
                                      fit: BoxFit.fitWidth
                                  ),
                                ),
                              ]
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top:25),
                          alignment: Alignment.center,
                          child: Text(recipe.title, style: TextStyle(fontSize: 18, color: Colors.green, fontWeight: FontWeight.bold)),
                        ),
                        Container(
                            margin:EdgeInsets.symmetric(vertical:15),
                            child: Html(data: recipe.description)
                        ),
                        Row(
                            children: <Widget>[
                              Expanded(
                                child: Table(
                                  border: TableBorder(top: BorderSide(color: Color(0xfff7a701), width: 0.5), bottom: BorderSide(color: Color(0xfff7a701), width: 0.5)),
                                  children: [
                                    TableRow(
                                        children: [
                                          Container(
                                            color: Color(0xfff7a701),
                                            width: 1000.0,
                                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                            child: Text("Scheda Piatto", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                                          ),
                                        ]
                                    ),
                                  ],
                                ),
                              ),
                            ]
                        ),
                        RecipeTable(cottura: recipe.cookingTime.toString(), difficolta: recipe.difficultyFilter, porzioni: recipe.portions.toString(), preparazione: recipe.preparationTime.toString()),
                        CardIngredients(ingredients: jsonDecode(recipe.ingredients)),
                        ItemCard(cardTitle: "Preparazione", content: recipe.preparation),

                        if(hasRelatedFruits)
                          Wrap(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                margin: EdgeInsets.only(top:15, bottom:15),
                                child: Text('Scheda Frutto', style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold, color:Colors.green)),
                              ),
                              ItemLinkedFruit(relatedFruits: relatedFruits),

                            ],
                          ),


                        Container(
                          margin: EdgeInsets.only(top:10, bottom: 10),
                          child: DownloadButton(url: recipe.pdf, buttonTitle: "Scarica Scheda PDF"),
                        )
                      ],
                    );


                  }
                  return Center(
                      child: CircularProgressIndicator()
                  );
                }
            )
        )
    );
  }
}
