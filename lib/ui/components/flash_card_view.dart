import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class FlashCardView extends StatefulWidget {
  final Key key;
  final String title;
  final String content;

  FlashCardView({this.key, this.title, this.content});

  @override
  _FlashCardViewState createState() => _FlashCardViewState();
}

class _FlashCardViewState extends State<FlashCardView> {
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
                  top: 50,
                  left: 18,
                  right: 18,
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Divider(
                        height: 0,
                      ))),
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
