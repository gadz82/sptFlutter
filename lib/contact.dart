import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:scelteperte/partials/bottom_banner.dart';
import 'package:scelteperte/src/utils.dart';

class Contact extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Contattaci'),
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
                    padding:EdgeInsets.symmetric(horizontal: 60.00, vertical: 20.00),
                    child: Image.asset(
                        'images/logo.png'
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 10),
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Html(
                              data:"<p>Scelte per Te è un progetto realizzato e promosso da <strong>Conad PAC 2000A</strong>.</p><p>Non esitare a contattarci per avere informazioni sul mondo Scelte per Te o se sei interessato ad avere visibilità all'interno di questa applicazione o del sito web scelteperte.it</p>"
                          ),
                        ),
                        RaisedButton(
                          onPressed: (){
                            Utils().launchURL('mailto:info@scelteperte.it?subject=Richiesta Informazioni - App Scelte per Te Natura');
                          },
                          color: Colors.green,
                          child: Wrap(
                            children: [
                              Icon(Icons.mail, color: Colors.white, size: 15,),
                              Text(' Contattaci', style: TextStyle(color: Colors.white))
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
}
