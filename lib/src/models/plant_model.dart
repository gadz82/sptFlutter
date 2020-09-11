import 'package:scelteperte/src/filters/plant_filters.dart';
import 'package:scelteperte/src/models/fruit_model.dart';
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

  Future<Plant> getLast() async {
    final Database db = await DBProvider.db.database;
    final List<Map<String, dynamic>> maps = await db.query('piante', orderBy: 'date DESC', limit: 1);
    return fromMap(maps[0]);
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
  Future<List<Plant>> getPlants({PlantsFilters filter, int offset, int limit}) async {
    final Database db = await DBProvider.db.database;

    String _where = '1 = 1';
    String _orderBy = 'date DESC';

    if(filter.filtroNome != null && filter.filtroNome.length > 2) _where+= " AND titolo LIKE '%"+filter.filtroNome+"%' ";
    if(filter.filtroTipologia != null) _where+= " AND tipologia IN('"+filter.filtroTipologia.replaceAll(',', "','")+"') ";
    if(filter.filtroAmbiente != null) _where+= " AND ambiente IN('"+filter.filtroAmbiente.replaceAll(',', "','")+"') ";
    if(filter.filtroFoglia != null) _where+= " AND foglia IN('"+filter.filtroFoglia.replaceAll(',', "','")+"') ";
    if(filter.filtroFioritura != null) _where+= " AND fioritura IN('"+filter.filtroFioritura.replaceAll(',', "','")+"') ";

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
    final List<Map<String, dynamic>> maps = await db.query('piante', offset: offset, where: _where, limit: limit, orderBy: _orderBy);
    return List.generate(maps.length, (i) {
      return fromMap(maps[i]);
    });
  }

  Future<Plant> getPlant(int postId) async {
    final Database db = await DBProvider.db.database;
    final List<Map<String, dynamic>> maps = await db.query('piante', where: 'post_id = ?', whereArgs: [postId], limit: 1);
    return fromMap(maps[0]);
  }

  Future<List<Fruit>> getRelatedFruits(Plant plant) async {
    final Database db = await DBProvider.db.database;
    final List<Map<String, dynamic>> maps = await db.query('frutta_verdura', where: 'id_pianta = ?', whereArgs: [plant.postId]);
    return List.generate(maps.length, (i) {
      return Fruit().fromMap(maps[i]);
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

  Future<List<dynamic>> getFilters() async {
    final query =
        "SELECT " +
            "GROUP_CONCAT(DISTINCT ambiente) AS ambiente," +
            "GROUP_CONCAT(DISTINCT foglia) AS foglia," +
            "GROUP_CONCAT(DISTINCT tipologia) AS tipologia,"+
            "GROUP_CONCAT(DISTINCT fioritura) AS fioritura "+
            "FROM piante " +
            "LIMIT 1 OFFSET 0";

    return await DBProvider.db.executeSelect(query);
  }


  @override

  String toString() {
    return 'Plant{post_id: $postId, titolo: $title, url: $url, scheda_pdf:$pdf, fioritura:$flowering, ambiente:$environment, foglia:$leaf, tipologia:$type, immagine:$image, immagini_extra:$extraImages, thumb:$thumb, thumb_avatar:$thumbAvatar, descrizione: $description, info_aggiuntive: $additionalInformations, storia: $history, tipologia_pianta: $plantType, esposizione: $sunExposition, terreno: $terrain, annaffiatura $watering, malattie:$diseases, date: $date}';
  }
}
