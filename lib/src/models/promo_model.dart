import 'dart:developer';

import 'package:sqflite/sqflite.dart';
import 'package:scelteperte/src/providers/db_provider.dart';

class Promo {
  final int postId;
  final String title;
  final String description;
  final String coupon;
  final String link;
  final String startDate;
  final String endDate;

  Promo({this.postId, this.title, this.description, this.coupon, this.link, this.startDate, this.endDate});

  Map<String, dynamic> toMap() {
    return {
      'post_id': postId,
      'titolo': title,
      'link': link,
      'descrizione': description,
      'coupon': coupon,
      'data_inizio': startDate,
      'data_fine': endDate
    };
  }

  Promo fromMap(Map map){
    return Promo(
        postId : map['post_id'],
        title : map['titolo'],
        link : map['link'],
        description : map['descrizione'],
        coupon : map['coupon'],
        startDate : map['data_inizio'],
        endDate : map['data_fine']
    );
  }

  /// Insert operation
  Future<void> insertPromo(Promo promo) async {
    final Database db = await DBProvider.db.database;
    await db.insert(
      'promozioni',
      promo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// List Operation
  Future<List<Promo>> getPromos({int offset, int limit}) async {
    final Database db = await DBProvider.db.database;

    final List<Map<String, dynamic>> maps = await db.query('promozioni', offset: offset, limit: limit);

    return List.generate(maps.length, (i) {
      log(i.toString());
      return fromMap(maps[i]);
    });
  }


  Future<List<Promo>> getPromo(int postId) async {
    final Database db = await DBProvider.db.database;
    final List<Map<String, dynamic>> maps = await db.query('promozioni', where: 'post_id = ?', whereArgs: [postId], limit: 1);
    return List.generate(maps.length, (i) {
      return fromMap(maps[i]);
      //Promo
    });
  }

  /// Update Operation
  Future<void> updatePromo(Promo promo) async {
    final Database db = await DBProvider.db.database;
    await db.update(
      'promozioni',
      promo.toMap(),
      where: "post_id = ?",
      whereArgs: [promo.postId],
    );
  }

  /// Delete Operation
  Future<void> deletePromo(int postId) async {
    final Database db = await DBProvider.db.database;
    await db.delete(
      'promozioni',
      where: "id = ?",
      whereArgs: [postId],
    );
  }

  
  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Promo{post_id: $postId, titolo: $title, link: $link, descrizione:$description, coupon:$coupon, data_inizio:$startDate, data_fine:$endDate}';
  }
}
