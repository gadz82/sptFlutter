import 'package:flutter/material.dart';
import 'package:scelteperte/frutta_item.dart';
import 'package:scelteperte/src/models/fruit_model.dart';
import 'package:scelteperte/src/utils.dart';
import 'package:transparent_image/transparent_image.dart';

class ItemLinkedFruit extends StatelessWidget {

  @required List<Fruit> relatedFruits;

  ItemLinkedFruit({this.relatedFruits});

  @override
  Widget build(BuildContext context) {
    return Wrap(
          children: [
            for(Fruit relatedFruit in relatedFruits)
              RaisedButton(
                  textColor: Colors.black,
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 10.00),
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => FruitItem(postId: relatedFruit.postId, appBarTitle: relatedFruit.title))),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                    leading: ClipRRect(
                        borderRadius: BorderRadius.circular(25.0),
                        child: FadeInImage.memoryNetwork(
                            placeholder: kTransparentImage,
                            image: relatedFruit.thumb,
                            fit: BoxFit.cover,
                            height: 50,
                            width: 50
                        )
                    ),
                    title: Text(relatedFruit.title),
                    subtitle: Text(
                        Utils().parseHtmlString(relatedFruit.description).substring(0,30)+"...",
                        style: TextStyle(fontSize: 12.00)
                    ),
                    trailing: Icon(Icons.chevron_right),
                  )
              )
          ],
        );
  }
}
