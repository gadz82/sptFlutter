import 'package:flutter/material.dart';
import 'package:scelteperte/src/models/fruit_model.dart';

class ItemLinkedFruit extends StatefulWidget {

  @required int postId;

  ItemLinkedFruit({this.postId});

  @override
  _ItemLinkedFruitState createState() => _ItemLinkedFruitState();
}

class _ItemLinkedFruitState extends State<ItemLinkedFruit> {

  Future<bool> itemLoaded;

  Future<List<Fruit>> linkedFruits;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
