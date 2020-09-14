import 'package:flutter/material.dart';

class RecipeTable extends StatelessWidget {

  @required String preparazione;
  @required String cottura;
  @required String porzioni;
  @required String difficolta;

  RecipeTable({this.preparazione, this.cottura, this.porzioni, this.difficolta});

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
                        Icon(Icons.access_time, color: Colors.green, size: 22,),
                        Text(" Preparazione", style: TextStyle(fontSize: 17, color: Colors.black87))
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
                    child: Text(this.preparazione.toUpperCase(), style: TextStyle(color: Colors.black54)),
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
                        Icon(Icons.av_timer, color: Colors.green, size: 22,),
                        Text(" Cottura", style: TextStyle(fontSize: 17, color: Colors.black87))
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
                    child: Text(this.cottura.toUpperCase(), style: TextStyle(color: Colors.black54)),
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
                        Icon(Icons.people, color: Colors.green, size: 22,),
                        Text(" Porzioni", style: TextStyle(fontSize: 17, color: Colors.black87))
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
                    child: Text(this.porzioni.toUpperCase(), style: TextStyle(color: Colors.black54)),
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
                        Icon(Icons.local_dining, color: Colors.green, size: 22,),
                        Text(" Difficoltà", style: TextStyle(fontSize: 17, color: Colors.black87))
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
                    child: Text(this.difficolta.toUpperCase(), style: TextStyle(color: Colors.black54)),
                  ),
                ]),
          ],

        ),
      ),

    ]);
  }
}
