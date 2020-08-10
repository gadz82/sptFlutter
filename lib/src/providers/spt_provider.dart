import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:scelteperte/src/providers/db_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';

class SptProvider {
  /// K/V local app storage
  static SharedPreferences _preferences;

  static const int appVersionDefault = 12;

  static final String baseUrl = "http://www.scelteperte.it/sptrapi/initialize?mtoken=FNmZbp6nR7EEs7Eg&ts=";

  SptProvider._();

  static Future<SharedPreferences> get localStorage async {
    if (_preferences != null) return _preferences;
    _preferences = await SharedPreferences.getInstance();
    return _preferences;
  }

  static set table(String table) {}

  static Future<bool> fetchData() async {
    final storage = await localStorage;

    final int appVersion = storage.containsKey('appVersion') ? storage.getInt('appVersion') : appVersionDefault;

    String url = baseUrl;
    if(storage.containsKey('initMd5')) url += '&md5='+storage.getString('initMd5');
    if(storage.containsKey('tokenSlides')) url += '&md5_tokenSlides='+storage.getString('tokenSlides');
    if(storage.containsKey('tokenFruttaVerdura')) url += '&md5_tokenFruttaVerdura='+storage.getString('tokenFruttaVerdura');
    if(storage.containsKey('tokenPiante')) url += '&md5_tokenPiante='+storage.getString('tokenPiante');
    if(storage.containsKey('tokenPagine')) url += '&md5_tokenPagine='+storage.getString('tokenPagine');
    if(storage.containsKey('tokenRicette')) url += '&md5_tokenRicette='+storage.getString('tokenRicette');
    if(storage.containsKey('tokenNews')) url += '&md5_tokenNews='+storage.getString('tokenNews');
    if(storage.containsKey('tokenNotifiche')) url += '&md5_tokenNotifiche='+storage.getString('tokenNotifiche');

    final response =  await http.get('http://www.scelteperte.it/sptrapi/initialize?mtoken=FNmZbp6nR7EEs7Eg&ts=');

    if (response.statusCode == 200) {
      //log('Apiresponse', name: 'Api Response', error: jsonDecode(response.body));
      var data = jsonDecode(response.body);
      if(data['content']['nodata'] != null){
        return true;
      } else {
        if(data['content']['rebootAppVersion'] != null && appVersion < int.parse(data['content']['rebootAppVersion'])){
          DBProvider.db.dropDb().then((value) async {
            storage.setInt('rebootAppVersion', int.parse(data['content']['rebootAppVersion']));
            await DBProvider.db.initDB();
            return popDb(data).then((value) => true);
          });
        } else {
          return popDb(data).then((value) => true);
        }
      }

    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<bool> popDb(dynamic data) async {
    var futures = <Future>[];

    ///SLIDES
    if(data['content']['e404_slide'] != null){
      List chunks = arrayChunk(data['content']['e404_slide'], 40);
      for(int x = 0; x < chunks.length; x++){
        int nr = chunks[x].length;

        String query = "INSERT OR REPLACE INTO `slides`" +
            "(`post_id`,`immagine`,`navto`,`navlink`) " +
            "VALUES ";
        List qparts = [];
        List bindings = [];
        for(int i = 0; i < nr; i++){
          final sl = chunks[x][i];
          qparts.add('(?,?,?,?)');
          bindings.addAll([sl['id'], sl['image'], sl['navto'], sl['navlink']]);
        }
        query += qparts.join(',');
        if(x == 0){
          futures.add(DBProvider.db.executeInsert(query, bindings));
        } else {
          DBProvider.db.executeInsert(query, bindings);
        }
      }
    }

    ///PAGINE
    if(data['content']['page'] != null){
      List chunks = arrayChunk(data['content']['page'], 40);
      for(int x = 0; x < chunks.length; x++){
        int nr = chunks[x].length;

        String query = "INSERT OR REPLACE INTO `pagine`" +
            "(`post_id`,`slug`,`titolo`,`url`,`json_data`,`immagine`,`thumb`) " +
            "VALUES ";
        List qparts = [];
        List bindings = [];
        for(int i = 0; i < nr; i++){
          final pag = chunks[x][i];
          qparts.add('(?,?,?,?,?,?,?)');
          bindings.addAll([pag['id'], pag['slug'], pag['title'],pag['link'],pag['app_content'],pag['image'] ,pag['thumb']]);
        }
        query += qparts.join(',');
        if(x == 0){
          futures.add(DBProvider.db.executeInsert(query, bindings));
        } else {
          DBProvider.db.executeInsert(query, bindings);
        }
      }
    }

    ///NOTIFICHE
    if(data['content']['notifiche'] != null){
      List chunks = arrayChunk(data['content']['notifiche'], 40);
      for(int x = 0; x < chunks.length; x++){
        int nr = chunks[x].length;

        String query = "INSERT OR REPLACE INTO `notifiche`" +
            "(`post_id`,`titolo`,`testo`,`tipologia_contenuto_collegato`,`id_contenuto_collegato`,`testo_alert_notifica`,`link_alert_notifica`,`date`,`letto`,`attivo`) " +
            "VALUES ";
        List qparts = [];
        List bindings = [];
        for(int i = 0; i < nr; i++){
          final nt = chunks[x][i];
          qparts.add('(?,?,?,?,?,?,?,?,?,?)');
          bindings.addAll([ nt['id'], nt['title'], nt['testo'], nt['tipologia_contenuto_collegato'], nt['id_contenuto_collegato'], nt['testo_alert_notifica'], nt['link_alert_notifica'], nt['date'], 0, 1]);
        }
        query += qparts.join(',');
        if(x == 0){
          futures.add(DBProvider.db.executeInsert(query, bindings));
        } else {
          DBProvider.db.executeInsert(query, bindings);
        }
      }
    }

    ///PROMOZIONI
    if(data['content']['promozioni'] != null){
      List chunks = arrayChunk(data['content']['promozioni'], 40);
      for(int x = 0; x < chunks.length; x++){
        int nr = chunks[x].length;

        String query = "INSERT OR REPLACE INTO `promozioni`" +
            "(`post_id`,`titolo`,`descrizione`,`coupon`,`link`,`data_inizio`,`data_fine`) " +
            "VALUES ";
        List qparts = [];
        List bindings = [];
        for(int i = 0; i < nr; i++){
          final o = chunks[x][i];
          qparts.add('(?,?,?,?,?,?,?)');
          bindings.addAll([ o['id'], o['title'], o['descrizione'], o['coupon'], o['link'], o['data_inizio'], o['data_fine'] ]);
        }
        query += qparts.join(',');
        if(x == 0){
          futures.add(DBProvider.db.executeInsert(query, bindings));
        } else {
          DBProvider.db.executeInsert(query, bindings);
        }
      }
    }

    ///NEWS
    if(data['content']['post'] != null){
      List chunks = arrayChunk(data['content']['post'], 40);
      for(int x = 0; x < chunks.length; x++){
        int nr = chunks[x].length;

        String query = "INSERT OR REPLACE INTO `news`" +
            "(`post_id`,`titolo`,`url`,`immagine`,`thumb`,`testo`, `date`) " +
            "VALUES ";
        List qparts = [];
        List bindings = [];
        for(int i = 0; i < nr; i++){
          final n = chunks[x][i];
          qparts.add('(?,?,?,?,?,?,?)');
          bindings.addAll([ n['id'], n['title'], n['link'], n['image'], n['thumb'], n['testo'], n['date'] ]);
        }
        query += qparts.join(',');
        if(x == 0){
          futures.add(DBProvider.db.executeInsert(query, bindings));
        } else {
          DBProvider.db.executeInsert(query, bindings);
        }
      }
    }

    ///RICETTE
    if(data['content']['ricette'] != null){
      List chunks = arrayChunk(data['content']['ricette'], 40);
      for(int x = 0; x < chunks.length; x++){
        int nr = chunks[x].length;

        String query = "INSERT OR REPLACE INTO `ricette`" +
            "(`post_id`,`titolo`,`url`,`scheda_pdf`,`tipologia_piatto`,`filtro_tempo`,`filtro_difficolta`,`descrizione`,`tempo_preparazione`,`tempo_cottura`,`porzioni`, `difficolta`,`ingredienti`,`immagine`,`thumb`,`preparazione`,`evidenza`,`date`) " +
            "VALUES ";
        List qparts = [];
        List bindings = [];
        for(int i = 0; i < nr; i++){
          final r = chunks[x][i];

          String filtro_tipologia = r['filtri'] != null && r['filtri']['tipologia-piatto'] != null ? r['filtri']['tipologia-piatto'] : '';
          String filtro_tempo = r['filtri'] != null && r['filtri']['tempo-preparazione'] != null ? r['filtri']['tempo-preparazione'] : '';
          String filtro_difficolta = r['filtri'] != null && r['filtri']['difficolta'] != null ? r['filtri']['difficolta'] : '';

          qparts.add('(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)');
          bindings.addAll([
            r['id'],
            r['title'],
            r['link'],
            r['scheda_pdf'],
            filtro_tipologia,
            filtro_tempo,
            filtro_difficolta,
            r['introduzione'],
            r['tempo'],
            r['tempo_cottura'],
            r['porzioni'],
            r['difficolta'],
            jsonEncode(r['ingredienti']),
            r['image'],
            r['thumb'],
            r['preparazione'],
            r['evidenza'],
            r['date']
          ]);
        }
        query += qparts.join(',');
        if(x == 0){
          futures.add(DBProvider.db.executeInsert(query, bindings));
        } else {
          DBProvider.db.executeInsert(query, bindings);
        }
      }
    }

    ///FRUTTA E VERDURA
    if(data['content']['frutta-verdura'] != null){
      List chunks = arrayChunk(data['content']['frutta-verdura'], 40);
      for(int x = 0; x < chunks.length; x++){
        int nr = chunks[x].length;

        String query = "INSERT OR REPLACE INTO `frutta_verdura`" +
            "(`post_id`,`titolo`,`url`,`scheda_pdf`,`stagione`,`origine`,`tipologia`,`immagine`,`thumb`,`thumb_avatar`,`descrizione`,`info_aggiuntive`,`storia`,`caratteristiche`,`varieta`, `id_pianta`, `id_ricetta`,`date`) " +
            "VALUES ";
        List qparts = [];
        List bindings = [];
        for(int i = 0; i < nr; i++){
          final f = chunks[x][i];

          String filtro_stagione = f['filtri'] != null && f['filtri']['stagione'] != null ? f['filtri']['stagione'] : '';
          String filtro_origine = f['filtri'] != null && f['filtri']['origine'] != null ? f['filtri']['origine'] : '';
          String filtro_tipologia_fv = f['filtri'] != null && f['filtri']['tipologia-frutta-verdura'] != null ? f['filtri']['tipologia-frutta-verdura'] : '';

          qparts.add('(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)');
          bindings.addAll([
            f['id'],
            f['title'],
            f['link'],
            f['scheda_pdf'],
            filtro_stagione,
            filtro_origine,
            filtro_tipologia_fv,
            f['immagine'],
            f['thumb'],
            f['thumb_avatar'],
            f['descrizione'],
            f['info-aggiuntive'],
            f['storia'],
            f['caratteristiche'],
            f['varieta'],
            f['id_pianta_collegata'],
            f['id_ricetta_collegata'],
            f['date']
          ]);
        }
        query += qparts.join(',');
        if(x == 0){
          futures.add(DBProvider.db.executeInsert(query, bindings));
        } else {
          DBProvider.db.executeInsert(query, bindings);
        }
      }
    }

    ///PIANTE E FIORI
    if(data['content']['prodotti'] != null){
      List chunks = arrayChunk(data['content']['prodotti'], 40);
      for(int x = 0; x < chunks.length; x++){
        int nr = chunks[x].length;

        String query = "INSERT OR REPLACE INTO `piante`" +
            "(`post_id`,`titolo`,`url`,`scheda_pdf`,`fioritura`,`ambiente`,`foglia`,`tipologia`,`immagine`, `immagini_extra`,`thumb`,`thumb_avatar`,`descrizione`,`info_aggiuntive`,`storia`,`terreno`,`tipologia_pianta`,`annaffiatura`,`esposizione`,`malattie`,`date`) " +
            "VALUES ";
        List qparts = [];
        List bindings = [];
        for(int i = 0; i < nr; i++){
          final p = chunks[x][i];

          String filtro_fioritura = p['filtri'] != null && p['filtri']['fioritura'] != null ? p['filtri']['fioritura'] : '';
          String filtro_ambiente = p['filtri'] != null && p['filtri']['ambiente'] != null ? p['filtri']['ambiente'] : '';
          String filtro_foglie = p['filtri'] != null && p['filtri']['foglie'] != null ? p['filtri']['foglie'] : '';
          String filtro_tipologia = p['filtri'] != null && p['filtri']['tipologia-piante'] != null ? p['filtri']['tipologia-piante'] : '';

          qparts.add('(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)');
          bindings.addAll([
            p['id'],
            p['title'],
            p['link'],
            p['scheda_pdf'],
            filtro_fioritura,
            filtro_ambiente,
            filtro_foglie,
            filtro_tipologia,
            p['immagine'],
            p['immagini_extra'],
            p['thumb'],
            p['thumb_avatar'],
            p['descrizione'],
            p['info-aggiuntive'],
            p['storia'],
            p['terreno'],
            p['tipologia'],
            p['annaffiatura'],
            p['esposizione'],
            p['malattie'],
            p['date']
          ]);
        }
        query += qparts.join(',');
        if(x == 0){
          futures.add(DBProvider.db.executeInsert(query, bindings));
        } else {
          DBProvider.db.executeInsert(query, bindings);
        }
      }
    }

    ///TRASH
    if(data['content']['trash'] != null){
      data['content']['trash'].forEach((key, value){
        String table = "";
        switch(key){
          case 'ricette':
            table = key;
            break;
          case 'promozioni-app':
            table = 'promozioni';
            break;
          case 'post':
            table = 'news';
            break;
          case 'prodotti':
            table = 'piante';
            break;
          case 'frutta-verdura':
            table = 'frutta_verdura';
            break;
          case 'page':
            table = 'pagine';
            break;
          case 'notifiche-push':
            table = 'notifiche';
            break;
          case 'e404_slide':
            table = 'slides';
            break;
        }
        if(table != ""){
          futures.add(DBProvider.db.executeDelete("DELETE FROM "+table+" WHERE post_id IN("+data['content']['trash'][key].join(',')+")"));
        }
      });
    }

    final storage = await localStorage;

    storage.setString('initMd5', data['content']['md5']);

    if(data['content']['md5_tokenFruttaVerdura'] != null){
      storage.setString('tokenFruttaVerdura', data['content']['md5_tokenFruttaVerdura']);
    }

    if(data['content']['md5_tokenPiante'] != null){
      storage.setString('tokenPiante', data['content']['md5_tokenPiante']);
    }

    if(data['content']['md5_tokenNews'] != null){
      storage.setString('tokenNews', data['content']['md5_tokenNews']);
    }

    if(data['content']['md5_tokenSlides'] != null){
      storage.setString('tokenSlides', data['content']['md5_tokenSlides']);
    }

    if(data['content']['md5_tokenNotifiche'] != null){
      storage.setString('tokenNotifiche', data['content']['md5_tokenNotifiche']);
    }

    if(data['content']['md5_tokenPagine'] != null){
      storage.setString('tokenPagine', data['content']['md5_tokenPagine']);
    }

    if(data['content']['md5_tokenRicette'] != null){
      storage.setString('tokenRicette', data['content']['md5_tokenRicette']);
    }

    if(data['content']['md5_tokenPromozioni'] != null){
      storage.setString('tokenPromozioni', data['content']['md5_tokenPromozioni']);
    }

    if(data['content']['banner'] != 'undefined'){
      storage.setString('bannerList', jsonEncode(data.content['banner']));
    } else {
      storage.remove('bannerList');
    }

    var res = await Future.wait(futures).then((value){
      return true;
    }).catchError((e) {
      log("Got error: ${e.error}");
      print("Got error: ${e.error}");
      return false;
    }).whenComplete((){
      log('completed');
    });
    return res;
  }

  static List arrayChunk(List data, int chunkSize){
    var chunks = [];
    for (var i = 0; i < data.length; i += chunkSize) {
      chunks.add(data.sublist(i, i+chunkSize > data.length ? data.length : i + chunkSize));
    }
    return chunks;
  }

}
