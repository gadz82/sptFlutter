import 'package:sqflite/sqflite.dart';
import 'package:scelteperte/src/providers/db_provider.dart';

class News{
  final int postId;
  final String url;
  final String title;
  final String image;
  final String thumb;
  final String text;
  final int date;

  News({this.postId, this.url, this.title, this.image, this.thumb, this.text, this.date});

  Map<String, dynamic> toMap() {
    return {
      'post_id': postId,
      'url': url,
      'titolo': title,
      'immagine': image,
      'thumb': thumb,
      'testo': text,
      'date': date
    };
  }

  News fromMap(Map map){
    return News(
        postId : map['post_id'],
        url : map['url'],
        title : map['titolo'],
        image : map['immagine'],
        thumb : map['thumb'],
        text : map['testo'],
        date : map['date']
    );
  }

  /// Insert operation
  Future<void> insertNews(News news) async {
    final Database db = await DBProvider.db.database;
    await db.insert(
      'news',
      news.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// List Operation
  Future<List<News>> getAllNews({int offset, int limit}) async {
    final Database db = await DBProvider.db.database;

    final List<Map<String, dynamic>> maps = await db.query('news', offset: offset, limit: limit, orderBy: 'date DESC');
    return List.generate(maps.length, (i) {
      return fromMap(maps[i]);
    });
  }

  Future<List<News>> getNews(int postId) async {
    final Database db = await DBProvider.db.database;
    final List<Map<String, dynamic>> maps = await db.query('news', where: 'post_id = ?', whereArgs: [postId], limit: 1);
    return List.generate(maps.length, (i) {
      return fromMap(maps[i]);
      //News
    });
  }

  /// Update Operation
  Future<void> updateNews(News news) async {
    final Database db = await DBProvider.db.database;
    await db.update(
      'news',
      news.toMap(),
      where: "post_id = ?",
      whereArgs: [news.postId],
    );
  }

  /// Delete Operation
  Future<void> deleteNews(int postId) async {
    final Database db = await DBProvider.db.database;
    await db.delete(
      'news',
      where: "id = ?",
      whereArgs: [postId],
    );
  }

  @override

  String toString() {
    return 'News{'
        'post_id: $postId,'
        'titolo: $title,'
        'url: $url,'
        'testo: $text,'
        'immagine: $image,'
        'thumb: $thumb,'
        'date: $date'
        '}';
  }
}