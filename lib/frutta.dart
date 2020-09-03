import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:scelteperte/partials/filters/fruit.dart';
import 'package:scelteperte/src/filters/fruit_filters.dart';
import 'package:scelteperte/src/models/fruit_model.dart';
import 'package:transparent_image/transparent_image.dart';

class Fruits extends StatefulWidget {

  final FruitFilters activeFilters;

  Fruits({this.activeFilters});

  @override
  _FruitsState createState() => _FruitsState();
}

class _FruitsState extends State<Fruits> {

  Future<bool> fruitsReady;

  List<Fruit> frutti = [];

  bool isLoading = false;

  FruitFilters activeFilters = FruitFilters();

  ScrollController _scrollController;

  int offset = 0;
  final int limit = 40;

  @override
  initState() {
    super.initState();
    this.fruitsReady = getFruits();
    _scrollController = new ScrollController(initialScrollOffset: 0.00, keepScrollOffset: true)..addListener(_scrollListener);
  }

  getFruits(){
    return Fruit().getFruits(filter: activeFilters, offset: offset, limit: limit).then((value){
      setState((){
        frutti.addAll(value);
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

      Fruit().getFruits(filter: activeFilters, offset: offset, limit: limit).then((value){
        frutti.addAll(value);
        setState(() {
          setState(() {
            isLoading = false;
            frutti = frutti;
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


  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Frutta e Verdura"),
            backgroundColor: Colors.green,
            actions: [
              IconButton(
                icon: Icon(Icons.filter_list),
                onPressed: () async {
                  final result = await Navigator.push(context, _showFilters(FruitFilterMenu(activeFilters: this.activeFilters)));
                    if(result != null){
                      _scrollController.animateTo(
                        0.0, duration: const Duration(milliseconds: 300), curve: Curves.easeOut
                      );
                      setState(() {
                          activeFilters = result;
                          frutti = [];
                          offset = 0;
                          this.fruitsReady = Future.value(false);
                          this.fruitsReady = getFruits();
                      });
                    }
                },
              )
            ],
        ),
        body: Container(
          child: FutureBuilder(
            future: fruitsReady,
            builder: (context, AsyncSnapshot<bool> fruitsReady){
               if(fruitsReady.hasData && fruitsReady.data == true){
                 Size size = MediaQuery.of(context).size;
                 /*24 is for notification bar on Android*/
                 final double itemHeight = (size.height - kToolbarHeight - 350) / 2;
                 final double itemWidth = size.width / 2;

                 return GridView.count(
                     padding: EdgeInsets.all(5.00),
                     crossAxisSpacing: 5,
                     controller: _scrollController,
                     crossAxisCount: 2,
                     childAspectRatio: (itemWidth / itemHeight),
                     children: [
                       for(Fruit f in frutti)
                         FlatButton(
                             onPressed: () => log('dettaglio '+f.title),
                             padding: EdgeInsets.zero,
                             child: Container(
                                 child: Wrap(
                                     children: [
                                       Stack(
                                         alignment: Alignment.bottomLeft,
                                         children: <Widget>[
                                           Center(
                                               child: FadeInImage.memoryNetwork(
                                                   placeholder: kTransparentImage,
                                                   image: f.thumb,
                                                   fit: BoxFit.fitHeight,
                                                   height: (itemHeight-10)
                                               )
                                           ),
                                           Container(
                                             height: 25,
                                             width: 1000,
                                             decoration: BoxDecoration(
                                                 color: Colors.white,
                                                 gradient: LinearGradient(
                                                     begin: Alignment.centerRight,
                                                     end: Alignment.centerLeft,
                                                     colors: [
                                                       Colors.transparent,
                                                       Colors.green,
                                                     ],
                                                     stops: [
                                                       0.0,
                                                       1.0
                                                     ])),
                                             child: Padding(
                                                 padding: EdgeInsets.all(5),
                                                 child: Text(f.title, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color:Colors.white), textAlign: TextAlign.left)
                                             ),
                                           )

                                         ],
                                       )
                                     ]
                                 )
                             )
                         ),

                       if(isLoading)
                         Center(
                             child: CircularProgressIndicator()
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
