import 'package:flash_card/model/deck.dart';
import 'package:flutter/material.dart';

class DeckPlayPage extends StatefulWidget {
  final Deck deck;

  DeckPlayPage({this.deck});

  @override
  _DeckPlayPageState createState() => _DeckPlayPageState();
}

class _DeckPlayPageState extends State<DeckPlayPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0),
      backgroundColor: Colors.black,
      body: PageView(
        scrollDirection: Axis.vertical,
        children: widget.deck.cards
            .map((e) => Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        e.title,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w800),
                      ),
                      Text(
                        e.content,
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ],
                  )),
                ))
            .toList(),
      ),
    );
  }
}
