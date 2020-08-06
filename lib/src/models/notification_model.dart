import 'package:sqflite/sqflite.dart';
import 'package:scelteperte/src/providers/db_provider.dart';

class Notification {
  final int postId;
  final String title;
  final String text;
  final String linkedContentType;
  final String linkedContentId;
  final String notificationAlertText;
  final String notificationAlertLink;
  final int date;
  final int read;
  final int active;

  Notification({this.postId, this.title, this.text, this.linkedContentType, this.linkedContentId, this.notificationAlertText, this.notificationAlertLink, this.date, this.read, this.active});

  Map<String, dynamic> toMap() {
    return {
      'post_id': postId,
      'titolo': title,
      'testo': text,
      'tipologia_contenuto_collegato': linkedContentType,
      'id_contenuto_collegato': linkedContentId,
      'testo_alert_notifica': notificationAlertText,
      'link_alert_notifica': notificationAlertLink,
      'date': date,
      'letto': read,
      'attivo': active,
    };
  }

  Notification fromMap(Map map){
    return Notification(
      postId : map['post_id'],
      title : map['titolo'],
      text : map['testo'],
      linkedContentType : map['tipologia_contenuto_collegato'],
      linkedContentId : map['id_contenuto_collegato'],
      notificationAlertText : map['testo_alert_notifica'],
      notificationAlertLink : map['link_alert_notifica'],
      date : map['date'],
      read : map['letto'],
      active : map['attivo']
    );
  }

  /// Insert operation
  Future<void> insertNotification(Notification notification) async {
    final Database db = await DBProvider.db.database;
    await db.insert(
      'notifiche',
      notification.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// List Operation
  Future<List<Notification>> getNotifications() async {
    final Database db = await DBProvider.db.database;
    final List<Map<String, dynamic>> maps = await db.query('notifiche');
    return List.generate(maps.length, (i) {
      return fromMap(maps[i]);
    });
  }



  Future<List<Notification>> getNotification(int postId) async {
    final Database db = await DBProvider.db.database;
    final List<Map<String, dynamic>> maps = await db.query('notifiche', where: 'post_id = ?', whereArgs: [postId], limit: 1);
    return List.generate(maps.length, (i) {
      return fromMap(maps[i]);
      //Notification
    });
  }

  /// Update Operation
  Future<void> updateNotification(Notification notification) async {
    final Database db = await DBProvider.db.database;
    await db.update(
      'notifiche',
      notification.toMap(),
      where: "post_id = ?",
      whereArgs: [notification.postId],
    );
  }

  /// Delete Operation
  Future<void> deleteNotification(int postId) async {
    final Database db = await DBProvider.db.database;
    await db.delete(
      'notifiche',
      where: "id = ?",
      whereArgs: [postId],
    );
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Notifica{post_id: $postId, titolo: $title, testo: $text, tipologia_contenuto_collegato:$linkedContentType, id_contenuto_collegato:$linkedContentId, testo_alert_notifica:$notificationAlertText, link_alert_notifica:$notificationAlertLink, date:$date, letto:$read, attivo:$active}';
  }
}