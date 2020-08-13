import 'package:flutter/material.dart';

class SptDrawer extends StatefulWidget {
  @override
  _SptDrawerState createState() => _SptDrawerState();
}

class _SptDrawerState extends State<SptDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child:ListView(
        padding: EdgeInsets.zero,
        children: ListTile.divideTiles(
            context: context,
            tiles: [
              DrawerHeader(
                padding: EdgeInsets.only(top: 25.00),
                margin: EdgeInsets.only(bottom: 0.00),
                child: Container(
                    padding: EdgeInsets.only(bottom: 25.00),
                    child:  FittedBox(
                      child: Image.asset('images/logo.png'),
                      fit: BoxFit.fitHeight
                    )
                ),
                decoration: BoxDecoration(
                  color: Colors.green
                ),
              ),
              ListTile(
                title: Text('Home'),
                dense: true,
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Piante e Fiori'),
                dense: true,
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Frutta e Verdura'),
                dense: true,
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Ricette'),
                dense: true,
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Offerte Conad'),
                dense: true,
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Consigli e Curiosità'),
                dense: true,
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Significato dei Fiori'),
                dense: true,
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Oroscopo'),
                dense: true,
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Fiere ed Eventi'),
                dense: true,
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Giardini e Orti Botanici'),
                dense: true,
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Sconti Esclusivi'),
                dense: true,
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Instagram'),
                dense: true,
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Facebook'),
                dense: true,
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Contattaci'),
                dense: true,
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
            ]
        ).toList(),
      )

      /*ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[


        ],
      ),*/
    );
  }
}