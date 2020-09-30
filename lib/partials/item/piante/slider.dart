import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:scelteperte/src/models/plant_image.dart';
import 'package:transparent_image/transparent_image.dart';

class SliderPlants extends StatelessWidget {

  final List<PlantImage> slides;

  SliderPlants({this.slides});

  @override
  Widget build(BuildContext context) {
    /*slides.forEach((element) {
      precacheImage(new NetworkImage(element.src), context);
    });*/
    return Wrap(children: [
      Container(
          alignment: Alignment.topCenter,
          child: CarouselSlider.builder(
            itemCount: slides.length,
            options: CarouselOptions(
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 4),
            aspectRatio: 1.40,
            viewportFraction: 1.0,
            enlargeCenterPage: false),
            itemBuilder: (context, index) {
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Stack(
                      alignment: Alignment.bottomLeft,
                      children: [
                        FadeInImage.memoryNetwork(
                          placeholder: kTransparentImage,
                          image: slides[index].src,
                          fit: BoxFit.cover,
                          height: MediaQuery.of(context).orientation == Orientation.portrait ? MediaQuery.of(context).size.height * 0.40 : MediaQuery.of(context).size.height,
                          width: 1000,
                        ),
                        Container(
                          height: 25,
                          width: 1000,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              gradient: LinearGradient(
                                  begin: Alignment.centerRight,
                                  end: Alignment.centerLeft,
                                  colors: [
                                    Colors.transparent,
                                    Colors.green,
                                  ],
                                  stops: [
                                    0.0,
                                    1.0
                                  ])),
                          child: Padding(
                              padding: EdgeInsets.all(5),
                              child: Text(slides[index].title, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color:Colors.white), textAlign: TextAlign.left)
                          ),
                        )
                      ],
                    )
                  ]
              );
            },
          )),
    ]);
  }
}