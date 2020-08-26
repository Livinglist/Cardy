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
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
        ),
        backgroundColor: Colors.black,
        body: Column(
          children: [
            CustomCarouselSlider(),
            Padding(
              child: RaisedButton(
                child: Icon(Icons.add),
                onPressed: () {},
                shape: StadiumBorder(),
              ),
              padding: EdgeInsets.all(12),
            ),
            Spacer(),
            Container(
                width: double.infinity,
                child: Padding(
                  child: Wrap(
                    alignment: WrapAlignment.start,
                    children: [
                      ...categories.map((e) {
                        int index = int.parse(e.hashCode.toString()[0]);

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
                            backgroundColor: colors.elementAt(index).withOpacity(0.8),
                            selected: selected,
                            label: Text(e),
                            onSelected: (val) {
                              setState(() {
                                chipMap.clear();
                                chipMap[e] = val;
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
                                            child: RaisedButton(
                                              child: Padding(
                                                padding: EdgeInsets.only(top: 12, left: 24, right: 24, bottom: 12),
                                                child: Text('Title', style: TextStyle(fontSize: 24, fontFamily: 'noto')),
                                              ),
                                              onPressed: () {
                                                var title = textEditingController.text;
                                                DeckBloc.instance.newDeck(title);
                                              },
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(40),
                                              ),
                                            ),
                                          ))
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
                        },
                      ),
                    ],
                    spacing: 8,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ))
          ],
        ));
  }
}

class CustomCarouselSlider extends StatelessWidget {
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
        Padding(
          child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0))),
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
                            'Title is gsdfsdafd asdasdasdasd',
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
                            'Title is gsdfsdafd asdasdasdasdasdfdasfasdfadsasd',
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
        ),
        Padding(
          child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0))),
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
                            'Good',
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
                            'Absolutely nice yoh',
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
        ),
        Padding(
          child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0))),
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
                            'Title is gsdfsdafd asdasdasdasd',
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
                            'Title is gsdfsdafd asdasdasdasdasdfdasfasdfadsasd',
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
        ),
      ],
    );
  }
}
