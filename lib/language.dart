import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scelteperte/partials/bottom_banner.dart';
import 'package:scelteperte/plants_item.dart';
import 'package:scelteperte/src/models/page_model.dart';

class Language extends StatefulWidget {
  @override
  _LanguageState createState() => _LanguageState();
}

class _LanguageState extends State<Language> {

  TextEditingController searchStringController = TextEditingController();

  Future<bool> listReady;
  List<dynamic> results;
  List<dynamic> matches;

  Future pagina;

  _filterResults(String string){

    List _matches = [];
    if (string.isEmpty) {
      setState(() {
        matches = results;
      });
    }

    this.results.forEach((entry) {
      if (entry['titolo'].toLowerCase().contains(string.toLowerCase()) || entry['descrizione'].toLowerCase().contains(string.toLowerCase()))
        _matches.add(entry);
    });

    setState(() {
      matches = _matches;
    });
  }

  @override
  initState() {
    super.initState();
    this.listReady = Pagina().getPage('linguaggio-dei-fiori').then((v){
        setState(() {
          this.matches = this.results = jsonDecode(v.jsonData);
        });
        return true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Significato dei Fiori"),
            backgroundColor: Colors.green
        ),
        bottomNavigationBar: BottomBanner(),
        body: Container(
          child: FutureBuilder(
            future: listReady,
            builder: (context, snapshot) {
              if (snapshot.hasData) {

                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'Ricerca per nome',
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          labelStyle: TextStyle(color: Colors.grey),
                          suffixIcon: IconButton(
                            onPressed: (){
                              setState(() {
                                searchStringController.clear();
                              });
                            },
                            icon: Icon(Icons.clear, color: Colors.black),
                            iconSize: searchStringController.text.length > 0 ? 15.00 : 0.00,
                            padding: EdgeInsets.only(top: 20.00),
                          ),
                        ),
                        onChanged: _filterResults
                      ),
                    ),
                    Expanded(
                      child: ListView(
                          shrinkWrap: true,
                          children:[
                            for(Map entry in this.matches)
                              ListTile(
                                  onTap: entry['postId'].length > 0 ? (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => PlantsItem(postId: int.parse(entry['postId']), appBarTitle: entry['titolo'])));
                                  } : null,
                                  title: Text(entry['titolo']),
                                  subtitle: Text(entry['descrizione']),
                                  trailing: entry['postId'].length > 0 ? Icon(Icons.keyboard_arrow_right) : null,
                              )
                          ]
                      )
                    )
                  ],
                );
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
