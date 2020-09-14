import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class NavItem{
  String image;
  String asset;
  String title;
  String subTitle;
  String namedRoute;

  NavItem({this.image, this.title, this.subTitle, this.namedRoute, this.asset});
}

class HomeNavCard extends StatelessWidget {

  final List<NavItem> items;
  final int ts = DateTime.now().millisecondsSinceEpoch;

  HomeNavCard({this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(0.00),
        margin: EdgeInsets.only(top: 00),
        child: SizedBox(
            child: Card(
                clipBehavior: Clip.antiAlias,
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Wrap(
                          children: [
                            for(NavItem item in items)
                              Container(
                                  child: RaisedButton(
                                      textColor: Colors.black,
                                      color: Colors.white,
                                      padding: EdgeInsets.symmetric(horizontal: 10.00),
                                      onPressed: () {
                                        Navigator.pushNamed(context, item.namedRoute);
                                      },
                                      child: ListTile(
                                        contentPadding: EdgeInsets.all(0),
                                        leading: ClipRRect(
                                            borderRadius: BorderRadius.circular(25.0),
                                            child: item.image != null ? FadeInImage.memoryNetwork(
                                                placeholder: kTransparentImage,
                                                image: item.image,
                                                fit: BoxFit.cover,
                                                height: 50,
                                                width: 50
                                            ) : new Image.asset(item.asset)
                                        ),
                                        title: Text(item.title),
                                        subtitle: Text(
                                            item.subTitle,
                                            style: TextStyle(fontSize: 12.00)
                                        ),
                                        trailing: Icon(Icons.chevron_right),
                                      )
                                  )
                              )

                          ]
                      )
                    ]
                )
            )
        )
    );
  }
}
