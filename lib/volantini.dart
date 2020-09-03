import 'dart:convert';
import 'dart:core';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:scelteperte/src/models/page_model.dart';
import 'package:scelteperte/volantini_webview.dart';

class Volantini extends StatefulWidget {
  @override
  _VolantiniState createState() => _VolantiniState();
}

// stores ExpansionPanel state information
class Item {
  Item({
    this.expandedValue,
    this.headerValue,
    this.isExpanded = false,
    this.key,
  });

  String expandedValue;
  String headerValue;
  String key;
  bool isExpanded;
}

List<Item> generateItems(List<String> data) {
  return List.generate(data.length, (int index) {
    return Item(
        headerValue: data[index].toUpperCase(),
        expandedValue: data[index].toUpperCase(),
        key: data[index]);
  });
}

/// This Widget is the main application widget.
class _VolantiniState extends State<Volantini> {
  List<Item> _regioni;
  Map _jsonData;
  Future<bool> volantinoReady;

  @override
  initState() {
    super.initState();
    volantinoReady = Pagina().getPageVolantino().then((value) {
      _jsonData = jsonDecode(value.jsonData);
      List regions = _jsonData.keys.where((element) {
        for (String e in ['umbria', 'lazio', 'campania', 'calabria']) {
          if (e == element) return true;
        }
        return false;
      }).toList();
      _regioni = generateItems(regions);
      return true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Volantini Conad"), backgroundColor: Colors.green),
        body: Wrap(children: [
          FutureBuilder(
            future: volantinoReady,
            builder: (context, AsyncSnapshot<bool> volantino) {
              if (volantino.hasData && volantino.data) {
                return Container(
                  child: _buildPanel(),
                );
              } else {
                return CircularProgressIndicator(
                  backgroundColor: Colors.green,
                );
              }
            },
          ),
        ]));
  }

  CupertinoActionSheet _showActionSheet(List items, String region){
    List<CupertinoActionSheetAction> menu = [];
    items.forEach((element){
      menu.add(
          CupertinoActionSheetAction(
            child: Text(element),
            onPressed: () {
              Navigator.pop(context, '🙋 Ok!');
              Navigator.pushNamed(context, '/volantini/webview', arguments: VolantinoWebViewArgs(url: 'https://promozioni.gustourconad.it/'+region+'/'+element,));
            },
          )
      );
    });
    return CupertinoActionSheet(
        title: const Text('Scegli il punto vendita'),
        message: const Text('Consulta il volantino Spazio Conad di'),
        actions: menu,
        cancelButton: CupertinoActionSheetAction(
          child: const Text('Annulla'),
          isDefaultAction: true,
          onPressed: () {
            Navigator.pop(context, 'Cancel');
          },
        ));
  }

  Widget _buildPanel() {
    return ExpansionPanelList.radio(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _regioni[index].isExpanded = !isExpanded;
        });
      },
      children: _regioni.map<ExpansionPanelRadio>((Item item) {
        return ExpansionPanelRadio(
          value: item.key,
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text(item.headerValue),
            );
          },
          body: ListView.builder(
            padding: EdgeInsets.zero,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: _jsonData[item.key].length,
            itemBuilder: (context, index) {
              String key = _jsonData[item.key].keys.elementAt(index);
              return (key == 'ipermercato') ?
              ListTile(
                title:  Text(key.toString().toUpperCase()),
                trailing: Icon(Icons.chevron_right),
                dense: true,
                onTap: () {
                  containerForSheet<String>(
                    context: context,
                    child: _showActionSheet(_jsonData[item.key][key].keys.toList(), key)
                  );
                }
              )
              :
              ListTile(
                title: Text(key.toString().toUpperCase()),
                trailing: Icon(Icons.chevron_right),
                dense: true,
                onTap: () {
                  Navigator.pushNamed(context, '/volantini/webview', arguments: VolantinoWebViewArgs(url: 'https://promozioni.gustourconad.it/'+item.key,));
                },
              );
            },
          ),
        );
      }).toList(),
    );
  }

  void containerForSheet<T>({BuildContext context, Widget child}) {
    showCupertinoModalPopup<T>(
      context: context,
      builder: (BuildContext context) => child,
    )/*.then<void>((T value) {
      Scaffold.of(context).showSnackBar(new SnackBar(
        content: new Text('You clicked $value'),
        duration: Duration(milliseconds: 800),
      ));
    })*/;
  }
}
