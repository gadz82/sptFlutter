import 'dart:convert';
import 'dart:core';
import 'dart:developer';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:scelteperte/partials/bottom_banner.dart';
import 'package:scelteperte/src/models/page_model.dart';
import 'package:scelteperte/flyers_webview.dart';

class FlyersList extends StatefulWidget {
  @override
  _FlyersListState createState() => _FlyersListState();
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
class _FlyersListState extends State<FlyersList> {
  List<Item> _regioni;
  Map _jsonData;
  Future<bool> volantinoReady;

  @override
  initState() {
    super.initState();
    volantinoReady = Pagina().getPageVolantino().then((value) {
      _jsonData = jsonDecode(value.jsonData);
      List regions = _jsonData.keys.where((element) {
        for (String e in ['umbria', 'lazio', 'campania', 'calabria', 'sicilia']) {
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
        bottomNavigationBar: BottomBanner(),
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
              Navigator.of(context, rootNavigator: true).pop();
              log(element);
              log(region);
              Navigator.pushNamed(context, '/volantini/webview', arguments: VolantinoWebViewArgs(url: 'https://promozioni.gustourconad.it/appview/'+region+'/ipermercato/render/volantino?pdv='+element));
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
          isDefaultAction: false,
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
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
                      child: _showActionSheet(_jsonData[item.key][key].keys.toList(), item.key)
                    );
                  }
                )
              :
                ListTile(
                  title: Text(key.toString().toUpperCase()),
                  trailing: Icon(Icons.chevron_right),
                  dense: true,
                  onTap: () {
                    Navigator.pushNamed(context, '/volantini/webview', arguments: VolantinoWebViewArgs(url: 'https://promozioni.gustourconad.it/appview/'+item.key+'/'+key+'/render/volantino'));
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
