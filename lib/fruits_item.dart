import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:scelteperte/partials/bottom_banner.dart';
import 'package:scelteperte/partials/item/download_button.dart';
import 'package:scelteperte/partials/item/frutta/fruit_table.dart';
import 'package:scelteperte/partials/item/item_card.dart';
import 'package:scelteperte/partials/item/piante/item_linked_plant.dart';
import 'package:scelteperte/partials/item/ricette/item_linked_recipe.dart';
import 'package:scelteperte/src/models/fruit_model.dart';
import 'package:scelteperte/src/models/plant_model.dart';
import 'package:scelteperte/src/models/recipe_model.dart';
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';

class FruitsItem extends StatefulWidget {

  final int postId;
  final String appBarTitle;

  FruitsItem({this.postId, this.appBarTitle});

  @override
  _FruitsItemState createState() => _FruitsItemState();
}

class _FruitsItemState extends State<FruitsItem> {

  Future<bool> fruitReady;

  Fruit frutto;

  bool hasRelatedPlants = false;
  bool hasRelatedRecipes = false;

  List<Plant> relatedPlants = [];
  List<Recipe> relatedRecipes = [];

  @override
  initState() {
    super.initState();
    this.fruitReady = getFruit();
  }

  getFruit(){
    return Fruit().getFruit(widget.postId).then((value){
      setState((){
        frutto = value;
      });
      var futures = <Future>[];

      if(frutto.plantId != null && frutto.plantId != 0) {
        futures.add(Fruit().getRelatedPlants(frutto).then((value) {
          setState(() {
            this.relatedPlants.addAll(value);
            this.hasRelatedPlants = value.length > 0 ? true : false;
          });
        }));
      }

      if(frutto.recipeId != null && frutto.recipeId != 0){
        futures.add(Fruit().getRelatedRecipes(frutto).then((value){
          setState((){
            this.relatedRecipes.addAll(value);
            this.hasRelatedRecipes = value.length > 0 ? true : false;
          });
        }));
      }

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
                future: fruitReady,
                builder: (context, AsyncSnapshot<bool> fReady) {
                  if (fReady.hasData && fReady.data == true) {
                    return InkWell(
                      child: Icon(Icons.share),
                      onTap: () => Share.share(frutto.url),
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
            future: fruitReady,
            builder: (context, AsyncSnapshot<bool> fReady){
               if(fReady.hasData && fReady.data == true){
                 return ListView(
                    children: [
                      Container(
                        height: 250,
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children:[
                              Expanded(
                                child: FadeInImage.memoryNetwork(
                                    placeholder: kTransparentImage,
                                    image: frutto.image,
                                    fit: BoxFit.fitWidth
                                ),
                              ),
                            ]
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top:25),
                        alignment: Alignment.center,
                        child: Text(frutto.title, style: TextStyle(fontSize: 18, color: Colors.green, fontWeight: FontWeight.bold)),
                      ),
                      Container(
                        margin:EdgeInsets.symmetric(vertical:15),
                        child: Html(data: frutto.description)
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Table(
                              border: TableBorder(top: BorderSide(color: Color(0xff333333), width: 0.5), bottom: BorderSide(color: Color(0xff333333), width: 0.5)),
                              children: [
                                TableRow(
                                    children: [
                                      Container(
                                        color: Color(0xffcccccc),
                                        width: 1000.0,
                                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                        child: Text("Scheda Frutta e Verdura", style: TextStyle(fontWeight: FontWeight.bold)),
                                      ),
                                    ]
                                ),
                              ],
                            ),
                          ),
                        ]
                      ),
                      FruitTable(origine: frutto.origin, stagione: frutto.season),
                      ItemCard(cardTitle: "Storia e curiosità", content: frutto.description),
                      ItemCard(cardTitle: "Caratteristiche", content: frutto.features),
                      ItemCard(cardTitle: "Varietà", content: frutto.variety),
                      if(hasRelatedPlants)
                        Wrap(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              margin: EdgeInsets.only(top:15, bottom:15),
                              child: Text('Scheda Pianta', style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold, color:Colors.green)),
                            ),
                            ItemLinkedPlant(relatedPlants: relatedPlants),
                          ],
                        ),


                      if(hasRelatedRecipes)
                        Wrap(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            margin: EdgeInsets.only(top:15, bottom:15),
                            child: Text('Ricetta Abbinata', style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold, color:Colors.green)),
                          ),
                          ItemLinkedRecipe(relatedRecipes : relatedRecipes),
                        ]),

                      Container(
                        margin: EdgeInsets.only(top:10, bottom: 10),
                        child: DownloadButton(url: frutto.pdf, buttonTitle: "Scarica Scheda PDF"),
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
