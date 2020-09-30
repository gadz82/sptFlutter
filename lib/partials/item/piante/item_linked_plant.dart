import 'package:flutter/material.dart';
import 'package:scelteperte/plants_item.dart';
import 'package:scelteperte/src/models/plant_model.dart';
import 'package:scelteperte/src/utils.dart';
import 'package:transparent_image/transparent_image.dart';

class ItemLinkedPlant extends StatelessWidget {

  @required final List<Plant> relatedPlants;

  ItemLinkedPlant({this.relatedPlants});

  @override
  Widget build(BuildContext context) {
    return Wrap(
          children: [
            for(Plant relatedPlant in relatedPlants)
              RaisedButton(
                  textColor: Colors.black,
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 10.00),
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PlantsItem(postId: relatedPlant.postId, appBarTitle: relatedPlant.title))),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                    leading: ClipRRect(
                        borderRadius: BorderRadius.circular(25.0),
                        child: FadeInImage.memoryNetwork(
                            placeholder: kTransparentImage,
                            image: relatedPlant.thumb,
                            fit: BoxFit.cover,
                            height: 50,
                            width: 50
                        )
                    ),
                    title: Text(relatedPlant.title),
                    subtitle: Text(
                        Utils().parseHtmlString(relatedPlant.description).substring(0,35)+"...",
                        style: TextStyle(fontSize: 12.00)
                    ),
                    trailing: Icon(Icons.chevron_right),
                  )
              )
          ],
    );
  }
}
