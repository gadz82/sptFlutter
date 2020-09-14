import 'dart:collection';
import 'dart:convert';
import 'dart:developer';

import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:scelteperte/partials/bottom_banner.dart';
import 'package:scelteperte/src/models/page_model.dart';
import 'package:scelteperte/src/utils.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:url_launcher/url_launcher.dart';

class Gardens extends StatefulWidget {
  @override
  _GardensState createState() => _GardensState();
}

class _GardensState extends State<Gardens> {

  Future pagina;

  dynamic currentRegion;
  String currentRegionName;

  @override
  initState() {
    super.initState();
    this.pagina = Pagina().getPage('giardini-orti-botanici');
  }

  Widget _buildRegionList(Pagina data){

    dynamic regions = jsonDecode(data.jsonData);
    log(regions.toString());
    return Container(

      child: ListView(
        children: [
          
          for(String reg in regions.keys)
            ListTile(
                title: Text(reg),
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: (){

                  setState(() {
                    currentRegion = regions[reg];
                    currentRegionName = reg;
                  });
                  Navigator.push(context, MaterialPageRoute(builder: (context) => _buildGiardiniList()));
                }
            )
        ],
      ),
    );
  }

  Widget _buildGiardiniList(){
    return Scaffold(
        appBar: AppBar(
            title: Text(currentRegionName),
            backgroundColor: Colors.green
        ),
        bottomNavigationBar: BottomBanner(),
        body: Container(
            child: ListView(
              children: [
                for(dynamic garden in currentRegion)
                  Card(
                      margin: EdgeInsets.all(15),
                      child: Wrap(
                          children: [
                            Container(
                              padding:EdgeInsets.symmetric(horizontal:10, vertical: 5),
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children:[
                                    Expanded(
                                        child: Container(
                                            padding: EdgeInsets.all(10.00),
                                            child : Wrap(
                                                children: [
                                                  Text(garden['titolo'],style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color:Colors.green), textAlign: TextAlign.left),
                                                ]
                                            )
                                        )
                                    ),
                                  ]
                              ),
                            ),
                            Container(
                              padding:EdgeInsets.symmetric(horizontal:15, vertical: 5),
                              height: 200,
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children:[
                                    Expanded(
                                      child: FadeInImage.memoryNetwork(
                                          placeholder: kTransparentImage,
                                          image: garden['immagine'],
                                          fit: BoxFit.fitWidth
                                      ),
                                    ),

                                  ]
                              ),
                            ),
                            Divider(),
                            Container(
                              padding:EdgeInsets.symmetric(horizontal:10, vertical: 5),
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children:[
                                    Expanded(
                                        child: Container(
                                            padding: EdgeInsets.all(10.00),
                                            child : Wrap(
                                                children: [
                                                  Text(garden['indirizzo'],style: TextStyle(fontSize: 14), textAlign: TextAlign.left),
                                                ]
                                            )
                                        )
                                    ),
                                  ]
                              ),
                            ),
                            if(garden['telefono'] != '')
                              Container(
                                  padding:EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                                  width: 1000,
                                  child: RaisedButton.icon(
                                    icon: Icon(Icons.phone),
                                    textColor: Colors.white,
                                    color: Colors.lightGreen,
                                    label: Text(garden['telefono']),
                                    onPressed: () {
                                      Utils().launchURL("tel:${garden['telefono']}");
                                    },
                                  )
                              ),

                            if(garden['cellulare'] != '')
                              Container(
                                  padding:EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                                  width: 1000,
                                  child: RaisedButton.icon(
                                    icon: Icon(Icons.mobile_screen_share),
                                    textColor: Colors.white,
                                    color: Colors.lightGreen,
                                    label: Text(garden['cellulare']),
                                    onPressed: () {
                                      Utils().launchURL("tel:${garden['cellulare']}");
                                    },
                                  )
                              ),

                            if(garden['sito'] != '')
                              Container(
                                  padding:EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                                  width: 1000,
                                  child: RaisedButton.icon(
                                    icon: Icon(Icons.language),
                                    textColor: Colors.white,
                                    color: Colors.lightGreen,
                                    label: const Text('Sito Web'),
                                    onPressed: () {
                                      Utils().launchURL(garden['sito']);
                                    },
                                  )
                              ),

                            if(garden['lat'] != '' && garden['lng'] != '')
                              Container(
                                  padding:EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                                  width: 1000,
                                  child: RaisedButton.icon(
                                    icon: Icon(Icons.map),
                                    textColor: Colors.white,
                                    color: Colors.lightGreen,
                                    label: const Text('Indicazioni Stradali'),
                                    onPressed: () {
                                      final url = 'https://www.google.com/maps/search/?api=1&query=${garden['lat']},${garden['lng']}';
                                      Utils().launchURL(url);
                                    },
                                  )
                              )


                          ])
                  )
              ],
            )
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Fiere ed Eventi"),
            backgroundColor: Colors.green
        ),
        body: Container(
          child: FutureBuilder(
            future: pagina,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return _buildRegionList(snapshot.data);
              } else {
                return Container(
                    child: Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.green,
                        )
                    )
                );

              }
            },
          ),
        )
    );
  }
}
