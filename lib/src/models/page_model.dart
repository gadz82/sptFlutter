import 'package:sqflite/sqflite.dart';
import 'package:scelteperte/src/providers/db_provider.dart';

class Page {
  final int postId;
  final String slug;
  final String title;
  final String url;
  final String jsonData;
  final String image;
  final String thumb;

  Page({this.postId, this.slug, this.title, this.url, this.jsonData, this.image, this.thumb});

  Map<String, dynamic> toMap() {
    return {
      'post_id': postId,
      'slug': slug,
      'titolo': title,
      'url': url,
      'json_data': jsonData,
      'immagine': image,
      'thumb': thumb
    };
  }

  Page fromMap(Map map){
    return Page(
        postId : map['post_id'],
        slug : map['slug'],
        title : map['titolo'],
        url : map['url'],
        jsonData : map['json_data'],
        image : map['immagine'],
        thumb : map['thumb']
    );
  }

  /// Insert operation
  Future<void> insertPage(Page page) async {
    final Database db = await DBProvider.db.database;
    await db.insert(
      'pagine',
      page.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// List Operation
  Future<List<Page>> getPages() async {
    final Database db = await DBProvider.db.database;
    final List<Map<String, dynamic>> maps = await db.query('pagine');
    return List.generate(maps.length, (i) {
      return fromMap(maps[i]);
    });
  }



  Future<List<Page>> getPage(int postId) async {
    final Database db = await DBProvider.db.database;
    final List<Map<String, dynamic>> maps = await db.query('pagine', where: 'post_id = ?', whereArgs: [postId], limit: 1);
    return List.generate(maps.length, (i) {
      return fromMap(maps[i]);
      //Page
    });
  }

  /// Update Operation
  Future<void> updatePage(Page page) async {
    final Database db = await DBProvider.db.database;
    await db.update(
      'pagine',
      page.toMap(),
      where: "post_id = ?",
      whereArgs: [page.postId],
    );
  }

  /// Delete Operation
  Future<void> deletePage(int postId) async {
    final Database db = await DBProvider.db.database;
    await db.delete(
      'pagine',
      where: "id = ?",
      whereArgs: [postId],
    );
  }
  
  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Page{post_id: $postId, slug: $slug, titolo: $title, url:$url, json_data:$jsonData, immagine:$image, thumb:$thumb}';
  }
}