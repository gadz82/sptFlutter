import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scelteperte/src/utils.dart';

class ItemCard extends StatelessWidget {

  @required String cardTitle;
  @required String content;

  ItemCard({this.cardTitle, this.content});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text(cardTitle, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            visualDensity: VisualDensity.compact,
          ),
          Container(
            padding: EdgeInsets.only(left:15.0, right:15.0, bottom:20),
            alignment: Alignment.centerLeft,
            child: Text(
              Utils().parseHtmlString(content),
              style: TextStyle(color: Colors.black.withOpacity(0.8), fontSize: 14),
            )
          )
        ],
      ),
    );
  }
}
