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
