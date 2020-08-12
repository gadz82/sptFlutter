import 'package:scelteperte/src/providers/db_provider.dart';
import 'package:sqflite/sqflite.dart';

class Slide {
  final int postId;
  final String image;
  final String navTo;
  final String navLink;

  Slide({this.postId, this.image, this.navTo, this.navLink});

  Map<String, dynamic> toMap() {
    return {
      'post_id': postId,
      'immagine': image,
      'navto': navTo,
      'navlink': navLink
    };
  }

  Slide fromMap(Map map){
    return Slide(
        postId: map['post_id'],
        image: map['immagine'],
        navTo: map['navto'],
        navLink: map['navlink']
    );
  }

  /// Insert operation
  Future<void> insertSlide(Slide slide) async {
    final Database db = await DBProvider.db.database;
    await db.insert(
      'slides',
      slide.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// List Operation
  Future<List<Slide>> getSlides() async {
    final Database db = await DBProvider.db.database;
    final List<Map<String, dynamic>> maps = await db.query('slides');
    return List.generate(maps.length, (i) {
      return Slide(
          postId: maps[i]['post_id'],
          image: maps[i]['immagine'],
          navTo: maps[i]['navto'],
          navLink: maps[i]['navlink']
      );
    });
  }

  /// Update Operation
  Future<void> updateSlide(Slide slide) async {
    final Database db = await DBProvider.db.database;
    await db.update(
      'slides',
      slide.toMap(),
      where: "post_id = ?",
      whereArgs: [slide.postId],
    );
  }

  /// Delete Operation
  Future<void> deleteSlide(int postId) async {
    final Database db = await DBProvider.db.database;
    await db.delete(
      'slides',
      where: "id = ?",
      whereArgs: [postId],
    );
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Slide{post_id: $postId, immagine: $image, navto: $navTo, navLink:$navLink}';
  }

}
