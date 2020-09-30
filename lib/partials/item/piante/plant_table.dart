import 'package:flutter/material.dart';

class PlantTable extends StatelessWidget {

  @required final String ambiente;
  @required final String fioritura;
  @required final String tipologiaFoglie;
  @required final String tipoPianta;

  PlantTable({this.ambiente, this.fioritura, this.tipologiaFoglie, this.tipoPianta});

  @override
  Widget build(BuildContext context) {
    return Row( children: [
      Expanded(
        child: Table(
          children: [
            TableRow(
                children: [
                  Container(
                    height: 40,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                          bottom: BorderSide( //                   <--- left side
                            color: Color(0xff333333),
                            width: 0.5,
                          )
                      ),
                    ),
                    child: Wrap(
                      children: [
                        Icon(Icons.map, color: Colors.green, size: 22,),
                        Text(" Ambiente", style: TextStyle(fontSize: 17, color: Colors.black87))
                      ],
                    ),
                  ),
                  Container(
                    height: 40,
                    padding: EdgeInsets.only(right: 10),
                    alignment: Alignment.centerRight,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                          bottom: BorderSide( //                   <--- left side
                            color: Color(0xff333333),
                            width: 0.5,
                          )
                      ),
                    ),
                    child: Text(this.ambiente.toUpperCase(), style: TextStyle(color: Colors.black54)),
                  ),
                ]),
            TableRow(
                children: [
                  Container(
                    height: 40,
                    padding: EdgeInsets.only(left: 10),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                          bottom: BorderSide( //                   <--- left side
                            color: Color(0xff333333),
                            width: 0.5,
                          )
                      ),
                    ),
                    child: Wrap(
                      children: [
                        Icon(Icons.local_florist, color: Colors.green, size: 22,),
                        Text(" Fioritura", style: TextStyle(fontSize: 17, color: Colors.black87))
                      ],
                    ),
                  ),
                  Container(
                    height: 40,
                    padding: EdgeInsets.only(right: 10),
                    alignment: Alignment.centerRight,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                          bottom: BorderSide( //                   <--- left side
                            color: Color(0xff333333),
                            width: 0.5,
                          )
                      ),
                    ),
                    child: Text(this.fioritura.toUpperCase(), style: TextStyle(color: Colors.black54)),
                  ),
                ]),
              TableRow(
                children: [
                  Container(
                    height: 40,
                    padding: EdgeInsets.only(left: 10),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                          bottom: BorderSide( //                   <--- left side
                            color: Color(0xff333333),
                            width: 0.5,
                          )
                      ),
                    ),
                    child: Wrap(
                      children: [
                        Icon(Icons.nature, color: Colors.green, size: 22,),
                        Text(" Tipologia Foglie", style: TextStyle(fontSize: 17, color: Colors.black87))
                      ],
                    ),
                  ),
                  Container(
                    height: 40,
                    padding: EdgeInsets.only(right: 10),
                    alignment: Alignment.centerRight,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                          bottom: BorderSide( //                   <--- left side
                            color: Color(0xff333333),
                            width: 0.5,
                          )
                      ),
                    ),
                    child: Text(this.tipologiaFoglie.toUpperCase(), style: TextStyle(color: Colors.black54)),
                  ),
                ]),
            TableRow(
                children: [
                  Container(
                    height: 40,
                    padding: EdgeInsets.only(left: 10),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                          bottom: BorderSide( //                   <--- left side
                            color: Color(0xff333333),
                            width: 0.5,
                          )
                      ),
                    ),
                    child: Wrap(
                      children: [
                        Icon(Icons.ac_unit, color: Colors.green, size: 22,),
                        Text(" Tipo Pianta", style: TextStyle(fontSize: 17, color: Colors.black87))
                      ],
                    ),
                  ),
                  Container(
                    height: 40,
                    padding: EdgeInsets.only(right: 10),
                    alignment: Alignment.centerRight,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                          bottom: BorderSide( //                   <--- left side
                            color: Color(0xff333333),
                            width: 0.5,
                          )
                      ),
                    ),
                    child: Text(this.tipoPianta.toUpperCase(), style: TextStyle(color: Colors.black54)),
                  ),
                ]),
          ],

        ),
      ),

    ]);
  }
}
