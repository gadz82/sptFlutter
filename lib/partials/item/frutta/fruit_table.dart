import 'package:flutter/material.dart';

class FruitTable extends StatelessWidget {

  @required String origine;
  @required String stagione;

  FruitTable({this.origine, this.stagione});

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
                        Icon(Icons.language, color: Colors.green, size: 22,),
                        Text(" Origine", style: TextStyle(fontSize: 17, color: Colors.black87))
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
                    child: Text(this.origine.toUpperCase(), style: TextStyle(color: Colors.black54)),
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
                        Icon(Icons.calendar_today, color: Colors.green, size: 22,),
                        Text(" Stagione", style: TextStyle(fontSize: 17, color: Colors.black87))
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
                    child: Text(this.stagione.toUpperCase(), style: TextStyle(color: Colors.black54)),
                  ),
                ]),
          ],

        ),
      ),

    ]);
  }
}
