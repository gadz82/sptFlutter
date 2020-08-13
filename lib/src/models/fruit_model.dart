import 'dart:developer';

import 'package:scelteperte/frutta.dart';
import 'package:sqflite/sqflite.dart';
import 'package:scelteperte/src/providers/db_provider.dart';

class Fruit{
  final int postId;
  final String title;
  final String url;
  final String pdf;
  final String season;
  final String origin;
  final String type;
  final String image;
  final String thumb;
  final String thumbAvatar;
  final String description;
  final String additionalInfo;
  final String history;
  final String features;
  final String variety;
  final int plantId;
  final int recipeId;
  final int date;

  Fruit({this.postId, this.title, this.url, this.pdf, this.season, this.origin, this.type, this.image, this.thumb, this.thumbAvatar, this.description, this.additionalInfo, this.history, this.features, this.variety, this.plantId, this.recipeId, this.date});

  Map<String, dynamic> toMap() {
    return {
      'post_id': postId,
      'titolo': title,
      'url': url,
      'scheda_pdf': pdf,
      'stagione': season,
      'origine': origin,
      'tipologia': type,
      'immagine': image,
      'thumb': thumb,
      'thumb_avatar': thumbAvatar,
      'descrizione': description,
      'info_aggiuntive': additionalInfo,
      'history': history,
      'caratteristiche': features,
      'varieta': variety,
      'id_pianta': plantId,
      'id_ricetta': recipeId,
      'date': date
    };
  }

  Fruit fromMap(Map map){
    return Fruit(
        postId : map['post_id'],
        title : map['titolo'],
        url : map['url'],
        pdf : map['scheda_pdf'],
        season : map['stagione'],
        origin : map['origine'],
        type : map['tipologia'],
        image : map['immagine'],
        thumb : map['thumb'],
        thumbAvatar : map['thumb_avatar'],
        description : map['descrizione'],
        additionalInfo : map['info_aggiuntive'],
        history : map['history'],
        features : map['caratteristiche'],
        variety : map['varieta'],
        plantId : map['id_pianta'],
        recipeId : map['id_ricetta'],
        date : map['date']
    );
  }

  /// Insert operation
  Future<void> insertFruit(Fruit fruit) async {
    final Database db = await DBProvider.db.database;
    await db.insert(
      'frutta_verdura',
      fruit.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// List Operation
  Future<List<Fruit>> getFruits({FruitFilters filter}) async {
    log(filter.filtroNome);
    final Database db = await DBProvider.db.database;
    final List<Map<String, dynamic>> maps = await db.query('frutta_verdura');
    return List.generate(maps.length, (i) {
      return fromMap(maps[i]);
    });
  }

  Future<Fruit> getLast() async {
    final Database db = await DBProvider.db.database;
    final List<Map<String, dynamic>> maps = await db.query('frutta_verdura', orderBy: 'date DESC', limit: 1);
    return fromMap(maps[0]);
  }

  Future<List<Fruit>> getFruit(int postId) async {
    final Database db = await DBProvider.db.database;
    final List<Map<String, dynamic>> maps = await db.query('frutta_verdura', where: 'post_id = ?', whereArgs: [postId], limit: 1);
    return List.generate(maps.length, (i) {
      return fromMap(maps[i]);
      //Fruit
    });
  }

  /// Update Operation
  Future<void> updateFruit(Fruit fruit) async {
    final Database db = await DBProvider.db.database;
    await db.update(
      'frutta_verdura',
      fruit.toMap(),
      where: "post_id = ?",
      whereArgs: [fruit.postId],
    );
  }

  /// Delete Operation
  Future<void> deleteFruit(int postId) async {
    final Database db = await DBProvider.db.database;
    await db.delete(
      'frutta_verdura',
      where: "id = ?",
      whereArgs: [postId],
    );
  }

  @override

  String toString() {
    return 'Fruit{'
        'post_id: $postId,'
        'titolo: $title,'
        'url: $url,'
        'scheda_pdf: $pdf,'
        'stagione: $season,'
        'origine: $origin,'
        'tipologia: $type,'
        'immagine: $image,'
        'thumb: $thumb,'
        'thumb_avatar: $thumbAvatar,'
        'descrizione: $description,'
        'info_aggiuntive: $additionalInfo,'
        'history: $history,'
        'caratteristiche: $features,'
        'varieta: $variety,'
        'id_pianta: $plantId,'
        'id_ricetta: $recipeId,'
        'date: $date'
        '}';
  }
}