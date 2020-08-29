import 'package:flash_card/bloc/deck_bloc.dart';
import 'package:flash_card/ui/components/flash_card_view.dart';
import 'package:flutter/material.dart';

class DeckEditPage extends StatefulWidget {
  @override
  _DeckEditPageState createState() => _DeckEditPageState();
}

class _DeckEditPageState extends State<DeckEditPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: DeckBloc.instance.deck,
        builder: (_, AsyncSnapshot<Deck> snapshot) {
          if (snapshot.hasData) {
            var deck = snapshot.data;
            var cards = deck.cards;
            return Scaffold(
                key: scaffoldKey,
                appBar: AppBar(actions: [
                  IconButton(icon: Icon(Icons.edit), onPressed: onEditPressed)
                ], elevation: 0, title: Text(snapshot.data.title)),
                backgroundColor: Colors.black,
                body: ListView(
                  children: cards.map((e) {
                    return Dismissible(
                      key: UniqueKey(),
                      background: Container(
                        color: Colors.blue,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            child: Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                            padding: EdgeInsets.only(left: 36),
                          ),
                        ),
                      ),
                      secondaryBackground: Container(
                        color: Colors.red,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            child: Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                            padding: EdgeInsets.only(right: 36),
                          ),
                        ),
                      ),
                      child: FlashCardView(
                        key: UniqueKey(),
                        title: e.title,
                        content: e.content,
                      ),
                      onDismissed: (DismissDirection direction) {
                        int currentIndex = cards.indexOf(e);
                        DeckBloc.instance
                            .removeCardAt(currentIndex)
                            .then((title) {
                          if (title != null) {
                            scaffoldKey.currentState.hideCurrentSnackBar();
                            scaffoldKey.currentState.showSnackBar(SnackBar(
                              content: Text('Removed $title'),
                              action: SnackBarAction(
                                label: 'Revert',
                                onPressed: () {
                                  DeckBloc.instance
                                      .revertRemovingCard(currentIndex);
                                },
                              ),
                            ));
                          }
                        });
                      },
                      confirmDismiss: (DismissDirection direction) {
                        if (direction == DismissDirection.endToStart) {
                          return Future.value(true);
                        }

                        showEditPopup(e);
                        return Future.value(false);
                      },
                    );
                  }).toList(),
                ));
          } else
            return Container();
        });
  }

  void showEditPopup(FlashCard card) {
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

  void onEditPressed() {
    DeckBloc.instance.deck.first.then((deck) {
      showGeneralDialog(
        barrierLabel: "Barrier",
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.5),
        transitionDuration: Duration(milliseconds: 300),
        context: context,
        pageBuilder: (_, __, ___) {
          final textEditingController = TextEditingController();
          textEditingController.text = deck.title;
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
                        child: Icon(Icons.check),
                        onPressed: () {
                          var title = textEditingController.text;

                          DeckBloc.instance.editDeckTitle(title);

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
            position:
                Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
            child: child,
          );
        },
      );
    });
  }
}
