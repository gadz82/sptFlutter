import 'package:flutter/material.dart';
import 'package:scelteperte/src/utils.dart';

class DownloadButton extends StatelessWidget {

  @required final String buttonTitle;
  @required final String url;

  DownloadButton({this.buttonTitle, this.url});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding:EdgeInsets.symmetric(horizontal: 15, vertical: 3),
        width: 1000,
        child: RaisedButton.icon(
          icon: Icon(Icons.cloud_download ),
          textColor: Colors.white,
          color: Colors.lightGreen,
          label: Text(buttonTitle),
          onPressed: () {
            Utils().launchURL(url);
          },
        )
    );
  }
}
