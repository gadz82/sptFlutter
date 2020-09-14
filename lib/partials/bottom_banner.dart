import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:scelteperte/src/providers/spt_provider.dart';
import 'package:scelteperte/src/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transparent_image/transparent_image.dart';

class BottomBanner extends StatefulWidget {
  @override
  _BottomBannerState createState() => _BottomBannerState();
}

class _BottomBannerState extends State<BottomBanner> {

  List<dynamic> bannerList;

  Future<bool> haveBanner;

  dynamic banner;

  @override
  void initState(){
    super.initState();
    SptProvider.localStorage.then((storage){
      if(storage.containsKey('bannerList')){
          bannerList = jsonDecode(storage.getString('bannerList'));
          bannerList.shuffle();
          banner = bannerList[0];
          haveBanner = Future.value(true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: haveBanner,
      builder: (context, AsyncSnapshot<bool> haveBanner) {
        if (haveBanner.hasData && haveBanner.data == true) {

          return Container(
            height: 45,
            margin:EdgeInsets.all(0),
            padding:EdgeInsets.all(0),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Colors.black54,
                    blurRadius: 7.5,
                    offset: Offset(0.0, 0.75)
                )
              ]
            ),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: InkWell(
                      child: FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage,
                        image: banner['banner_app'],
                        fit: BoxFit.fitWidth
                      ),
                      onTap: () => Utils().launchURL(banner['url_puntamento']),
                    )
                  )
                ]
            ),
          );
        } else {
          return Visibility(visible: false, child: Text(" "),);
        }
      });
    }
}
