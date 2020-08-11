import 'dart:developer';

import 'package:sqflite/sqflite.dart';
import 'package:scelteperte/src/providers/db_provider.dart';

class Recipe{
  final int postId;
  final String title;
  final String url;
  final String pdf;
  final String description;
  final String image;
  final String thumb;
  final String recipeType;
  final String timeFilter;
  final String difficultyFilter;
  final int preparationTime;
  final int cookingTime;
  final int portions;
  final int difficulty;
  final String ingredients;
  final String preparation;
  final String evidence;
  final int date;

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
  Future<List<Recipe>> getRecipes() async {
    final Database db = await DBProvider.db.database;
    final List<Map<String, dynamic>> maps = await db.query('ricette');
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


  @override

  String toString() {
    return 'Recipe{post_id: $postId, titolo: $title, url: $url, scheda_pdf: $pdf, descrizione: $description, immagine: $image, thumb: $thumb, tipologia_piatto: $recipeType, filtro_difficolta: $difficultyFilter, tempo_preparazione: $preparationTime, tempo_cottura: $cookingTime, porzioni: $portions, difficolta: $difficulty, ingredienti: $ingredients, preparazione: $preparation, evidenza: $evidence, date: $date }';
  }
}