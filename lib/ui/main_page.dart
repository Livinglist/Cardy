import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flash_card/bloc/deck_bloc.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final chipMap = {};
  final categories = [
    'English',
    'N2 Kanji',
    'GRE Vocabulary',
  ];

  @override
  void initState() {
    DeckBloc.instance.getAllDecks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          StreamBuilder(
            stream: DeckBloc.instance.deck,
            builder: (_, AsyncSnapshot<Deck> snapshot) {
              if (snapshot.hasData) {
                return CustomCarouselSlider(cards: snapshot.data.cards);
              }

              return Center(
                child: Text('No Deck Selected'),
              );
            },
          ),
          Padding(
            child: RaisedButton(
              child: Icon(Icons.add),
              onPressed: onAddCardPressed,
              shape: StadiumBorder(),
            ),
            padding: EdgeInsets.all(12),
          ),
          Spacer(),
          Container(
              width: double.infinity,
              child: Padding(
                child: StreamBuilder(
                  stream: DeckBloc.instance.decks,
                  builder: (_, AsyncSnapshot<List<Deck>> snapshot) {
                    if (snapshot.hasData) {
                      var decks = snapshot.data;

                      if (chipMap.isEmpty && decks.isNotEmpty) {
                        chipMap[decks[0]] = true;
                      }

                      return Wrap(
                        alignment: WrapAlignment.start,
                        children: [
                          ...decks.map((e) {
                            int index = int.tryParse(e.uid[0]) ?? 0;

                            List<Color> colors = [
                              Colors.teal,
                              Colors.orange,
                              Colors.grey,
                              Colors.redAccent,
                              Colors.indigoAccent,
                              Colors.cyan,
                              Colors.pinkAccent,
                              Colors.lightBlue,
                              Colors.lightGreen,
                              Colors.amber
                            ];

                            bool selected = chipMap[e] ?? false;

                            return FilterChip(
                                selectedColor: colors.elementAt(index),
                                backgroundColor:
                                    colors.elementAt(index).withOpacity(0.8),
                                selected: selected,
                                label: Text(e.title),
                                onSelected: (val) {
                                  setState(() {
                                    if (val == true) {
                                      chipMap.clear();
                                      chipMap[e] = val;
                                      DeckBloc.instance.selectDeck(e.uid);
                                    }
                                  });
                                });
                          }).toList(),
                          ActionChip(
                            label: Icon(Icons.add),
                            onPressed: () {
                              showGeneralDialog(
                                barrierLabel: "Barrier",
                                barrierDismissible: true,
                                barrierColor: Colors.black.withOpacity(0.5),
                                transitionDuration: Duration(milliseconds: 300),
                                context: context,
                                pageBuilder: (_, __, ___) {
                                  final textEditingController =
                                      TextEditingController();
                                  return Align(
                                    alignment: Alignment.topCenter,
                                    child: Container(
                                      height: 360,
                                      //child: SizedBox.expand(child: FlutterLogo()),
                                      margin: EdgeInsets.only(
                                          top: 48, left: 12, right: 12),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(40),
                                      ),
                                      child: Column(
                                        children: <Widget>[
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  top: 12, left: 24, right: 24),
                                              child: Material(
                                                  color: Colors.transparent,
                                                  child: TextField(
                                                    controller:
                                                        textEditingController,
                                                    decoration: InputDecoration(
                                                        labelText: 'Title'),
                                                  ))),
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  top: 12, left: 24, right: 24),
                                              child: RaisedButton(
                                                child: Text('New Deck'),
                                                onPressed: () {
                                                  var title =
                                                      textEditingController
                                                          .text;

                                                  DeckBloc.instance
                                                      .newDeck(title);

                                                  Navigator.pop(context);
                                                },
                                              )),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                transitionBuilder: (_, anim, __, child) {
                                  return SlideTransition(
                                    position: Tween(
                                            begin: Offset(0, 1),
                                            end: Offset(0, 0))
                                        .animate(anim),
                                    child: child,
                                  );
                                },
                              );
                            },
                          ),
                        ],
                        spacing: 8,
                      );
                    }

                    return Container();
                  },
                ),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ))
        ],
      ),
      resizeToAvoidBottomInset: false,
    );
  }

  void onAddCardPressed() {
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 300),
      context: context,
      pageBuilder: (_, __, ___) {
        final textEditingController = TextEditingController();
        return Align(
          alignment: Alignment.topCenter,
          child: Container(
            height: 360,
            //child: SizedBox.expand(child: FlutterLogo()),
            margin: EdgeInsets.only(top: 48, left: 12, right: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
            ),
            child: Column(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(top: 12, left: 24, right: 24),
                    child: Material(
                        color: Colors.transparent,
                        child: TextField(
                          controller: textEditingController,
                          decoration: InputDecoration(labelText: 'Title'),
                        ))),
                Padding(
                    padding: EdgeInsets.only(top: 12, left: 24, right: 24),
                    child: RaisedButton(
                      child: Text('Add Card'),
                      onPressed: () {
                        var title = textEditingController.text;

                        var card =
                            FlashCard.create(title: title, content: title);

                        DeckBloc.instance.addCard(card);

                        Navigator.pop(context);
                      },
                    )),
              ],
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
  }
}

class CustomCarouselSlider extends StatelessWidget {
  final List<FlashCard> cards;

  CustomCarouselSlider({this.cards});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        autoPlay: false,
        aspectRatio: 1.5,
        enlargeCenterPage: false,
        height: 240,
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
