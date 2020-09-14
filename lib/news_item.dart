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
import 'package:scelteperte/src/models/recipe_model.dart';
import 'package:scelteperte/src/utils.dart';
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';

class NewsItem extends StatefulWidget {

  final int postId;
  final String appBarTitle;

  NewsItem({this.postId, this.appBarTitle});

  @override
  _NewsItemState createState() => _NewsItemState();
}

class _NewsItemState extends State<NewsItem> {

  Future<bool> newsReady;

  News news;


  @override
  initState() {
    super.initState();
    this.newsReady = getNews();
  }

  getNews(){
    return News().getNews(widget.postId).then((value){
      setState((){
        news = value;
      });
      return true;
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
                future: newsReady,
                builder: (context, AsyncSnapshot<bool> newsReady) {
                  if (newsReady.hasData && newsReady.data == true) {
                    return InkWell(
                      child: Icon(Icons.share),
                      onTap: () => Share.share(news.url),
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
                future: newsReady,
                builder: (context, AsyncSnapshot<bool> newsReady){
                  if(newsReady.hasData && newsReady.data == true){
                    return ListView(
                      children: [
                        Container(
                          height: 150,
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children:[
                                Expanded(
                                  child: FadeInImage.memoryNetwork(
                                      placeholder: kTransparentImage,
                                      image: news.image,
                                      fit: BoxFit.fitWidth
                                  ),
                                ),
                              ]
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top:25),
                          alignment: Alignment.center,
                          child: Text(news.title, style: TextStyle(fontSize: 18, color: Colors.green, fontWeight: FontWeight.bold)),
                        ),
                        Container(
                            margin:EdgeInsets.symmetric(vertical:15),
                            child: Html(data: news.text, onLinkTap: (url){
                              if(url != null) Utils().launchURL(url);
                            })
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
