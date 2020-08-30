import 'package:flash_card/model/deck.dart';
import 'package:flutter/material.dart';

class DeckPlayPage extends StatefulWidget {
  final Deck deck;

  DeckPlayPage({this.deck});

  @override
  _DeckPlayPageState createState() => _DeckPlayPageState();
}

class _DeckPlayPageState extends State<DeckPlayPage> {
  final pageController = PageController();
  final secondaryPageController = PageController(initialPage: 0);
  String progress;

  @override
  void initState() {
    pageController.addListener(() {
      var val = 24 * pageController.page;
      secondaryPageController.jumpTo(val);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Container(
              height: 24,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Container(
                      height: 24,
                      child: Center(
                        child: PageView(
                          scrollDirection: Axis.vertical,
                          controller: secondaryPageController,
                          pageSnapping: false,
                          children:
                              List.generate(widget.deck.cards.length, (index) {
                            return Container(
                              height: 24,
                              child: Text('${index + 1}'),
                            );
                          }),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    '${widget.deck.cards.length}',
                    style: TextStyle(color: Colors.white60),
                  ),
                ],
              )),
          elevation: 0),
      backgroundColor: Colors.black,
      body: PageView(
        scrollDirection: Axis.vertical,
        controller: pageController,
        children: widget.deck.cards
            .map((e) => Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            e.title,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w800),
                          ),
                        ),
                        flex: 1,
                      ),
                      Padding(
                        child: Divider(
                          color: Colors.white60,
                          height: 0,
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 24),
                      ),
                      Expanded(
                        child: Center(
                            child: Padding(
                          child: Text(
                            e.content,
                            style: TextStyle(color: Colors.white, fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 24),
                        )),
                        flex: 1,
                      )
                    ],
                  )),
                ))
            .toList(),
      ),
    );
  }
}
