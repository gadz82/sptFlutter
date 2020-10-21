import 'package:flutter/material.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:scelteperte/src/filters/recipe_filters.dart';
import 'package:scelteperte/src/models/recipe_model.dart';

class RecipesFilterMenu extends StatefulWidget {

  final RecipesFilters activeFilters;

  RecipesFilterMenu({this.activeFilters});

  @override
  _RecipesFilterMenuState createState() => _RecipesFilterMenuState();
}

class _RecipesFilterMenuState extends State<RecipesFilterMenu> {
  var searchStringController = TextEditingController();

  Future<bool> filtersReady;

  RecipesFilters filterSnapshot;
  RecipesFilters filterObject;

  List<dynamic> difficoltaValues = [];
  List<dynamic> tempoValues = [];
  List<dynamic> tipologiaPiattoValues = [];

  final _formKey = GlobalKey<FormState>();

  @override
  initState() {
    super.initState();
    this.filterObject = widget.activeFilters;
    this.filterSnapshot = RecipesFilters(
      filtroNome: filterObject.filtroNome,
      filtroOrdinamento: filterObject.filtroOrdinamento,
      filtroDifficolta: filterObject.filtroDifficolta,
      filtroTempo: filterObject.filtroTempo,
      filtroTipologiaPiatto: filterObject.filtroTipologiaPiatto
    );
    searchStringController.text = filterObject.filtroNome;
    this.filtersReady = this.getFilters();
  }

  Future<bool> getFilters() async {
    Recipe().getFilters().then((value) {
      List<dynamic> _difficoltaValues = [];
      List<dynamic> _tempoValues = [];
      List<dynamic> _tipologiaPiattoValues = [];

      value[0]['tipologia_piatto'].toString().split(',').forEach((element) {
        if (element != '') {
          _tipologiaPiattoValues.add({
            "name": element.toUpperCase(),
            "value": element.toLowerCase()
          });
        }
      });

      value[0]['tempo'].toString().split(',').forEach((element) {
        if (element != '') {
          _tempoValues.add({
            "name": element.toUpperCase(),
            "value": element.toLowerCase()
          });
        }
      });

      value[0]['difficolta'].toString().split(',').forEach((element) {
        if (element != '') {
          _difficoltaValues.add({
            "name": element.toUpperCase(),
            "value": element.toLowerCase()
          });
        }
      });

      setState(() {
        tipologiaPiattoValues = _tipologiaPiattoValues;
        tempoValues = _tempoValues;
        difficoltaValues = _difficoltaValues;
      });
    });
    return true;
  }

  // get the text in the TextField and send it back to the FirstScreen
  void _sendDataBack(BuildContext context, RecipesFilters recipesFilters) {
    Navigator.pop(context, recipesFilters);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.close),
              onPressed: () => _sendDataBack(context, null),
            ),
            title: Text("Filtra Ricette"),
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
                            labelText: 'Titolo Ricetta',
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
                              iconSize: 15,
                              padding: EdgeInsets.only(top: 20.00),
                            ),
                          ),
                          controller: searchStringController,
                       ),
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
                          }
                      ),
                      MultiSelectFormField(
                        autovalidate: false,
                        title: new Text('Tipo Piatto'),
                        validator: (value) {
                          if (value == null || value.length == 0) {
                            return 'Seleziona la portata';
                          }
                          return null;
                        },
                        dataSource: tipologiaPiattoValues,
                        textField: 'name',
                        valueField: 'value',
                        okButtonLabel: 'OK',
                        cancelButtonLabel: 'ANNULLA',
                        hintWidget: new Text('Seleziona la portata'),
                        initialValue: filterObject.filtroTipologiaPiatto != null ? filterObject.filtroTipologiaPiatto.split(',') : null,
                        onSaved: (value) {
                          setState(() {
                            if(value != null){
                              filterObject.filtroTipologiaPiatto = value.length > 0 ? value.join(",") : null;
                            } else {
                              filterObject.filtroTipologiaPiatto = null;
                            }
                          });
                        }
                      ),
                      MultiSelectFormField(
                        autovalidate: false,
                        title: new Text('Tempo di preparazione'),
                        validator: (value) {
                          if (value == null || value.length == 0) {
                            return 'Seleziona uno o più valori';
                          }
                          return null;
                        },
                        dataSource: tempoValues,
                        textField: 'name',
                        valueField: 'value',
                        okButtonLabel: 'OK',
                        cancelButtonLabel: 'ANNULLA',
                        hintWidget: new Text('Seleziona uno o più valori'),
                        initialValue: filterObject.filtroTempo != null ? filterObject.filtroTempo.split(',') : null,
                        onSaved: (value) {
                          setState(() {
                            if(value != null){
                              filterObject.filtroTempo = value.length > 0 ? value.join(",") : null;
                            } else {
                              filterObject.filtroTempo = null;
                            }
                          });
                        },
                      ),
                      MultiSelectFormField(
                        autovalidate: false,
                        title: new Text('Difficoltà'),
                        validator: (value) {
                          if (value == null || value.length == 0) {
                            return 'Livello di difficoltà';
                          }
                          return null;
                        },
                        dataSource: difficoltaValues,
                        textField: 'name',
                        valueField: 'value',
                        okButtonLabel: 'OK',
                        cancelButtonLabel: 'ANNULLA',
                        hintWidget: new Text('Livello di difficoltà'),
                        initialValue: filterObject.filtroDifficolta != null ? filterObject.filtroDifficolta.split(',') : null,
                        onSaved: (value) {
                          setState(() {
                            if(value != null){
                              filterObject.filtroDifficolta = value.length > 0 ? value.join(",") : null;
                            } else {
                              filterObject.filtroDifficolta = null;
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
                                      filterObject.filtroNome = searchStringController.text;
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
