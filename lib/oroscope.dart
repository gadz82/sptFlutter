import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:scelteperte/partials/bottom_banner.dart';
import 'package:scelteperte/plants_item.dart';
import 'package:scelteperte/src/models/page_model.dart';
import 'package:scelteperte/src/utils.dart';

class Oroscope extends StatefulWidget {
  @override
  _OroscopeState createState() => _OroscopeState();
}

class _OroscopeState extends State<Oroscope> {

  Future pagina;

  Map currentSign;

  @override
  initState() {
    super.initState();
    this.pagina = Pagina().getPage('oroscopo-dei-fiori');
    log(this.pagina.toString());
  }

  Widget _buildOroscopoList(Pagina data){

    Map segni = jsonDecode(data.jsonData);
    log(segni[segni.keys.toList()[0]].toString());
    return Container(
      child: ListView(
        children: [
          for(String segno in segni.keys)
            ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage('images/segni/${segni[segno]['titolo'].toString().toLowerCase()}.png'),
                backgroundColor: Colors.transparent
              ),
              title: Text(segni[segno]['titolo']),
              subtitle : Text(segni[segno]['date']),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: (){
                setState(() {
                  currentSign = segni[segno];
                });
                Navigator.push(context, MaterialPageRoute(builder: (context) => _buildOroscopoDetail()));
              }
            )

        ],
      ),
    );
  }

  Widget _buildOroscopoDetail(){
    return Scaffold(
        appBar: AppBar(
            title: Text(this.currentSign['titolo']),
            backgroundColor: Colors.green
        ),
        bottomNavigationBar: BottomBanner(),
        body: ListView(
          children: [
            Card(
              margin: EdgeInsets.all(15.00),
              child: Wrap(
                children: [
                  Container(
                    margin: EdgeInsets.only(top:10),
                    alignment: Alignment.center,
                    child: Text(this.currentSign['titolo'], style: TextStyle(fontSize: 30),)
                  ),
                  Container(
                    padding: Utils().getDeviceType() == 'phone' ? EdgeInsets.symmetric(horizontal: 60.00, vertical: 20.00) : EdgeInsets.symmetric(horizontal: 250.00, vertical: 20.00),
                    alignment: Alignment.center,
                    child: Image.asset(
                      'images/segni/${this.currentSign['titolo'].toString().toLowerCase()}.png'
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 10),
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Wrap(
                          children: [
                            Text('Elemento: ', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(this.currentSign['elemento'])
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical:10.0),
                          child: Text(this.currentSign['date'])
                        ),
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Html(
                             data: this.currentSign['descrizione']
                          ),
                        ),
                        RaisedButton(
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => PlantsItem(postId: this.currentSign['post_id_collegato'], appBarTitle: this.currentSign['fiore_collegato'])));
                          },
                          color: Colors.green,
                          child: Wrap(
                           children: [
                             Text('SCHEDA ', style: TextStyle(color: Colors.white)),
                             Text(this.currentSign['fiore_collegato'].toString().toUpperCase(), style: TextStyle(color: Colors.white)),
                           ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Oroscopo dei Fiori"),
            backgroundColor: Colors.green
        ),
        bottomNavigationBar: BottomBanner(),
        body: Container(
            child: FutureBuilder(
              future: pagina,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return _buildOroscopoList(snapshot.data);
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
