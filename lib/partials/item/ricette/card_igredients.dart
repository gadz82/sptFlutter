import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';

class CardIngredients extends StatelessWidget {

  @required final List<dynamic> ingredients;

  CardIngredients({this.ingredients});

  @override
  Widget build(BuildContext context) {
    int length = ingredients.length;
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('Ingredienti', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            visualDensity: VisualDensity.compact,
          ),
          Container(
              padding: EdgeInsets.only(bottom:20),
              alignment: Alignment.centerLeft,
              child: Column(
                children: [
                  for(int i = 0; i < length; i++)
                    Wrap(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.00),
                          child: Html(data: ingredients[i])
                        ),
                        if((i+1) < length)
                          Divider()
                      ],
                    )

                ],
              )
          )
        ],
      ),
    );
  }
}
