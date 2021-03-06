import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:scelteperte/partials/bottom_banner.dart';
import 'package:scelteperte/partials/item/download_button.dart';
import 'package:scelteperte/partials/item/frutta/item_linked_fruit.dart';
import 'package:scelteperte/partials/item/item_card.dart';
import 'package:scelteperte/partials/item/piante/plant_table.dart';
import 'package:scelteperte/partials/item/piante/slider.dart';
import 'package:scelteperte/src/models/fruit_model.dart';
import 'package:scelteperte/src/models/plant_image.dart';
import 'package:scelteperte/src/models/plant_model.dart';
import 'package:scelteperte/src/utils.dart';
import 'package:share/share.dart';
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

  Plant plant;

  bool multiImage = false;

  List<PlantImage> additionalImages = [];

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
        if(value.extraImages != null && value.extraImages != ''){
          multiImage = true;
          List _additionalImages = jsonDecode(value.extraImages);
          additionalImages.add(PlantImage(title: value.title, src: value.image, thumb: value.thumb));
          for(dynamic img in _additionalImages){
            additionalImages.add(PlantImage(title: img['title'], src: img['src'], thumb: img['thumb']));
          }
        }
        plant = value;
      });
      var futures = <Future>[];

      futures.add(Plant().getRelatedFruits(plant).then((value) {
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
                  future: plantReady,
                  builder: (context, AsyncSnapshot<bool> fReady) {
                    if (fReady.hasData && fReady.data == true) {
                      return Container(
                        margin: EdgeInsets.only(right: 10),
                        child: InkWell(
                          child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Icon(Icons.share)
                          ),
                          onTap: () async => await Utils().isIpad() ? Share.share(plant.url, sharePositionOrigin: Rect.fromCenter(center: Offset(MediaQuery.of(context).size.width, 0), width: 100, height: 100)) : Share.share(plant.url),
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
            future: plantReady,
            builder: (context, AsyncSnapshot<bool> plantReady){

               if(plantReady.hasData && plantReady.data == true){
                 return ListView(
                    children: [
                      !multiImage ?
                      Container(
                        height: Utils().getDeviceType() == 'phone' ? 250 : 500,
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children:[
                              Expanded(
                                child: FadeInImage.memoryNetwork(
                                    placeholder: kTransparentImage,
                                    image: plant.image,
                                    fit: BoxFit.fitWidth
                                ),
                              ),
                            ]
                        ),
                      ) : 
                      SliderPlants(
                        slides: additionalImages,
                      ),
                      Container(
                        padding: EdgeInsets.only(top:25),
                        alignment: Alignment.center,
                        child: Text(plant.title, style: TextStyle(fontSize: 18, color: Colors.green, fontWeight: FontWeight.bold)),
                      ),
                      Container(
                        margin:EdgeInsets.symmetric(vertical:15),
                        child: Html(data: plant.description)
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
                                        child: Text("Scheda Pianta", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                                      ),
                                    ]
                                ),
                              ],
                            ),
                          ),
                        ]
                      ),
                      PlantTable(ambiente: plant.environment, fioritura: plant.flowering, tipologiaFoglie: plant.leaf, tipoPianta: plant.type),
                      ItemCard(cardTitle: "Storia e curiosità", content: plant.history),
                      ItemCard(cardTitle: "Terreno", content: plant.terrain),
                      ItemCard(cardTitle: "Tipologia Pianta", content: plant.plantType),
                      ItemCard(cardTitle: "Annaffiatura", content: plant.watering),
                      ItemCard(cardTitle: "Esposizione", content: plant.sunExposition),
                      ItemCard(cardTitle: "Malattie e Parassiti", content: plant.diseases),

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
                        child: DownloadButton(url: plant.pdf, buttonTitle: "Scarica Scheda PDF"),
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
