import 'dart:async';
import 'package:flutter/material.dart';
import 'package:scelteperte/partials/bottom_banner.dart';
import 'package:scelteperte/partials/filters/recipes.dart';
import 'package:scelteperte/recipes_item.dart';
import 'package:scelteperte/src/filters/recipe_filters.dart';
import 'package:scelteperte/src/models/recipe_model.dart';
import 'package:transparent_image/transparent_image.dart';

class RecipesList extends StatefulWidget {

  final RecipesFilters activeFilters;

  RecipesList({this.activeFilters});

  @override
  _RecipesListState createState() => _RecipesListState();
}

class _RecipesListState extends State<RecipesList> {

  Future<bool> recipesReady;

  List<Recipe> ricette = [];

  bool isLoading = false;

  RecipesFilters activeFilters = RecipesFilters();

  ScrollController _scrollController;

  int offset = 0;
  final int limit = 40;

  @override
  initState() {
    super.initState();
    this.recipesReady = getRecipes();
    _scrollController = new ScrollController(initialScrollOffset: 0.00, keepScrollOffset: true)..addListener(_scrollListener);
  }

  getRecipes(){
    return Recipe().getRecipes(filter: activeFilters, offset: offset, limit: limit).then((value){
      setState((){
        ricette.addAll(value);
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

      Recipe().getRecipes(filter: activeFilters, offset: offset, limit: limit).then((value){
        ricette.addAll(value);
        setState(() {
          setState(() {
            isLoading = false;
            ricette = ricette;
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
          title: Text("Ricette"),
          backgroundColor: Colors.green,
          actions: [
            IconButton(
              icon: Icon(Icons.filter_list),
              onPressed: () async {
                final result = await Navigator.push(context, _showFilters(RecipesFilterMenu(activeFilters: this.activeFilters)));
                if(result != null){
                  _scrollController.animateTo(
                      0.0, duration: const Duration(milliseconds: 300), curve: Curves.easeOut
                  );
                  setState(() {
                    activeFilters = result;
                    ricette = [];
                    offset = 0;
                    this.recipesReady = Future.value(false);
                    this.recipesReady = getRecipes();
                  });
                }
              },
            )
          ],
        ),
        bottomNavigationBar: BottomBanner(),
        body: Container(
            child: FutureBuilder(
                future: recipesReady,
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
                          for(Recipe r in ricette)
                            Card(
                              child: InkWell(
                                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => RecipesItem(postId: r.postId, appBarTitle: r.title))),
                                child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children:[
                                      Expanded(
                                          flex: 3,
                                          child: FadeInImage.memoryNetwork(
                                              placeholder: kTransparentImage,
                                              image: r.thumb,
                                              fit: BoxFit.fitWidth
                                          ),
                                        ),
                                      Expanded(
                                        flex: 6,
                                        child: Container(
                                          padding: EdgeInsets.all(10.00),
                                          child : Wrap(
                                            children: [
                                              Text(r.title, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color:Colors.green), textAlign: TextAlign.left),
                                              Divider(),
                                              Container(
                                                width: 1000,
                                                child: Text(r.description, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 13, ), textAlign: TextAlign.left)
                                              ),
                                              Container(
                                                  margin: EdgeInsets.only(top:5.00),
                                                  width: 1000,
                                                  child: Text("Pronto in ${r.preparationTime} minuti", overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, color:Colors.green ), textAlign: TextAlign.left)
                                              ),
                                              Container(
                                                  width: 1000,
                                                  margin: EdgeInsets.only(top:5.00),
                                                  child: Text("Difficoltà ${r.difficultyFilter.toUpperCase()}", overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12,color:Colors.blueGrey, fontWeight: FontWeight.bold), textAlign: TextAlign.left)
                                              ),
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
