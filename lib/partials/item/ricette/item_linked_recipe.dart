import 'package:flutter/material.dart';
import 'package:scelteperte/recipes_item.dart';
import 'package:scelteperte/src/models/recipe_model.dart';
import 'package:scelteperte/src/utils.dart';
import 'package:transparent_image/transparent_image.dart';

class ItemLinkedRecipe extends StatelessWidget {

  @required final List<Recipe> relatedRecipes;

  ItemLinkedRecipe({this.relatedRecipes});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Wrap(
          children: [
            for(Recipe relatedRecipe in relatedRecipes)
              RaisedButton(
                  textColor: Colors.black,
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 10.00),
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => RecipesItem(postId: relatedRecipe.postId, appBarTitle: relatedRecipe.title))),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                    leading: ClipRRect(
                        //borderRadius: BorderRadius.circular(25.0),
                        child: FadeInImage.memoryNetwork(
                            placeholder: kTransparentImage,
                            image: relatedRecipe.thumb,
                            fit: BoxFit.cover,
                            height: 50,
                            width: 50
                        )
                    ),
                    title: Text(relatedRecipe.title),
                    subtitle: Text(
                        Utils().parseHtmlString(relatedRecipe.description).substring(0,30)+"...",
                        style: TextStyle(fontSize: 12.00)
                    ),
                    trailing: Icon(Icons.chevron_right),
                  )
              )
          ],
        )

    );
  }
}
