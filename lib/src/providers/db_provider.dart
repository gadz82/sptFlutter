import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  static Database _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    // If database exists, return database
    if (_database != null) return _database;

    // If database don't exists, create one
    _database = await initDB();

    return _database;
  }

  // Create the database and the Employee table
  initDB() async {
    WidgetsFlutterBinding.ensureInitialized();
    final path = join(await getDatabasesPath(), 'sptn.db');

    return await openDatabase(
        path,
        version: 1,
        onOpen: (db) {},
        onCreate: (Database db, int version) async { await Future.wait([
          db.execute(
              "CREATE TABLE IF NOT EXISTS \"frutta_verdura\" (" +
              "`post_id` INTEGER PRIMARY KEY UNIQUE," +
              "`titolo` TEXT," +
              "`url` TEXT," +
              "`scheda_pdf` TEXT," +
              "`stagione`	TEXT," +
              "`origine` TEXT," +
              "`tipologia` TEXT," +
              "`immagine`	TEXT," +
              "`thumb` TEXT," +
              "`thumb_avatar` TEXT," +
              "`descrizione` TEXT," +
              "`info_aggiuntive` TEXT," +
              "`storia` TEXT," +
              "`caratteristiche` TEXT," +
              "`varieta` TEXT," +
              "`id_pianta` INTEGER," +
              "`id_ricetta` INTEGER," +
              "`date` INTEGER)"
          ),
          db.execute(
              "CREATE TABLE IF NOT EXISTS \"news\" (" +
                  "`post_id` INTEGER PRIMARY KEY UNIQUE," +
                  "`url` TEXT," +
                  "`titolo` TEXT," +
                  "`immagine`	TEXT," +
                  "`thumb` TEXT," +
                  "`testo` TEXT," +
                  "`date` INTEGER)"
          ),
          db.execute(
              "CREATE TABLE IF NOT EXISTS \"pagine\" (" +
                  "`post_id` INTEGER PRIMARY KEY UNIQUE," +
                  "`slug`	TEXT," +
                  "`titolo` TEXT," +
                  "`url` TEXT," +
                  "`json_data` TEXT," +
                  "`immagine`	TEXT," +
                  "`thumb` TEXT)"
          ),
          db.execute(
              "CREATE TABLE IF NOT EXISTS \"piante\" (" +
                  "`post_id` INTEGER PRIMARY KEY UNIQUE," +
                  "`titolo` TEXT," +
                  "`url` TEXT," +
                  "`scheda_pdf` TEXT," +
                  "`fioritura` TEXT," +
                  "`ambiente`	TEXT," +
                  "`foglia` TEXT," +
                  "`tipologia`	TEXT," +
                  "`immagine`	TEXT," +
                  "`immagini_extra` TEXT," +
                  "`thumb` TEXT," +
                  "`thumb_avatar` TEXT," +
                  "`descrizione`	TEXT," +
                  "`info_aggiuntive`	TEXT," +
                  "`storia`	TEXT," +
                  "`tipologia_pianta`	TEXT," +
                  "`esposizione`	TEXT," +
                  "`terreno`	TEXT," +
                  "`annaffiatura`	TEXT," +
                  "`malattie`	TEXT," +
                  "`date`	INTEGER)"
          ),
          db.execute(
              "CREATE TABLE IF NOT EXISTS \"promozioni\" (" +
                  "`post_id`	INTEGER PRIMARY KEY UNIQUE," +
                  "`titolo`	TEXT," +
                  "`link`	TEXT," +
                  "`descrizione`	TEXT," +
                  "`coupon`	TEXT," +
                  "`data_inizio`	TEXT," +
                  "`data_fine` TEXT)"
          ),
          db.execute(
              "CREATE TABLE IF NOT EXISTS \"ricette\" (" +
                  "`post_id`	INTEGER PRIMARY KEY UNIQUE," +
                  "`titolo`	TEXT," +
                  "`url`	TEXT," +
                  "`scheda_pdf` TEXT," +
                  "`descrizione`	TEXT," +
                  "`immagine`	TEXT," +
                  "`thumb` TEXT," +
                  "`tipologia_piatto`	TEXT," +
                  "`filtro_tempo`	TEXT," +
                  "`filtro_difficolta`	TEXT," +
                  "`tempo_preparazione`	INTEGER," +
                  "`tempo_cottura`	INTEGER," +
                  "`porzioni`	INTEGER," +
                  "`difficolta`	INTEGER," +
                  "`ingredienti`	TEXT," +
                  "`preparazione`	TEXT," +
                  "`evidenza`	TEXT," +
                  "`date`	INTEGER)"
          ),
          db.execute(
              "CREATE TABLE IF NOT EXISTS \"slides\" (" +
                  "`post_id`	INTEGER PRIMARY KEY UNIQUE, " +
                  "`immagine` TEXT, " +
                  "`navto` TEXT, " +
                  "`navlink` TEXT)"
          ),
          db.execute(
              "CREATE TABLE IF NOT EXISTS \"notifiche\" (" +
                  "`post_id`	INTEGER PRIMARY KEY UNIQUE, " +
                  "`titolo` TEXT, " +
                  "`testo` TEXT, " +
                  "`tipologia_contenuto_collegato` TEXT, " +
                  "`id_contenuto_collegato` INTEGER, " +
                  "`testo_alert_notifica` TEXT, " +
                  "`link_alert_notifica` TEXT, " +
                  "`date` INTEGER, " +
                  "`letto` INTEGER, " +
                  "`attivo` INTEGER)"
          )
        ]); }
    );
  }

  Future<List<Map<String, dynamic>>> executeSelect(String sql) async {
    final db = await database;
    final res = await db.rawQuery(sql);
    return res;
  }

  Future<int> executeUpdate(String sql) async {
    final db = await database;
    final res = await db.rawUpdate(sql);
    return res;
  }

  Future<int> executeInsert(String sql, List<dynamic> arguments) async {
    Database db = await database;
    return await db.rawInsert(sql, arguments);
  }

  Future<int> executeDelete(String sql) async {
    final db = await database;
    return await db.rawDelete(sql);
  }

  Future<void> executeSql(String sql) async {
    final db = await database;
    final res = await db.execute(sql);
    return res;
  }

  Future<bool> dropDb()  {
    Database db = _database;
    return Future.wait([
      db.execute("DROP TABLE IF EXISTS \"frutta_verdura\""),
      db.execute("DROP TABLE IF EXISTS \"piante\""),
      db.execute("DROP TABLE IF EXISTS \"news\""),
      db.execute("DROP TABLE IF EXISTS \"pagine\""),
      db.execute("DROP TABLE IF EXISTS \"promozioni\""),
      db.execute("DROP TABLE IF EXISTS \"ricette\""),
      db.execute("DROP TABLE IF EXISTS \"slides\""),
      db.execute("DROP TABLE IF EXISTS \"notifiche\"")
    ]).then((value) => true);
  }
}
