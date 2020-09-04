import 'dart:async';
import 'package:flutter/material.dart';
import 'package:scelteperte/src/models/news_model.dart' as NewsModel;
import 'package:transparent_image/transparent_image.dart';

class News extends StatefulWidget {
  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News> {

  Future<bool> newsReady;

  List<NewsModel.News> news = [];

  bool isLoading = false;

  ScrollController _scrollController;

  int offset = 0;
  final int limit = 40;

  @override
  initState() {
    super.initState();
    this.newsReady = getNews();
    _scrollController = new ScrollController(initialScrollOffset: 0.00, keepScrollOffset: true)..addListener(_scrollListener);
  }

  getNews(){
    return NewsModel.News().getAllNews(offset: offset, limit: limit).then((value){
      setState((){
        news.addAll(value);
      });
      return true;
    });
  }

  //// ADDING THE SCROLL LISTINER
  _scrollListener() {
    if (_scrollController.offset >= (_scrollController.position.maxScrollExtent - 200) && !_scrollController.position.outOfRange) {
      setState(() {
        isLoading = true;
      });
      offset = offset == 0 ? offset + (this.limit + 1) : offset + this.limit;
      NewsModel.News().getAllNews(offset: offset, limit: limit).then((value){
        news.addAll(value);
        setState(() {
          setState(() {
            isLoading = false;
            news = news;
          });
        });
      });

    }
  }

  Route _showFilters(Widget filterWidget) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => filterWidget,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
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
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Consigli e Curiosità"),
          backgroundColor: Colors.green
        ),
        body: Container(
            child: FutureBuilder(
                future: newsReady,
                builder: (context, AsyncSnapshot<bool> recipesReady){
                  if(recipesReady.hasData && recipesReady.data == true){
                    /*24 is for notification bar on Android
                    Size size = MediaQuery.of(context).size;
                    final double itemHeight = (size.height - kToolbarHeight - 350) / 2;
                    final double itemWidth = size.width / 2;*/
                    return ListView(
                        padding: EdgeInsets.all(5.00),
                        controller: _scrollController,
                        children: [
                          for(NewsModel.News n in news)
                            Card(
                              child: InkWell(
                                  onTap: (){

                                  },
                                  child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children:[
                                        Expanded(
                                          flex: 3,
                                          child: FadeInImage.memoryNetwork(
                                              placeholder: kTransparentImage,
                                              image: n.thumb,
                                              fit: BoxFit.fitWidth
                                          ),
                                        ),
                                        Expanded(
                                            flex: 6,
                                            child: Container(
                                                padding: EdgeInsets.all(10.00),
                                                child : Wrap(
                                                    children: [
                                                      Text(n.title,style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color:Colors.green), textAlign: TextAlign.left),
                                                      Divider(),
                                                      Container(
                                                          width: 1000,
                                                          child: Text(_parseHtmlString(n.text).substring(0,80)+"...", style: TextStyle(fontSize: 13), textAlign: TextAlign.left)
                                                      )
                                                    ]
                                                )
                                            )
                                        ),

                                      ]
                                  )

                              ),
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
