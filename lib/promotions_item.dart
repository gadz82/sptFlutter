import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:scelteperte/partials/bottom_banner.dart';
import 'package:scelteperte/partials/item/download_button.dart';
import 'package:scelteperte/partials/item/frutta/item_linked_fruit.dart';
import 'package:scelteperte/partials/item/frutta/fruit_table.dart';
import 'package:scelteperte/partials/item/item_card.dart';
import 'package:scelteperte/partials/item/piante/item_linked_plant.dart';
import 'package:scelteperte/partials/item/piante/plant_table.dart';
import 'package:scelteperte/partials/item/ricette/card_igredients.dart';
import 'package:scelteperte/partials/item/ricette/item_linked_recipe.dart';
import 'package:scelteperte/partials/item/ricette/recipe_table.dart';
import 'package:scelteperte/plants_list.dart';
import 'package:scelteperte/src/models/fruit_model.dart';
import 'package:scelteperte/src/models/news_model.dart';
import 'package:scelteperte/src/models/plant_model.dart';
import 'package:scelteperte/src/models/promo_model.dart';
import 'package:scelteperte/src/models/recipe_model.dart';
import 'package:scelteperte/src/utils.dart';
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:intl/intl.dart';

class PromotionsItem extends StatefulWidget {

  final int postId;
  final String appBarTitle;

  PromotionsItem({this.postId, this.appBarTitle});

  @override
  _PromotionsItemState createState() => _PromotionsItemState();
}

class _PromotionsItemState extends State<PromotionsItem> {

  Future<bool> promoReady;

  Promo promo;


  @override
  initState() {
    super.initState();
    this.promoReady = getPromo();
  }

  getPromo(){
    return Promo().getPromo(widget.postId).then((value){
      setState((){
        promo = value;
      });
      return true;
    });
  }

  String formatDate(String dt){
    DateTime parsed = DateTime.parse(dt);
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(parsed);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.appBarTitle),
          backgroundColor: Colors.green
        ),
        bottomNavigationBar: BottomBanner(),
        body: Container(
            child: FutureBuilder(
                future: promoReady,
                builder: (context, AsyncSnapshot<bool> newsReady){
                  if(newsReady.hasData && newsReady.data == true){
                    return ListView(
                      children: [
                        Card(
                          margin: EdgeInsets.all(15.00),
                          child: Wrap(
                            children: [
                              ListTile(
                                title: Text(this.promo.title),
                                subtitle: Wrap(
                                  children: [
                                    Text("Valida dal"),
                                    Text(formatDate(this.promo.startDate), style: TextStyle(fontWeight: FontWeight.bold)),
                                    Text(" al "),
                                    Text(formatDate(this.promo.endDate), style: TextStyle(fontWeight: FontWeight.bold))
                                  ],
                                ),
                              ),
                              Container(
                                padding:EdgeInsets.symmetric(horizontal: 15.00, vertical: 20.00),
                                child: FadeInImage.memoryNetwork(
                                  placeholder: kTransparentImage,
                                  image: this.promo.coupon,
                                  fit: BoxFit.fitWidth
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 15),

                                child: Column(
                                  children: [
                                    Wrap(
                                      children: [
                                        Text(promo.description),
                                      ],
                                    ),

                                  ],
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.all(15),
                                child: RaisedButton(
                                  onPressed: (){
                                    if(promo.link != null && promo.link != '' && 0 == 1){
                                      Utils().launchURL(promo.link);
                                    } else {
                                      Utils().showSnackBar(context, "Mostra il coupon direttamente alla cassa!");
                                    }
                                  },
                                  color: Colors.green,
                                  child: Wrap(
                                    children: [
                                      Icon(Icons.euro_symbol, color: Colors.white, size: 18,),
                                      Text("  SCOPRI OFFERTA", style: TextStyle(color: Colors.white, fontSize: 16)),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
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
