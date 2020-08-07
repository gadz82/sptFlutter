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
            return popDb(data);
          });
        } else {
          return popDb(data);
        }
      }

      return true;
    } else {
      throw Exception('Failed to load data');
    }
  }

  static bool popDb(dynamic data) {

    return true;
  }

  static List arrayChunk(List data, int chunkSize){
    var chunks = [];
    for (var i = 0; i < data.length; i += chunkSize) {
      chunks.add(data.sublist(i, i+chunkSize > data.length ? data.length : i + chunkSize));
    }
    return chunks;
  }

}
