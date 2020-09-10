import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:scelteperte/partials/item/frutta/table.dart';
import 'package:scelteperte/partials/item/item_card.dart';
import 'package:scelteperte/src/models/fruit_model.dart';
import 'package:transparent_image/transparent_image.dart';

class FruitItem extends StatefulWidget {

  final int postId;
  final String appBarTitle;

  FruitItem({this.postId, this.appBarTitle});

  @override
  _FruitItemState createState() => _FruitItemState();
}

class _FruitItemState extends State<FruitItem> {

  Future<bool> fruitReady;

  Fruit frutto;

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
      return true;
    });
  }

  @override
  Widget build(BuildContext context) {
    log(this.frutto.toString());
    return Scaffold(
        appBar: AppBar(
            title: Text(widget.appBarTitle),
            backgroundColor: Colors.green,
        ),
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
                      FruttaTable(origine: frutto.origin, stagione: frutto.season),
                      ItemCard(cardTitle: "Storia e curiosità", content: frutto.description),
                      ItemCard(cardTitle: "Caratteristiche", content: frutto.features),
                      ItemCard(cardTitle: "Varietà", content: frutto.variety),

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
