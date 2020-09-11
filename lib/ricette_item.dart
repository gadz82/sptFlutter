import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:scelteperte/partials/item/frutta/item_linked_fruit.dart';
import 'package:scelteperte/partials/item/frutta/table.dart';
import 'package:scelteperte/partials/item/item_card.dart';
import 'package:scelteperte/partials/item/piante/item_linked_plant.dart';
import 'package:scelteperte/partials/item/piante/table.dart';
import 'package:scelteperte/partials/item/ricette/item_linked_recipe.dart';
import 'package:scelteperte/partials/item/ricette/table.dart';
import 'package:scelteperte/piante.dart';
import 'package:scelteperte/src/models/fruit_model.dart';
import 'package:scelteperte/src/models/plant_model.dart';
import 'package:scelteperte/src/models/recipe_model.dart';
import 'package:transparent_image/transparent_image.dart';

class RecipeItem extends StatefulWidget {

  final int postId;
  final String appBarTitle;

  RecipeItem({this.postId, this.appBarTitle});

  @override
  _RecipeItemState createState() => _RecipeItemState();
}

class _RecipeItemState extends State<RecipeItem> {

  Future<bool> recipeReady;

  Recipe ricetta;

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
        ricetta = value;
      });
      var futures = <Future>[];

      futures.add(Recipe().getRelatedFruits(ricetta).then((value) {
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
        ),
        body: Container(
            child: FutureBuilder(
                future: recipeReady,
                builder: (context, AsyncSnapshot<bool> rReady){
                  if(rReady.hasData && rReady.data == true){
                    log(ricetta.toString());
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
                                      image: ricetta.image,
                                      fit: BoxFit.fitWidth
                                  ),
                                ),
                              ]
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top:25),
                          alignment: Alignment.center,
                          child: Text(ricetta.title, style: TextStyle(fontSize: 18, color: Colors.green, fontWeight: FontWeight.bold)),
                        ),
                        Container(
                            margin:EdgeInsets.symmetric(vertical:15),
                            child: Html(data: ricetta.description)
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
                                            child: Text("Scheda Piatto", style: TextStyle(fontWeight: FontWeight.bold)),
                                          ),
                                        ]
                                    ),
                                  ],
                                ),
                              ),
                            ]
                        ),
                        RicettaTable(cottura: ricetta.cookingTime.toString(), difficolta: ricetta.difficultyFilter, porzioni: ricetta.portions.toString(), preparazione: ricetta.preparationTime.toString()),

                        ItemCard(cardTitle: "Preparazione", content: ricetta.preparation),

                        if(hasRelatedFruits)
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            margin: EdgeInsets.only(top:15, bottom:15),
                            child: Text('Scheda Frutto', style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold, color:Colors.green)),
                          ),

                        ItemLinkedFruit(relatedFruits: relatedFruits),

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
