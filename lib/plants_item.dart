import 'dart:async';
import 'dart:developer';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:scelteperte/partials/item/frutta/item_linked_fruit.dart';
import 'package:scelteperte/partials/item/frutta/fruit_table.dart';
import 'package:scelteperte/partials/item/item_card.dart';
import 'package:scelteperte/partials/item/piante/item_linked_plant.dart';
import 'package:scelteperte/partials/item/piante/plant_table.dart';
import 'package:scelteperte/partials/item/ricette/item_linked_recipe.dart';
import 'package:scelteperte/plants_list.dart';
import 'package:scelteperte/src/models/fruit_model.dart';
import 'package:scelteperte/src/models/plant_model.dart';
import 'package:scelteperte/src/models/recipe_model.dart';
import 'package:transparent_image/transparent_image.dart';

class PlantsItem extends StatefulWidget {

  final int postId;
  final String appBarTitle;

  PlantsItem({this.postId, this.appBarTitle});

  @override
  _PlantsItemState createState() => _PlantsItemState();
}

class _PlantsItemState extends State<PlantsItem> {

  Future<bool> plantReady;

  Plant pianta;

  bool hasRelatedFruits = false;
  List<Fruit> relatedFruits = [];

  @override
  initState() {
    super.initState();
    this.plantReady = getPlant();
  }

  getPlant(){
    return Plant().getPlant(widget.postId).then((value){
      setState((){
        pianta = value;
      });
      var futures = <Future>[];

      futures.add(Plant().getRelatedFruits(pianta).then((value) {
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
            future: plantReady,
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
                                    image: pianta.image,
                                    fit: BoxFit.fitWidth
                                ),
                              ),
                            ]
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top:25),
                        alignment: Alignment.center,
                        child: Text(pianta.title, style: TextStyle(fontSize: 18, color: Colors.green, fontWeight: FontWeight.bold)),
                      ),
                      Container(
                        margin:EdgeInsets.symmetric(vertical:15),
                        child: Html(data: pianta.description)
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
                                        child: Text("Scheda Pianta", style: TextStyle(fontWeight: FontWeight.bold)),
                                      ),
                                    ]
                                ),
                              ],
                            ),
                          ),
                        ]
                      ),
                      PlantTable(ambiente: pianta.environment, fioritura: pianta.flowering, tipologiaFoglie: pianta.leaf, tipoPianta: pianta.type),
                      ItemCard(cardTitle: "Storia e curiosità", content: pianta.history),
                      ItemCard(cardTitle: "Terreno", content: pianta.terrain),
                      ItemCard(cardTitle: "Tipologia Pianta", content: pianta.plantType),
                      ItemCard(cardTitle: "Annaffiatura", content: pianta.watering),
                      ItemCard(cardTitle: "Esposizione", content: pianta.sunExposition),
                      ItemCard(cardTitle: "Malattie e Parassiti", content: pianta.diseases),

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
