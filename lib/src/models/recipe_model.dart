import 'package:scelteperte/src/filters/recipe_filters.dart';
import 'package:sqflite/sqflite.dart';
import 'package:scelteperte/src/providers/db_provider.dart';

class Recipe{
  final postId;
  final title;
  final url;
  final pdf;
  final description;
  final image;
  final thumb;
  final recipeType;
  final timeFilter;
  final difficultyFilter;
  final preparationTime;
  final cookingTime;
  final portions;
  final difficulty;
  final ingredients;
  final preparation;
  final evidence;
  final date;

  Recipe({this.postId, this.title, this.url, this.pdf, this.description, this.image, this.thumb, this. recipeType, this.timeFilter, this.difficultyFilter, this.preparationTime, this.cookingTime, this.portions, this.difficulty, this.ingredients, this.preparation, this.evidence, this.date});

  Map<String, dynamic> toMap() {
    return {
      'post_id': postId,
      'titolo': title,
      'url': url,
      'scheda_pdf': pdf,
      'descrizione': description,
      'immagine': image,
      'thumb': thumb,
      'tipologia_piatto': recipeType,
      'filtro_difficolta': difficultyFilter,
      'tempo_preparazione': preparationTime,
      'tempo_cottura': cookingTime,
      'porzioni': portions,
      'difficolta': difficulty,
      'ingredienti': ingredients,
      'preparazione': preparation,
      'evidenza': evidence,
      'date': date
    };
  }


  Recipe fromMap(Map map){
      return Recipe(
          postId: map['post_id'],
          title: map['titolo'],
          url: map['url'],
          pdf: map['scheda_pdf'],
          description: map['descrizione'],
          image: map['immagine'],
          thumb: map['thumb'],
          recipeType: map['tipologia_piatto'],
          difficultyFilter: map['filtro_difficolta'],
          preparationTime: map['tempo_preparazione'],
          cookingTime: map['tempo_cottura'],
          portions: map['porzioni'],
          difficulty: map['difficolta'],
          ingredients: map['ingredienti'],
          preparation: map['preparazione'],
          evidence: map['evidenza'],
          date: map['date']
      );
  }

  Future<Recipe> getFeaturedRecipe() async {
    final Database db = await DBProvider.db.database;
    final List<Map<String, dynamic>> maps = await db.query('ricette', where: 'evidenza = 1', orderBy: 'date DESC', limit: 1);
    return fromMap(maps[0]);
  }

  Future<Recipe> getLast() async {
    final Database db = await DBProvider.db.database;
    final List<Map<String, dynamic>> maps = await db.query('ricette', orderBy: 'date DESC', limit: 1);
    return fromMap(maps[0]);
  }

  /// Insert operation
  Future<void> insertRecipe(Recipe recipe) async {
    final Database db = await DBProvider.db.database;
    await db.insert(
      'ricette',
      recipe.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// List Operation
  Future<List<Recipe>> getRecipes({RecipesFilters filter, int offset, int limit}) async {
    final Database db = await DBProvider.db.database;

    String _where = '1 = 1';
    String _orderBy = 'date DESC';

    if(filter.filtroNome != null && filter.filtroNome.length > 2) _where+= " AND titolo LIKE '%"+filter.filtroNome+"%' ";
    if(filter.filtroDifficolta != null) _where+= " AND difficolta IN('"+filter.filtroDifficolta.replaceAll(',', "','")+"') ";
    if(filter.filtroTempo != null) _where+= " AND filtro_tempo IN('"+filter.filtroTempo.replaceAll(',', "','")+"') ";
    if(filter.filtroTipologiaPiatto != null) _where+= " AND tipologia_piatto IN('"+filter.filtroTipologiaPiatto.replaceAll(',', "','")+"') ";

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
    final List<Map<String, dynamic>> maps = await db.query('ricette', offset: offset, where: _where, limit: limit, orderBy: _orderBy);
    return List.generate(maps.length, (i) {
      return fromMap(maps[i]);
    });
  }



  Future<List<Recipe>> getRecipe(int postId) async {
    final Database db = await DBProvider.db.database;
    final List<Map<String, dynamic>> maps = await db.query('ricette', where: 'post_id = ?', whereArgs: [postId], limit: 1);
    return List.generate(maps.length, (i) {
      return fromMap(maps[i]);
      //Recipe
    });
  }

  /// Update Operation
  Future<void> updateRecipe(Recipe recipe) async {
    final Database db = await DBProvider.db.database;
    await db.update(
      'ricette',
      recipe.toMap(),
      where: "post_id = ?",
      whereArgs: [recipe.postId],
    );
  }

  /// Delete Operation
  Future<void> deleteRecipe(int postId) async {
    final Database db = await DBProvider.db.database;
    await db.delete(
      'ricette',
      where: "id = ?",
      whereArgs: [postId],
    );
  }

  Future<List<dynamic>> getFilters() async {
    final query =
        "SELECT " +
            "GROUP_CONCAT(DISTINCT tipologia_piatto) AS tipologia_piatto," +
            "GROUP_CONCAT(DISTINCT filtro_tempo) AS tempo," +
            "GROUP_CONCAT(DISTINCT filtro_difficolta) AS difficolta " +
            "FROM ricette " +
            "LIMIT 1 OFFSET 0";

    return await DBProvider.db.executeSelect(query);
  }


  @override

  String toString() {
    return 'Recipe{post_id: $postId, titolo: $title, url: $url, scheda_pdf: $pdf, descrizione: $description, immagine: $image, thumb: $thumb, tipologia_piatto: $recipeType, filtro_difficolta: $difficultyFilter, tempo_preparazione: $preparationTime, tempo_cottura: $cookingTime, porzioni: $portions, difficolta: $difficulty, ingredienti: $ingredients, preparazione: $preparation, evidenza: $evidence, date: $date }';
  }
}