import 'package:flash_card/ui/main_page.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'model/deck.dart';
import 'model/flash_card.dart';

void main() async {
  runApp(MyApp());
  Hive.registerAdapter(DeckAdapter());
  Hive.registerAdapter(FlashCardAdapter());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cardy',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        primaryColor: Colors.black,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FutureBuilder(
        future: getApplicationDocumentsDirectory(),
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            Hive.init(snapshot.data.path);
            return MainPage();
          }
          return Container(color: Colors.black);
        },
      ),
    );
  }
}
