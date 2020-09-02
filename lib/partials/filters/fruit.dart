import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:scelteperte/frutta.dart';
import 'package:scelteperte/src/filters/fruit_filters.dart';
import 'package:scelteperte/src/models/fruit_model.dart';

class FruitFilterMenu extends StatefulWidget {

  FruitFilters activeFilters;

  FruitFilterMenu({this.activeFilters});

  @override
  _FruitFilterMenuState createState() => _FruitFilterMenuState();
}

class _FruitFilterMenuState extends State<FruitFilterMenu> {
  var searchStringController = TextEditingController();

  Future<bool> filtersReady;

  FruitFilters filterSnapshot;
  FruitFilters filterObject;

  List<DropdownMenuItem> origineValues = [];
  List<DropdownMenuItem> tipologiaValues = [];
  List<DropdownMenuItem> stagioneValues = [];

  final _formKey = GlobalKey<FormState>();

  @override
  initState() {
    super.initState();
    this.filterObject = widget.activeFilters;
    this.filterSnapshot = FruitFilters(
      filtroNome: filterObject.filtroNome,
      filtroStagione: filterObject.filtroStagione,
      filtroOrdinamento: filterObject.filtroOrdinamento,
      filtroOrigine: filterObject.filtroOrigine,
      filtroTipologia: filterObject.filtroTipologia
    );
    searchStringController.text = filterObject.filtroNome;
    this.filtersReady = this.getFilters();
  }

  Future<bool> getFilters() async {
    Fruit().getFilters().then((value) {
      List<DropdownMenuItem> _origineValues = [];
      List<DropdownMenuItem> _stagioneValues = [];
      List<DropdownMenuItem> _tipologiaValues = [];

      value[0]['origine'].toString().split(',').forEach((element) {
        if (element != '') {
          _origineValues.add(DropdownMenuItem(
              value: element.toLowerCase(),
              child: Text(element.toUpperCase())));
        }
      });

      value[0]['stagione'].toString().split(',').forEach((element) {
        if (element != '') {
          _stagioneValues.add(DropdownMenuItem(
              value: element.toLowerCase(),
              child: Text(element.toUpperCase())));
        }
      });

      value[0]['tipologia'].toString().split(',').forEach((element) {
        if (element != '') {
          _tipologiaValues.add(DropdownMenuItem(
              value: element.toLowerCase(),
              child: Text(element.toUpperCase())));
        }
      });
      setState(() {
        origineValues = _origineValues;
        stagioneValues = _stagioneValues;
        tipologiaValues = _tipologiaValues;
      });
    });
    return true;
  }

  // get the text in the TextField and send it back to the FirstScreen
  void _sendDataBack(BuildContext context, FruitFilters fruitFilters) {
    Navigator.pop(context, fruitFilters);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.close),
              onPressed: () => _sendDataBack(context, filterSnapshot),
            ),
            title: Text("Filtra Frutte e Verdura"),
            backgroundColor: Colors.green),
        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
                key: _formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextFormField(
                          autofocus: false,
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            labelText: 'Nome Frutta e Verdura',
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
                              onPressed: () => searchStringController.clear(),
                              icon: Icon(Icons.clear, color: Colors.black),
                              iconSize: 15.00,
                              padding: EdgeInsets.only(top: 20.00),
                            ),
                          ),
                          controller: searchStringController,
                          onChanged: (value) {
                            setState(() {
                              filterObject.filtroNome = value;
                              searchStringController.text = value;
                            });
                          }),
                      DropdownButtonFormField(
                          decoration: InputDecoration(labelText: 'Ordinamento'),
                          value: this.filterObject.filtroOrdinamento != null ? this.filterObject.filtroOrdinamento : 'recenti',
                          items: [
                            DropdownMenuItem(
                                value: 'recenti', child: Text('Più recenti')),
                            DropdownMenuItem(
                                value: 'no-recenti', child: Text('Meno recenti')),
                            DropdownMenuItem(
                                value: 'alfabetico-az',
                                child: Text('Alfabetico A-Z')),
                            DropdownMenuItem(
                                value: 'alfabetico-za',
                                child: Text('Alfabetico Z-A'))
                          ],
                          onChanged: (value) {
                            setState(() {
                              filterObject.filtroOrdinamento = value;
                            });
                          }),
                      DropdownButtonFormField(
                        decoration: InputDecoration(labelText: 'Origine'),
                        value: filterObject.filtroOrigine,
                        items: origineValues,
                        onChanged: (value) {
                          setState(() {
                            filterObject.filtroOrigine = value;
                          });
                        },
                      ),
                      DropdownButtonFormField(
                          decoration: InputDecoration(labelText: 'Stagione'),
                          value: filterObject.filtroStagione,
                          items: stagioneValues,
                          onChanged: (value) {
                            setState(() {
                              filterObject.filtroStagione = value;
                            });
                          }),
                      DropdownButtonFormField(
                          decoration: InputDecoration(labelText: 'Tipologia'),
                          value: filterObject.filtroTipologia,
                          items: tipologiaValues,
                          onChanged: (value) {
                            setState(() {
                              filterObject.filtroTipologia = value;
                            });
                          }),
                      Row(
                        children: [
                          Expanded(
                              flex: 2,
                              child: Padding(
                                  padding: EdgeInsets.only(right: 10.00, top: 10.00),
                                  child: RaisedButton(
                                    color: Colors.green,
                                    onPressed: () {
                                      _sendDataBack(context, filterObject);
                                    },
                                    child: Text('Applica Filtri', style: TextStyle(color: Colors.white)),
                                  )
                              )
                          ),
                          Expanded(
                              child: Padding(
                                  padding: EdgeInsets.only(top: 10.00),
                                  child: RaisedButton(
                                    color: Colors.redAccent,

                                    onPressed: () {
                                      // Validate returns true if the form is valid, or false
                                      // otherwise.
                                      setState(() {
                                        filterObject.filtroOrdinamento = null;
                                        filterObject.filtroTipologia = null;
                                        filterObject.filtroOrigine = null;
                                        filterObject.filtroStagione = null;
                                        searchStringController.text = '';
                                        filterObject.filtroNome = '';
                                      });
                                    },
                                    child: Wrap(children: [
                                      Icon(Icons.block, color: Colors.white, size: 16.00),
                                      Text(' Pulisci', style: TextStyle(color: Colors.white))
                                    ])
                                  )
                              )
                          )
                        ],
                      ),
                    ]
                )
            ),
          )
        )
    );
  }
}
