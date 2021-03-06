import 'dart:developer';

import 'package:scelteperte/src/filters/fruit_filters.dart';
import 'package:scelteperte/src/models/plant_model.dart';
import 'package:scelteperte/src/models/recipe_model.dart';
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
        history : map['storia'],
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
  Future<List<Fruit>> getFruits({FruitFilters filter, int offset, int limit}) async {
    final Database db = await DBProvider.db.database;
    String _where = '1 = 1';
    String _orderBy = 'date DESC';

    if(filter.filtroNome != null && filter.filtroNome.length > 2) _where+= " AND titolo LIKE '%"+filter.filtroNome+"%' ";
    if(filter.filtroOrigine != null) _where+= " AND origine IN('"+filter.filtroOrigine.replaceAll(',', "','")+"') ";
    if(filter.filtroTipologia != null) _where+= " AND tipologia IN('"+filter.filtroTipologia.replaceAll(',', "','")+"') ";
    if(filter.filtroStagione != null) _where+= " AND stagione IN('"+filter.filtroStagione.replaceAll(',', "','")+"') ";

    if(filter.filtroOrdinamento != null){

      switch(filter.filtroOrdinamento){
        case 'alfabetico-az':
          _orderBy = "titolo ASC";
          break;
        case 'alfabetico-za':
          _orderBy = "titolo DESC";
          break;
        case 'recenti':
          _orderBy = "date DESC";
          break;
        case 'no-recenti':
          _orderBy = "date ASC";
          break;
        default :
          _orderBy = "date DESC";
          break;
      }

    } else {
      _orderBy = "date DESC";
    }

    final List<Map<String, dynamic>> maps = await db.query('frutta_verdura', offset: offset, where: _where, limit: limit, orderBy: _orderBy);
    return List.generate(maps.length, (i) {
      return fromMap(maps[i]);
    });
  }

  Future<Fruit> getLast() async {
    final Database db = await DBProvider.db.database;
    final List<Map<String, dynamic>> maps = await db.query('frutta_verdura', orderBy: 'date DESC', limit: 1);
    return fromMap(maps[0]);
  }

  Future<Fruit> getFruit(int postId) async {
    final Database db = await DBProvider.db.database;
    final List<Map<String, dynamic>> maps = await db.query('frutta_verdura', where: 'post_id = ?', whereArgs: [postId], limit: 1);
    return fromMap(maps[0]);
  }

  Future<List<Plant>> getRelatedPlants(Fruit fruit) async {
    if(fruit.plantId == null || fruit.plantId == 0) throw Exception('no related');
    final Database db = await DBProvider.db.database;
    final List<Map<String, dynamic>> maps = await db.query('piante', where: 'post_id = ?', whereArgs: [fruit.plantId]);
    return List.generate(maps.length, (i) {
      return Plant().fromMap(maps[i]);
    });
  }

  Future<List<Recipe>> getRelatedRecipes(Fruit fruit) async {
    log(fruit.recipeId.toString());
    if(fruit.recipeId == null || fruit.recipeId == 0) throw Exception('no related');
    final Database db = await DBProvider.db.database;
    final List<Map<String, dynamic>> maps = await db.query('ricette', where: 'post_id = ?', whereArgs: [fruit.recipeId]);
    return List.generate(maps.length, (i) {
      return Recipe().fromMap(maps[0]);
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

  Future<List<dynamic>> getFilters() async {
    final query =
        "SELECT " +
            "GROUP_CONCAT(DISTINCT stagione) AS stagione," +
            "GROUP_CONCAT(DISTINCT origine) AS origine," +
            "GROUP_CONCAT(DISTINCT tipologia) AS tipologia "+
            "FROM frutta_verdura " +
            "LIMIT 1 OFFSET 0";

    return await DBProvider.db.executeSelect(query);
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