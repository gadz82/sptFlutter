import 'package:flutter/material.dart';
import 'package:scelteperte/fruits_item.dart';
import 'package:scelteperte/plants_item.dart';
import 'package:scelteperte/recipes_item.dart';
import 'package:scelteperte/src/models/fruit_model.dart';
import 'package:scelteperte/src/models/plant_model.dart';
import 'package:scelteperte/src/models/recipe_model.dart';
import 'package:scelteperte/src/utils.dart';
import 'package:transparent_image/transparent_image.dart';

class HomeLastEntries extends StatefulWidget {
  @override
  _HomeLastEntriesState createState() => _HomeLastEntriesState();
}

class WrappedEntryCard extends StatelessWidget {

  final String image;
  final String title;
  final String description;
  final Function onTap;

  WrappedEntryCard({this.image, this.title, this.description, this.onTap});

  @override
  Widget build(BuildContext context) {
    return
      Container(
          padding: EdgeInsets.all(5.00),
          child: SizedBox(
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                    Wrap(
                      children: [
                        Stack(
                          alignment: Alignment.bottomLeft,
                          children: <Widget>[
                            Center(
                              child:  FadeInImage.memoryNetwork(
                                  placeholder: kTransparentImage,
                                  image: image,
                                  fit: BoxFit.cover,
                                  height: (MediaQuery.of(context).orientation == Orientation.portrait && Utils().getDeviceType() == 'phone') ? 210 : 400,
                                  width: 2000
                              ),
                            ),
                            Container(
                              height: 40,
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
                            ),
                            Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(title, style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color:Colors.white), textAlign: TextAlign.left)
                            ),
                          ],
                        ),

                        Container(
                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                            child: Text(description, style: Theme.of(context).textTheme.bodyText2)
                        ),
                        Container(
                            padding: EdgeInsets.only(right: 15, bottom:10),
                            alignment:Alignment.centerRight,
                            child: RaisedButton(
                              onPressed: () => onTap(),
                              color: Colors.green,
                              textColor: Colors.white,
                              child: const Text(
                                'Vedi',
                              ),
                            )
                        )
                      ]
                  )
              ]
            )
          )
        )
      );

  }
}


class _HomeLastEntriesState extends State<HomeLastEntries> {

  Future<Recipe> lastRecipe;
  Future<Plant> lastPlant;
  Future<Fruit> lastFruit;

  @override
  void initState() {
    super.initState();
    this.lastRecipe = Recipe().getLast();
    this.lastPlant = Plant().getLast();
    this.lastFruit = Fruit().getLast();
  }

  @override
  Widget build(BuildContext context) {
    return
      Column(
        children: [
          FutureBuilder(
              future: lastRecipe,
              builder:(context, AsyncSnapshot<Recipe> recipe){
                if(recipe.hasData){
                  return WrappedEntryCard(title: recipe.data.title, description: recipe.data.description, image : recipe.data.image, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => RecipesItem(postId: recipe.data.postId, appBarTitle: recipe.data.title))));
                } else {
                  return Center(
                      child: CircularProgressIndicator()
                  );
                }
              }),
          FutureBuilder(
              future: lastPlant,
              builder:(context, AsyncSnapshot<Plant> plant){
                if(plant.hasData){
                  return WrappedEntryCard(title: plant.data.title, description: plant.data.description, image : plant.data.image, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PlantsItem(postId: plant.data.postId, appBarTitle: plant.data.title))));
                } else {
                  return Center(
                      child: CircularProgressIndicator()
                  );
                }
              }),
          FutureBuilder(
              future: lastFruit,
              builder:(context, AsyncSnapshot<Fruit> fruit){
                if(fruit.hasData){
                  return WrappedEntryCard(title: fruit.data.title, description: fruit.data.description, image : fruit.data.image, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => FruitsItem(postId: fruit.data.postId, appBarTitle: fruit.data.title))));
                } else {
                  return Center(
                      child: CircularProgressIndicator()
                  );
                }
              })
        ]
      );

  }

}