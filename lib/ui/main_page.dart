import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flash_card/bloc/deck_bloc.dart';
import 'package:flash_card/ui/deck_edit_page.dart';
import 'package:flash_card/ui/deck_play_page.dart';
import 'package:flutter/material.dart';

import 'deck_edit_page.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final categories = [
    'English',
    'N2 Kanji',
    'GRE Vocabulary',
  ];
  final scaffoldKey = GlobalKey<ScaffoldState>();
  int currentIndex;
  Deck selectedDeck;

  @override
  void initState() {
    DeckBloc.instance.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        actions: [
          IconButton(
              icon: Icon(Icons.delete_forever), onPressed: onDeleteDeckPressed),
          IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => DeckEditPage()));
              }),
          IconButton(
              icon: Icon(Icons.play_arrow),
              onPressed: () {
                DeckBloc.instance.deck.first.then((deck) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => DeckPlayPage(
                                deck: deck,
                              )));
                });
              }),
        ],
        elevation: 0,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          StreamBuilder(
            stream: DeckBloc.instance.deck,
            builder: (_, AsyncSnapshot<Deck> snapshot) {
              if (snapshot.hasData) {
                return CustomCarouselSlider(
                  cards: snapshot.data.cards,
                  onPageChanged: (index) {
                    currentIndex = index;
                  },
                );
              }

              return Center(
                child: Text('No Deck Selected'),
              );
            },
          ),
          Padding(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RaisedButton(
                  child: Icon(Icons.add),
                  onPressed: onAddCardPressed,
                  shape: StadiumBorder(),
                ),
                RaisedButton(
                  child: Icon(Icons.remove),
                  color: Colors.red,
                  onPressed: onRemoveCardPressed,
                  shape: CircleBorder(),
                ),
              ],
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

                      if (selectedDeck == null && decks.isNotEmpty) {
                        selectedDeck = decks[0];
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

                            bool selected = selectedDeck == e;

                            return FilterChip(
                                selectedColor: colors.elementAt(index),
                                backgroundColor:
                                    colors.elementAt(index).withOpacity(0.8),
                                selected: selected,
                                label: Text(e.title),
                                onSelected: (val) {
                                  setState(() {
                                    if (val == true) {
                                      selectedDeck = e;
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

  void onRemoveCardPressed() {
    DeckBloc.instance.removeCardAt(currentIndex).then((title) {
      if (title != null) {
        scaffoldKey.currentState.hideCurrentSnackBar();
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('Removed $title'),
          action: SnackBarAction(
            label: 'Revert',
            onPressed: () {
              DeckBloc.instance.revertRemovingCard(currentIndex);
            },
          ),
        ));
      }
    });
  }

  void onAddCardPressed() {
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.9),
      transitionDuration: Duration(milliseconds: 300),
      context: context,
      pageBuilder: (_, __, ___) {
        final titleEditingController = TextEditingController();
        final contentEditingController = TextEditingController();
        return Align(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              Container(
                height: 240,
                //child: SizedBox.expand(child: FlutterLogo()),
                margin: EdgeInsets.only(top: 48, left: 12, right: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(0),
                ),
                child: Column(
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(top: 12, left: 24, right: 24),
                        child: Material(
                            color: Colors.transparent,
                            child: TextField(
                              controller: titleEditingController,
                              decoration: InputDecoration(labelText: 'Title'),
                              style: TextStyle(fontWeight: FontWeight.w800),
                            ))),
                    Padding(
                        padding: EdgeInsets.only(top: 12, left: 24, right: 24),
                        child: Material(
                            color: Colors.transparent,
                            child: TextField(
                              controller: contentEditingController,
                              decoration: InputDecoration(labelText: 'Content'),
                              minLines: 4,
                              maxLines: 5,
                            ))),
                  ],
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(top: 12, left: 24, right: 24),
                  child: RaisedButton(
                    child: Icon(Icons.add),
                    shape: StadiumBorder(),
                    onPressed: () {
                      var title = titleEditingController.text;
                      var content = contentEditingController.text;

                      var card =
                          FlashCard.create(title: title, content: content);

                      DeckBloc.instance.addCard(card);

                      Navigator.pop(context);
                    },
                  )),
            ],
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

  void onDeleteDeckPressed() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Delete ${selectedDeck.title}'),
            content: Text('Confirm deleting ${selectedDeck.title}?'),
            actions: [
              FlatButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel')),
              FlatButton(
                  onPressed: () {
                    DeckBloc.instance.deleteDeck(selectedDeck).then((nextDeck) {
                      setState(() {
                        selectedDeck = nextDeck;
                      });
                    });
                    Navigator.pop(context);
                  },
                  child: Text('Yes')),
            ],
          );
        });
  }
}

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
