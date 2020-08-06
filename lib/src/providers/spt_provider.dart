import 'dart:convert';
import 'package:http/http.dart' as http;

class SptProvider {

  SptProvider._();

  static Future<dynamic> fetchData() async {
    final response =  await http.get('http://www.scelteperte.it/sptrapi/initialize?mtoken=FNmZbp6nR7EEs7Eg&ts=');
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }
}
