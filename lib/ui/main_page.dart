import 'package:flutter/material.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/scheduler.dart';
import 'components/custom_carousel_slider.dart';
import 'package:flash_card/bloc/deck_bloc.dart';
import 'package:flash_card/ui/deck_edit_page.dart';
import 'package:flash_card/ui/deck_play_page.dart';
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
    SchedulerBinding.instance.addPostFrameCallback((Duration duration) {
      FeatureDiscovery.discoverFeatures(
        context,
        const <String>{
          'add_deck',
          'add_card',
          'remove_card',
          'edit_card',
        },
      );
    });
    DeckBloc.instance.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: DeckBloc.instance.decks,
      builder: (_, AsyncSnapshot<List<Deck>> decksSnapshot) {
        var decks = decksSnapshot.data;

        return StreamBuilder(
          stream: DeckBloc.instance.deck,
          builder: (_, AsyncSnapshot<Deck> snapshot) {
            selectedDeck = snapshot.data;

            Widget addDeckRaisedButton,
                addCardRaisedButton,
                removeCardRaisedButton,
                editCardRaisedButton;

            addDeckRaisedButton = DescribedFeatureOverlay(
              featureId: 'add_deck', // Unique id that identifies this overlay.
              tapTarget: Icon(Icons
                  .add), // The widget that will be displayed as the tap target.
              title: Text('Create An Deck'),
              description: Text('Tap Here To Create An New Deck.'),
              backgroundColor: Colors.blueGrey,
              targetColor: Colors.white,
              textColor: Colors.white,
              child: ActionChip(
                  label: Icon(Icons.add), onPressed: onNewDeckPressed),
            );
            addCardRaisedButton = DescribedFeatureOverlay(
                featureId:
                    'add_card', // Unique id that identifies this overlay.
                tapTarget: Icon(Icons
                    .add), // The widget that will be displayed as the tap target.
                title: Text('Add A Flash Card'),
                description: Text('Tap Here To Create A Flash Card.'),
                backgroundColor: Colors.deepOrange,
                targetColor: Colors.white,
                textColor: Colors.white,
                child: RaisedButton(
                  child: Icon(Icons.add),
                  onPressed: onAddCardPressed,
                  shape: StadiumBorder(),
                ));
            removeCardRaisedButton = DescribedFeatureOverlay(
              featureId:
                  'remove_card', // Unique id that identifies this overlay.
              tapTarget: Icon(Icons
                  .remove), // The widget that will be displayed as the tap target.
              title: Text('Remove A Flash Card'),
              description: Text('Tap Here To Remove A Flash Card.'),
              backgroundColor: Colors.purple,
              targetColor: Colors.red,
              textColor: Colors.white,
              child: RaisedButton(
                child: Icon(Icons.remove),
                color: Colors.red,
                onPressed: onRemoveCardPressed,
                shape: CircleBorder(),
              ),
            );
            editCardRaisedButton = DescribedFeatureOverlay(
              featureId: 'edit_card', // Unique id that identifies this overlay.
              tapTarget: Icon(Icons
                  .edit), // The widget that will be displayed as the tap target.
              title: Text('Edit A Flash Card'),
              description: Text('Tap Here To Edit A Flash Card.'),
              backgroundColor: Colors.purple,
              targetColor: Colors.red,
              textColor: Colors.white,
              child: RaisedButton(
                child: Icon(Icons.edit),
                color: Colors.red,
                onPressed: () {
                  if (selectedDeck != null && selectedDeck.cards.isNotEmpty)
                    onEditCardPressed(
                        selectedDeck.cards.elementAt(currentIndex));
                },
                shape: CircleBorder(),
              ),
            );

            return Scaffold(
              key: scaffoldKey,
              appBar: AppBar(
                actions: [
                  IconButton(
                      icon: Icon(Icons.delete_forever),
                      onPressed: onDeleteDeckPressed),
                  IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => DeckEditPage()));
                      }),
                  IconButton(
                      icon: Icon(Icons.play_arrow),
                      onPressed: () {
                        if (selectedDeck == null) {
                          scaffoldKey.currentState.hideCurrentSnackBar();
                          scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text('No Deck Found'),
                            action: SnackBarAction(
                              label: 'OK',
                              onPressed: () => scaffoldKey.currentState
                                  .hideCurrentSnackBar(),
                            ),
                          ));
                          return;
                        }
                        DeckBloc.instance.deck.first.then((deck) {
                          if (deck.cards.isNotEmpty)
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => DeckPlayPage(
                                          deck: deck,
                                        )));
                          else {
                            scaffoldKey.currentState.hideCurrentSnackBar();
                            scaffoldKey.currentState.showSnackBar(SnackBar(
                              content: Text('${deck.title} Is Empty'),
                              action: SnackBarAction(
                                label: 'OK',
                                onPressed: () => scaffoldKey.currentState
                                    .hideCurrentSnackBar(),
                              ),
                            ));
                          }
                        });
                      }),
                ],
                elevation: 0,
              ),
              backgroundColor: Colors.black,
              body: Column(
                children: [
                  if (!snapshot.hasData || decks.isEmpty)
                    Container(
                      height: 240,
                      child: Center(
                        child: Text(
                          'No Deck Found',
                          style: TextStyle(color: Colors.white60),
                        ),
                      ),
                    ),
                  if (snapshot.hasData && selectedDeck.cards.isEmpty)
                    Center(
                        child: Container(
                            height: 240,
                            child: Center(
                              child: Text(
                                'No Flash Card Found in ${selectedDeck.title}',
                                style: TextStyle(color: Colors.white60),
                              ),
                            ))),
                  if (snapshot.hasData && selectedDeck.cards.isNotEmpty)
                    CustomCarouselSlider(
                      cards: selectedDeck.cards,
                      onPageChanged: (index) {
                        currentIndex = index;
                      },
                    ),
                  Padding(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        removeCardRaisedButton,
                        addCardRaisedButton,
                        editCardRaisedButton,
                      ],
                    ),
                    padding: EdgeInsets.all(12),
                  ),
                  Spacer(),
                  Container(
                      width: double.infinity,
                      child: Padding(
                        child: decksSnapshot.hasData
                            ? Wrap(
                                alignment: WrapAlignment.start,
                                children: [
                                  ...decks.map((e) {
                                    int index, i = 0;

                                    do {
                                      index = int.tryParse(e.uid[i++]);
                                    } while (index == null);

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

                                    bool selected = selectedDeck.uid == e.uid;

                                    return FilterChip(
                                        selectedColor: colors.elementAt(index),
                                        backgroundColor: colors
                                            .elementAt(index)
                                            .withOpacity(0.8),
                                        selected: selected,
                                        label: Text(e.title),
                                        onSelected: (val) {
                                          setState(() {
                                            if (val == true) {
                                              DeckBloc.instance
                                                  .selectDeck(e.uid);
                                            }
                                          });
                                        });
                                  }).toList(),
                                  addDeckRaisedButton
                                ],
                                spacing: 8,
                              )
                            : Container(),
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      ))
                ],
              ),
              resizeToAvoidBottomInset: false,
            );
          },
        );
      },
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
    if (selectedDeck == null) {
      scaffoldKey.currentState.hideCurrentSnackBar();
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('No Deck Found'),
        action: SnackBarAction(
          label: 'OK',
          onPressed: () => scaffoldKey.currentState.hideCurrentSnackBar(),
        ),
      ));
      return;
    }
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

  void onNewDeckPressed() {
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
            height: 160,
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
                      child: Text('New Deck'),
                      onPressed: () {
                        var title = textEditingController.text;

                        DeckBloc.instance.newDeck(title);

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

  void onEditCardPressed(FlashCard card) {
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.9),
      transitionDuration: Duration(milliseconds: 300),
      context: context,
      pageBuilder: (_, __, ___) {
        final titleEditingController = TextEditingController();
        final contentEditingController = TextEditingController();

        titleEditingController.text = card.title;
        contentEditingController.text = card.content;

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
                    child: Icon(Icons.check),
                    shape: StadiumBorder(),
                    onPressed: () {
                      var title = titleEditingController.text;
                      var content = contentEditingController.text;

                      card.title = title;
                      card.content = content;

                      DeckBloc.instance.editCard(card);

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
}
