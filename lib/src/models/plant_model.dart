import 'package:sqflite/sqflite.dart';
import 'package:scelteperte/src/providers/db_provider.dart';

class Plant{
  final int postId;
  final String title;
  final String url;
  final String pdf;
  final String flowering;
  final String environment;
  final String leaf;
  final String type;
  final String image;
  final String extraImages;
  final String thumb;
  final String thumbAvatar;
  final String description;
  final String additionalInformations;
  final String history;
  final String plantType;
  final String sunExposition;
  final String terrain;
  final String watering;
  final String diseases;
  final int date;

  Plant({this.postId, this.title, this.url, this.pdf, this.flowering, this.environment, this.leaf, this.type, this.image, this.extraImages, this.thumb, this.thumbAvatar, this.description, this.additionalInformations, this.history, this.plantType, this.sunExposition, this.terrain, this.watering, this.diseases, this.date});

  Map<String, dynamic> toMap() {
    return {
      'post_id': postId,
      'titolo': title,
      'url': url,
      'scheda_pdf': pdf,
      'fioritura': flowering,
      'ambiente': environment,
      'foglia': leaf,
      'tipologia': type,
      'immagine': image,
      'immagini_extra': extraImages,
      'thumb': thumb,
      'thumb_avatar': thumbAvatar,
      'descrizione': description,
      'info_aggiuntive': additionalInformations,
      'storia': history,
      'tipologia_pianta': plantType,
      'esposizione': sunExposition,
      'terreno': terrain,
      'annaffiatura': watering,
      'malattie': diseases,
      'date': date
    };
  }


  Plant fromMap(Map map){
    return Plant(
        postId : map['post_id'],
        title : map['titolo'],
        url : map['url'],
        pdf : map['scheda_pdf'],
        flowering : map['fioritura'],
        environment : map['ambiente'],
        leaf : map['foglia'],
        type : map['tipologia'],
        image : map['immagine'],
        extraImages : map['immagini_extra'],
        thumb : map['thumb'],
        thumbAvatar : map['thumb_avatar'],
        description : map['descrizione'],
        additionalInformations : map['info_aggiuntive'],
        history : map['storia'],
        plantType : map['tipologia_pianta'],
        sunExposition : map['esposizione'],
        terrain : map['terreno'],
        watering : map['annaffiatura'],
        diseases : map['malattie'],
        date : map['date']
    );
  }

  /// Insert operation
  Future<void> insertPlant(Plant plant) async {
    final Database db = await DBProvider.db.database;
    await db.insert(
      'piante',
      plant.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// List Operation
  Future<List<Plant>> getPlants() async {
    final Database db = await DBProvider.db.database;
    final List<Map<String, dynamic>> maps = await db.query('piante');
    return List.generate(maps.length, (i) {
      return fromMap(maps[i]);
    });
  }



  Future<List<Plant>> getPlant(int postId) async {
    final Database db = await DBProvider.db.database;
    final List<Map<String, dynamic>> maps = await db.query('piante', where: 'post_id = ?', whereArgs: [postId], limit: 1);
    return List.generate(maps.length, (i) {
      return fromMap(maps[i]);
      //Plant
    });
  }

  /// Update Operation
  Future<void> updatePlant(Plant plant) async {
    final Database db = await DBProvider.db.database;
    await db.update(
      'piante',
      plant.toMap(),
      where: "post_id = ?",
      whereArgs: [plant.postId],
    );
  }

  /// Delete Operation
  Future<void> deletePlant(int postId) async {
    final Database db = await DBProvider.db.database;
    await db.delete(
      'piante',
      where: "id = ?",
      whereArgs: [postId],
    );
  }
  
  @override

  String toString() {
    return 'Plant{post_id: $postId, titolo: $title, url: $url, scheda_pdf:$pdf, fioritura:$flowering, ambiente:$environment, foglia:$leaf, tipologia:$type, immagine:$image, immagini_extra:$extraImages, thumb:$thumb, thumb_avatar:$thumbAvatar, descrizione: $description, info_aggiuntive: $additionalInformations, storia: $history, tipologia_pianta: $plantType, esposizione: $sunExposition, terreno: $terrain, annaffiatura $watering, malattie:$diseases, date: $date}';
  }
}
