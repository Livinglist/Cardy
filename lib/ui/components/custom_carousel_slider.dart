import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:flash_card/model/flash_card.dart';

class CustomCarouselSlider extends StatelessWidget {
  final List<FlashCard> cards;
  final ValueChanged<int> onPageChanged;

  CustomCarouselSlider({this.cards, this.onPageChanged}) {
    onPageChanged(0);
  }

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        autoPlay: false,
        aspectRatio: 1.5,
        enlargeCenterPage: false,
        height: 240,
        onPageChanged: (index, _) {
          onPageChanged(index);
        },
      ),
      items: [
        ...cards.map((e) => Padding(
              child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(0))),
                  child: Container(
                    child: Stack(
                      children: [
                        Positioned(
                            top: 18,
                            left: 18,
                            right: 18,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: AutoSizeText(
                                e.title,
                                maxLines: 1,
                                maxFontSize: 48,
                                minFontSize: 18,
                                style: TextStyle(fontWeight: FontWeight.w800),
                              ),
                            )),
                        Positioned(
                            top: 64,
                            left: 18,
                            right: 18,
                            child: Container(
                              child: AutoSizeText(
                                e.content,
                                maxLines: 6,
                                maxFontSize: 24,
                                minFontSize: 18,
                                style: TextStyle(fontWeight: FontWeight.normal),
                              ),
                            )),
                      ],
                    ),
                    height: 240,
                    width: double.infinity,
                  )),
              padding: EdgeInsets.all(0),
            ))
      ],
    );
  }
}
