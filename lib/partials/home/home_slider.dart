import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:scelteperte/src/models/slide_model.dart';
import 'package:scelteperte/src/utils.dart';
import 'package:transparent_image/transparent_image.dart';

class SliderHome extends StatelessWidget {

  final List<Slide> slides;

  SliderHome({this.slides});

  void slideInteraction(BuildContext context, Slide slide){
    log(slide.toString());
    if(slide.navTo != null && slide.navTo != ''){
      try{
        String namedRoute = slide.navTo.replaceAll('#/app', '');
        Navigator.pushNamed(context, namedRoute);
        return;
      } catch (err){}
    }
    if(slide.navLink != null && slide.navLink != ''){
      Utils().launchURL(slide.navLink);
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    slides.forEach((element) {
      precacheImage(new NetworkImage(element.image), context);
    });
    return Wrap(children: [
      Container(
          alignment: Alignment.topCenter,
          child: CarouselSlider.builder(
            itemCount: slides.length,
            options: CarouselOptions(
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 4),
            aspectRatio: 2.5,
            viewportFraction: 1.0,
            enlargeCenterPage: false),
            itemBuilder: (context, index) {
              return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      child: FadeInImage.memoryNetwork(
                          placeholder: kTransparentImage,
                          image: slides[index].image,
                          fit: BoxFit.cover,
                          height: MediaQuery.of(context).orientation == Orientation.portrait ?
                            MediaQuery.of(context).size.height * (Utils().getDeviceType() == 'phone' ? 0.18 : 0.26) :
                            MediaQuery.of(context).size.height * (Utils().getDeviceType() == 'phone' ? 0.65 : 0.45),
                          width: 2000,
                      ),
                      onTap: () => slideInteraction(context, slides[index]),
                    )
                  ]
              );
            },
          )),
    ]);
  }
}