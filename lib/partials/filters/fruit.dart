import 'package:flutter/material.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:scelteperte/src/filters/fruit_filters.dart';
import 'package:scelteperte/src/models/fruit_model.dart';

class FruitFilterMenu extends StatefulWidget {

  final FruitFilters activeFilters;

  FruitFilterMenu({this.activeFilters});

  @override
  _FruitFilterMenuState createState() => _FruitFilterMenuState();
}

class _FruitFilterMenuState extends State<FruitFilterMenu> {
  var searchStringController = TextEditingController();

  Future<bool> filtersReady;

  FruitFilters filterSnapshot;
  FruitFilters filterObject;

  List<dynamic> origineValues = [];
  List<dynamic> tipologiaValues = [];
  List<dynamic> stagioneValues = [];

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
      List<dynamic> _origineValues = [];
      List<dynamic> _stagioneValues = [];
      List<dynamic> _tipologiaValues = [];

      value[0]['origine'].toString().split(',').forEach((element) {
        if (element != '') {
          _origineValues.add({
            "name": element.toUpperCase(),
            "value": element.toLowerCase()
          });
        }
      });

      value[0]['stagione'].toString().split(',').forEach((element) {
        if (element != '') {
          _stagioneValues.add({
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
              onPressed: () => _sendDataBack(context, null),
            ),
            title: Text("Filtra Frutta e Verdura"),
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
                          }),
                      MultiSelectFormField(
                        autovalidate: false,
                        title: new Text('Origine'),
                        validator: (value) {
                          if (value == null || value.length == 0) {
                            return 'Filtra in base all\'origine';
                          }
                          return null;
                        },
                        dataSource: origineValues,
                        textField: 'name',
                        valueField: 'value',
                        okButtonLabel: 'OK',
                        cancelButtonLabel: 'ANNULLA',
                        hintWidget: new Text('Seleziona i valori'),
                        initialValue: filterObject.filtroOrigine != null ? filterObject.filtroOrigine.split(',') : null,
                        onSaved: (value) {
                          setState(() {
                            if(value != null){
                              filterObject.filtroOrigine = value.length > 0 ? value.join(",") : null;
                            } else {
                              filterObject.filtroOrigine = null;
                            }
                          });
                        }
                      ),
                      MultiSelectFormField(
                        autovalidate: false,
                        title: new Text('Stagione'),
                        validator: (value) {
                          if (value == null || value.length == 0) {
                            return 'Filtra in base alla stagione';
                          }
                          return null;
                        },
                        dataSource: stagioneValues,
                        textField: 'name',
                        valueField: 'value',
                        okButtonLabel: 'OK',
                        cancelButtonLabel: 'ANNULLA',
                        hintWidget: new Text('Seleziona la stagione'),
                        initialValue: filterObject.filtroStagione != null ? filterObject.filtroStagione.split(',') : null,
                        onSaved: (value) {
                          setState(() {
                            if(value != null){
                              filterObject.filtroStagione = value.length > 0 ? value.join(",") : null;
                            } else {
                              filterObject.filtroStagione = null;
                            }
                          });
                        },
                      ),
                      MultiSelectFormField(
                        autovalidate: false,
                        title: new Text('Tipologia'),
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
                        hintWidget: new Text('Seleziona i valori'),
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
