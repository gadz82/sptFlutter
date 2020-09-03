import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:scelteperte/src/filters/fruit_filters.dart';
import 'package:scelteperte/src/filters/plant_filters.dart';
import 'package:scelteperte/src/models/fruit_model.dart';
import 'package:scelteperte/src/models/plant_model.dart';

class PlantsFilterMenu extends StatefulWidget {

  PlantsFilters activeFilters;

  PlantsFilterMenu({this.activeFilters});

  @override
  _PlantsFilterMenuState createState() => _PlantsFilterMenuState();
}

class _PlantsFilterMenuState extends State<PlantsFilterMenu> {
  var searchStringController = TextEditingController();

  Future<bool> filtersReady;

  PlantsFilters filterSnapshot;
  PlantsFilters filterObject;

  List<dynamic> fogliaValues = [];
  List<dynamic> tipologiaValues = [];
  List<dynamic> tipologiaPiantaValues = [];
  List<dynamic> ambienteValues = [];
  List<dynamic> fiorituraValues = [];

  final _formKey = GlobalKey<FormState>();

  @override
  initState() {
    super.initState();
    this.filterObject = widget.activeFilters;
    this.filterSnapshot = PlantsFilters(
      filtroNome: filterObject.filtroNome,
      filtroOrdinamento: filterObject.filtroOrdinamento,
      filtroFoglia: filterObject.filtroFoglia,
      filtroTipologia: filterObject.filtroTipologia,
      filtroAmbiente: filterObject.filtroAmbiente,
      filtroFioritura: filterObject.filtroFioritura
    );
    searchStringController.text = filterObject.filtroNome;
    this.filtersReady = this.getFilters();
  }

  Future<bool> getFilters() async {
    Plant().getFilters().then((value) {
      List<dynamic> _fogliaValues = [];
      List<dynamic> _tipologiaValues = [];
      List<dynamic> _ambienteValues = [];
      List<dynamic> _fiorituraValues = [];
      log(value.toString());
      value[0]['foglia'].toString().split(',').forEach((element) {
        if (element != '') {
          _fogliaValues.add({
            "name": element.toUpperCase(),
            "value": element.toLowerCase()
          });
        }
      });

      value[0]['tipologia'].toString().split(',').forEach((element) {
        if (element != '') {
          _tipologiaValues.add({
            "name": element.toUpperCase(),
            "value": element.toLowerCase()
          });
        }
      });

      value[0]['ambiente'].toString().split(',').forEach((element) {
        if (element != '') {
          _ambienteValues.add({
            "name": element.toUpperCase(),
            "value": element.toLowerCase()
          });
        }
      });

      value[0]['fioritura'].toString().split(',').forEach((element) {
        if (element != '') {
          _fiorituraValues.add({
            "name": element.toUpperCase(),
            "value": element.toLowerCase()
          });
        }
      });
      setState(() {
        fogliaValues = _fogliaValues;
        ambienteValues = _ambienteValues;
        fiorituraValues = _fiorituraValues;
        tipologiaValues = _tipologiaValues;
      });
    });
    return true;
  }

  // get the text in the TextField and send it back to the FirstScreen
  void _sendDataBack(BuildContext context, PlantsFilters plantsFilters) {
    Navigator.pop(context, plantsFilters);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.close),
              onPressed: () => _sendDataBack(context, null),
            ),
            title: Text("Filtra Piante e Fiori"),
            backgroundColor: Colors.green
        ),
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
                            contentPadding: EdgeInsets.all(10.00),
                            labelText: 'Nome Pianta',
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
                                  filterObject.filtroNome = null;
                                });
                              },
                              icon: Icon(Icons.clear, color: Colors.black),
                              iconSize: searchStringController.text.length > 0 ? 15.00 : 0.00,
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
                          decoration: InputDecoration(labelText: 'Ordinamento',contentPadding: EdgeInsets.all(10.00)),
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
                      MultiSelectFormField(
                        autovalidate: false,
                        titleText: 'Ambiente',
                        validator: (value) {
                          if (value == null || value.length == 0) {
                            return 'Seleziona i valori';
                          }
                          return null;
                        },
                        dataSource: ambienteValues,
                        textField: 'name',
                        valueField: 'value',
                        okButtonLabel: 'OK',
                        cancelButtonLabel: 'ANNULLA',
                        hintText: 'Seleziona i valori',
                        initialValue: filterObject.filtroAmbiente != null ? filterObject.filtroAmbiente.split(',') : null,
                        onSaved: (value) {
                          setState(() {
                            if(value != null){
                              filterObject.filtroAmbiente = value.length > 0 ? value.join(",") : null;
                            } else {
                              filterObject.filtroAmbiente = null;
                            }
                          });
                        }
                      ),
                      MultiSelectFormField(
                        autovalidate: false,
                        titleText: 'Fioritura',
                        validator: (value) {
                          if (value == null || value.length == 0) {
                            return 'Stagione di fioritura';
                          }
                          return null;
                        },
                        dataSource: fiorituraValues,
                        textField: 'name',
                        valueField: 'value',
                        okButtonLabel: 'OK',
                        cancelButtonLabel: 'ANNULLA',
                        hintText: 'Stagione di fioritura',
                        initialValue: filterObject.filtroFioritura != null ? filterObject.filtroFioritura.split(',') : null,
                        onSaved: (value) {
                          setState(() {
                            if(value != null){
                              filterObject.filtroFioritura = value.length > 0 ? value.join(",") : null;
                            } else {
                              filterObject.filtroFioritura = null;
                            }
                          });
                        },
                      ),
                      MultiSelectFormField(
                        autovalidate: false,
                        titleText: 'Foglia',
                        validator: (value) {
                          if (value == null || value.length == 0) {
                            return 'Foglie caduche o sempreverdi';
                          }
                          return null;
                        },
                        dataSource: fogliaValues,
                        textField: 'name',
                        valueField: 'value',
                        okButtonLabel: 'OK',
                        cancelButtonLabel: 'ANNULLA',
                        hintText: 'Foglie caduche o sempreverdi',
                        initialValue: filterObject.filtroFoglia != null ? filterObject.filtroFoglia.split(',') : null,
                        onSaved: (value) {
                          setState(() {
                            if(value != null){
                              filterObject.filtroFoglia = value.length > 0 ? value.join(",") : null;
                            } else {
                              filterObject.filtroFoglia = null;
                            }
                          });
                        },
                      ),
                      MultiSelectFormField(
                        autovalidate: false,
                        titleText: 'Tipologia pianta',
                        validator: (value) {
                          if (value == null || value.length == 0) {
                            return 'Filtra in base alla tipologia';
                          }
                          return null;
                        },
                        dataSource: tipologiaValues,
                        textField: 'name',
                        valueField: 'value',
                        okButtonLabel: 'OK',
                        cancelButtonLabel: 'ANNULLA',
                        hintText: 'Seleziona i valori',
                        initialValue: filterObject.filtroTipologia != null ? filterObject.filtroTipologia.split(',') : null,
                        onSaved: (value) {
                          setState(() {
                            if(value != null){
                              filterObject.filtroTipologia = value.length > 0 ? value.join(",") : null;
                            } else {
                              filterObject.filtroTipologia = null;
                            }
                          });
                        },
                      ),
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
