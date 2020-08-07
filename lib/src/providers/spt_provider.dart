import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';

class SptProvider {
  /// K/V local app storage
  static SharedPreferences _preferences;

  static final String baseUrl = "http://www.scelteperte.it/sptrapi/initialize?mtoken=FNmZbp6nR7EEs7Eg&ts=";

  SptProvider._();

  static Future<SharedPreferences> get localStorage async {
    if (_preferences != null) return _preferences;
    _preferences = await SharedPreferences.getInstance();
    return _preferences;
  }

  static Future<bool> fetchData() async {
    final storage = await localStorage;

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
      //return jsonDecode(response.body);
      log('ready');
      return true;
    } else {
      throw Exception('Failed to load data');
    }
  }
}
