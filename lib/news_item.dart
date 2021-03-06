import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:scelteperte/partials/bottom_banner.dart';
import 'package:scelteperte/src/models/news_model.dart';
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
                    return Container(
                        margin: EdgeInsets.only(right: 10),
                        child: InkWell(
                          child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Icon(Icons.share)
                          ),
                          onTap: () async => await Utils().isIpad() ? Share.share(news.url, sharePositionOrigin: Rect.fromCenter(center: Offset(MediaQuery.of(context).size.width, 0), width: 100, height: 100)) : Share.share(news.url),
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
                future: newsReady,
                builder: (context, AsyncSnapshot<bool> newsReady){
                  if(newsReady.hasData && newsReady.data == true){
                    return ListView(
                      children: [
                        Container(
                          height: Utils().getDeviceType() == 'phone' ? 150 : 350,
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
