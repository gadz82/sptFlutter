import 'dart:async';
import 'package:flutter/material.dart';
import 'package:scelteperte/partials/filters/plants.dart';
import 'package:scelteperte/src/filters/fruit_filters.dart';
import 'package:scelteperte/src/filters/plant_filters.dart';
import 'package:scelteperte/src/models/plant_model.dart';
import 'package:transparent_image/transparent_image.dart';

class Plants extends StatefulWidget {

  final FruitFilters activeFilters;

  Plants({this.activeFilters});

  @override
  _PlantsState createState() => _PlantsState();
}

class _PlantsState extends State<Plants> {

  Future<bool> plantsReady;

  List<Plant> piante = [];

  bool isLoading = false;

  PlantsFilters activeFilters = PlantsFilters();

  ScrollController _scrollController;

  int offset = 0;
  final int limit = 40;

  @override
  initState() {
    super.initState();
    this.plantsReady = getPlants();
    _scrollController = new ScrollController(initialScrollOffset: 0.00, keepScrollOffset: true)..addListener(_scrollListener);
  }

  getPlants(){
    return Plant().getPlants(filter: activeFilters, offset: offset, limit: limit).then((value){
      setState((){
        piante.addAll(value);
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

      Plant().getPlants(filter: activeFilters, offset: offset, limit: limit).then((value){
        piante.addAll(value);
        setState(() {
          setState(() {
            isLoading = false;
            piante = piante;
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
          title: Text("Piante e Fiori"),
          backgroundColor: Colors.green,
          actions: [
            IconButton(
              icon: Icon(Icons.filter_list),
              onPressed: () async {
                final result = await Navigator.push(context, _showFilters(PlantsFilterMenu(activeFilters: this.activeFilters)));
                if(result != null){
                  _scrollController.animateTo(
                      0.0, duration: const Duration(milliseconds: 300), curve: Curves.easeOut
                  );
                  setState(() {
                    activeFilters = result;
                    piante = [];
                    offset = 0;
                    this.plantsReady = Future.value(false);
                    this.plantsReady = getPlants();
                  });
                }
              },
            )
          ],
        ),
        body: Container(
            child: FutureBuilder(
                future: plantsReady,
                builder: (context, AsyncSnapshot<bool> plantsReady){
                  if(plantsReady.hasData && plantsReady.data == true){
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
                          for(Plant p in piante)
                            FlatButton(
                                onPressed: (){

                                },
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
                                                      image: p.thumb,
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
                                                    child: Text(p.title, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color:Colors.white), textAlign: TextAlign.left)
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
