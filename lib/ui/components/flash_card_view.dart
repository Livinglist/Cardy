import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class FlashCard extends StatefulWidget {
  final String title;
  final String content;

  FlashCard({this.title, this.content});

  @override
  _FlashCardState createState() => _FlashCardState();
}

class _FlashCardState extends State<FlashCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
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
                      widget.title,
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
                      widget.content,
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
        ));
  }
}
