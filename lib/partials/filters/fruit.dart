import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:scelteperte/src/filters/fruit_filters.dart';
import 'package:scelteperte/src/models/fruit_model.dart';

class FruitFilterMenu extends StatefulWidget {

  @override
  _FruitFilterMenuState createState() => _FruitFilterMenuState();
}

class _FruitFilterMenuState extends State<FruitFilterMenu> {

  final searchStringController = TextEditingController(text: FruitFilters().filtroNome);

  Future<bool> filtersReady;

  FruitFilters filterObject;

  List<DropdownMenuItem> origineValues = [];
  List<DropdownMenuItem> tipologiaValues = [];
  List<DropdownMenuItem> stagioneValues = [];

  final _formKey = GlobalKey<FormState>();

  @override
  initState() {
    super.initState();
    this.filtersReady = this.getFilters();
  }
  
  Future<bool> getFilters() async {
    Fruit().getFilters().then((value){
      List<DropdownMenuItem> _origineValues = [];
      List<DropdownMenuItem> _stagioneValues = [];
      List<DropdownMenuItem> _tipologiaValues = [];

      value[0]['origine'].toString().split(',').forEach((element) {
        if(element != ''){
          _origineValues.add(DropdownMenuItem(
              value: element.toLowerCase(),
              child: Text(element.toUpperCase())
          ));
        }
      });

      value[0]['stagione'].toString().split(',').forEach((element) {
        if(element != ''){
          _stagioneValues.add(DropdownMenuItem(
              value: element.toLowerCase(),
              child: Text(element.toUpperCase())
          ));
        }
      });

      value[0]['tipologia'].toString().split(',').forEach((element) {
        if(element != ''){
          _tipologiaValues.add(DropdownMenuItem(
              value: element.toLowerCase(),
              child: Text(element.toUpperCase())
          ));
        }
      });
      log(value[0].toString());
      setState(() {
        origineValues = _origineValues;
        stagioneValues = _stagioneValues;
        tipologiaValues = _tipologiaValues;
      });
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text("Filtra Frutte e Verdura"),
        backgroundColor: Colors.green

      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                    autofocus: false,
                    decoration: InputDecoration(
                        labelText: 'Nome Frutta e Verdura'
                    ),
                    controller: searchStringController
                ),
                DropdownButtonFormField(
                  decoration: InputDecoration(
                      labelText: 'Ordinamento'
                  ),
                  value: FruitFilters().filtroOrdinamento,
                  items: [
                    DropdownMenuItem(
                      value: 'recenti',
                      child: Text('Più recenti')
                    ),
                    DropdownMenuItem(
                        value: 'no-recenti',
                        child: Text('Meno recenti')
                    ),
                    DropdownMenuItem(
                        value: 'alfabetico-az',
                        child: Text('Alfabetico A-Z')
                    ),
                    DropdownMenuItem(
                        value: 'alfabetico-za',
                        child: Text('Alfabetico Z-A')
                    )
                  ],
                  onChanged: (value) {},
                ),
                DropdownButtonFormField(
                    decoration: InputDecoration(
                        labelText: 'Origine'
                    ),
                    value: FruitFilters().filtroOrigine,
                    items: origineValues,
                    onChanged: (value) {}
                ),
                DropdownButtonFormField(
                    decoration: InputDecoration(
                        labelText: 'Stagione'
                    ),
                    value: FruitFilters().filtroStagione,
                    items: stagioneValues,
                    onChanged: (value) {}
                ),
                DropdownButtonFormField(
                    decoration: InputDecoration(
                        labelText: 'Tipologia'
                    ),
                    value: FruitFilters().filtroTipologia,
                    items: tipologiaValues,
                    onChanged: (value) {}
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: RaisedButton(
                    onPressed: () {
                      // Validate returns true if the form is valid, or false
                      // otherwise.
                      if (_formKey.currentState.validate()) {
                        // If the form is valid, display a Snackbar.
                        Scaffold.of(context)
                            .showSnackBar(SnackBar(content: Text('Processing Data')));
                      }
                    },
                    child: Text('Submit'),
                  ),
                ),
              ],
            ),
          )
      )
    );
  }
}
