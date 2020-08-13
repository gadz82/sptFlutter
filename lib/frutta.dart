import 'package:flutter/material.dart';
import 'package:scelteperte/src/models/fruit_model.dart';
//Nav passing params
/*Navigator.of(context).push(MaterialPageRoute(builder: (context) => Fruits(activeFilters: FruitFilters(filtroNome: 'ciao'))))*/

class FruitFilters{
  String filtroNome;
  String filtroOrigine;
  String filtroTipologia;
  String filtroStagione;
  String filtroOrdinamento;

  FruitFilters({this.filtroNome, this.filtroOrigine, this.filtroTipologia, this.filtroStagione, this.filtroOrdinamento});
}

class Fruits extends StatefulWidget {

  FruitFilters activeFilters;

  Fruits({this.activeFilters});

  @override
  _FruitsState createState() => _FruitsState();
}

class _FruitsState extends State<Fruits> {

  Future<List<Fruit>> fruits;

  FruitFilters activeFilters;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.fruits = Fruit().getFruits(filter: widget.activeFilters);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Frutta e Verdura"), backgroundColor: Colors.green),
        body: Container(
          child: Text('miao')
        )
    );
  }
}
