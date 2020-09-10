import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:scelteperte/src/models/page_model.dart';
import 'package:scelteperte/src/models/promo_model.dart';

class Promozioni extends StatefulWidget {
  @override
  _PromozioniState createState() => _PromozioniState();
}

class _PromozioniState extends State<Promozioni> {

  Future<bool> promosReady;

  List<Promo> promos = [];

  bool isLoading = false;

  ScrollController _scrollController;

  int offset = 0;
  final int limit = 40;


  @override
  initState() {
    super.initState();
    this.promosReady = getPromos();
    _scrollController = new ScrollController(initialScrollOffset: 0.00, keepScrollOffset: true)..addListener(_scrollListener);
  }

  getPromos(){
    return Promo().getPromos(offset: offset, limit: limit).then((value){
      setState((){
        promos.addAll(value);
      });
      return true;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  //// ADDING THE SCROLL LISTINER
  _scrollListener() {
    if (_scrollController.offset >= (_scrollController.position.maxScrollExtent - 200) && !_scrollController.position.outOfRange) {
      setState(() {
        isLoading = true;
      });
      offset = offset == 0 ? offset + (this.limit + 1) : offset + this.limit;
      Promo().getPromos(offset: offset, limit: limit).then((value){
        promos.addAll(value);
        setState(() {
          setState(() {
            isLoading = false;
            promos = promos;
          });
        });
      });

    }
  }

  String _parseHtmlString(String htmlString) {
    RegExp exp = RegExp(
        r"<[^>]*>",
        multiLine: true,
        caseSensitive: true
    );

    return htmlString.replaceAll(exp, '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Promozioni"),
            backgroundColor: Colors.green
        ),
        body: Container(
            child: FutureBuilder(
                future: promosReady,
                builder: (context, AsyncSnapshot<bool> pReady){
                  if(pReady.hasData && pReady.data == true){
                    /*24 is for notification bar on Android
                    Size size = MediaQuery.of(context).size;
                    final double itemHeight = (size.height - kToolbarHeight - 350) / 2;
                    final double itemWidth = size.width / 2;*/
                    return ListView(
                        padding: EdgeInsets.all(5.00),
                        controller: _scrollController,
                        children: [
                          for(Promo p in this.promos)
                            ListTile(
                              title: Text(p.title),
                              subtitle : Text(_parseHtmlString(p.description).substring(0,80)+"...", overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 13), textAlign: TextAlign.left),
                              trailing: Icon(Icons.keyboard_arrow_right)
                            )
                        ]
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
