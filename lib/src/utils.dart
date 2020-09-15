import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Utils {

  String parseHtmlString(String htmlString) {
    RegExp exp = RegExp(
        r"<[^>]*>",
        multiLine: true,
        caseSensitive: true
    );
    return htmlString.replaceAll(exp, '');
  }

  void launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  showSnackBar(BuildContext context, String text){
    return Scaffold.of(context).showSnackBar(SnackBar(content: Text(text),));
  }

}