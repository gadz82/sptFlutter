import 'dart:convert';
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scelteperte/src/models/page_model.dart';
import 'package:scelteperte/src/utils.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:url_launcher/url_launcher.dart';

class Fairs extends StatefulWidget {
  @override
  _FairsState createState() => _FairsState();
}

class _FairsState extends State<Fairs> {

  Future pagina;

  dynamic currentMonth;
  String currentMonthName;

  @override
  initState() {
    super.initState();
    this.pagina = Pagina().getPage('fiere-ed-eventi');
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }


  Widget _buildCurrentMonthsList(Pagina data){

    dynamic months = jsonDecode(data.jsonData);

    return Container(

      child: ListView(
        children: [
          Container(
            height: 140,
            child:FittedBox(
                child: FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: "https://www.scelteperte.it/wp-content/uploads/2013/06/fiere-eventi-giardinaggio-scelte-per-te.jpg",
                ),
                fit: BoxFit.fitWidth
            )
          ),
          Card(
            margin: EdgeInsets.all(10),
            child: Container(
              padding: EdgeInsets.all(15),
              child: Text('Trova l\'evento o la fiera legata al mondo del giardinaggio e scopri i dettagli.', style: TextStyle(fontSize: 16),),
            )
          ),
          for(String month in months.keys)
            ListTile(
                title: Text(month),
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: (){

                  setState(() {
                    currentMonth = months[month];
                    currentMonthName = month;
                  });
                  Navigator.push(context, MaterialPageRoute(builder: (context) => _buildFiereList()));
                }
            )
        ],
      ),
    );
  }

  Widget _buildFiereList(){
    return Scaffold(
        appBar: AppBar(
            title: Text(currentMonthName),
            backgroundColor: Colors.green
        ),
        body: Container(
          child: ListView(
            children: [
              for(dynamic event in currentMonth)
                Card(
                  margin: EdgeInsets.all(10),
                  child: Wrap(
                    children: [
                      Container(
                        padding:EdgeInsets.all(15),
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:[
                              Expanded(
                                flex: 3,
                                child: FadeInImage.memoryNetwork(
                                    placeholder: kTransparentImage,
                                    image: event['immagine'],
                                    fit: BoxFit.fitWidth
                                ),
                              ),
                              Expanded(
                                  flex: 6,
                                  child: Container(
                                      padding: EdgeInsets.all(10.00),
                                      child : Wrap(
                                          children: [
                                            Text(event['titolo'],style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color:Colors.green), textAlign: TextAlign.left),
                                            Divider(),
                                            Container(
                                                width: 1000,
                                                child: Text(event['date_luogo'], style: TextStyle(fontSize: 14), textAlign: TextAlign.left)
                                            )
                                          ]
                                      )
                                  )
                              )
                            ]
                        ),
                      ),
                      Divider(),
                      Container(
                        padding:EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                        width: 1000,
                        child: Text(event['descrizione']),

                      ),
                      if(event['link'] != '')
                        Container(
                            padding:EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                            width: 1000,
                            child: RaisedButton.icon(
                              icon: Icon(Icons.language),
                              textColor: Colors.white,
                              color: Colors.lightGreen,
                              label: const Text('Sito Web'),
                              onPressed: () {
                                Utils().launchURL(event['link']);
                              },
                            )
                          ),


                      Container(
                          padding:EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                          width: 1000,
                          child: RaisedButton.icon(
                            icon: Icon(Icons.calendar_today),
                            textColor: Colors.white,
                            color: Colors.lightGreen,
                            label: const Text('Aggiungi al Calendario'),
                            onPressed: () {
                                                            
                              final Event e = Event(
                                  title: event['titolo'],
                                  description: event['descrizione']+" "+event['link'],
                                  location: event['date_luogo'],
                                  timeZone: 'GMT+2',
                                  startDate: DateTime.parse(event['data_inizio']),
                                  endDate: DateTime.parse(event['data_fine'])
                              );
                              Add2Calendar.addEvent2Cal(e);

                            },
                          )
                      ),

                      if(event['lat'] != '' && event['lng'] != '')
                      Container(
                          padding:EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                          width: 1000,
                          child: RaisedButton.icon(
                            icon: Icon(Icons.map),
                            textColor: Colors.white,
                            color: Colors.lightGreen,
                            label: const Text('Vedi su Mappa'),
                            onPressed: () {
                              final url = 'https://www.google.com/maps/search/?api=1&query=${event['lat']},${event['lng']}';
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
                return _buildCurrentMonthsList(snapshot.data);
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
