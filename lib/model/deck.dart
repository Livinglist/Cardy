import 'dart:convert';

import 'package:flash_card/resource/constants.dart';
import 'package:uuid/uuid.dart';
import 'flash_card.dart';

export 'flash_card.dart';

class Deck {
  String title;
  final int timeStamp;
  final List<FlashCard> cards;
  final String uid;

  Deck({this.cards, this.timeStamp, this.title, this.uid}) : assert(title != null);

  Deck.create({this.title})
      : assert(title != null),
        this.cards = [],
        this.timeStamp = DateTime.now().toUtc().millisecondsSinceEpoch,
        this.uid = Uuid().v1();

  Deck.fromJson(String json) : this.fromMap(jsonDecode(json));

  Deck.fromMap(Map map)
      : this.cards = map[cardsKey],
        this.timeStamp = map[timeStampKey],
        this.title = map[titleKey],
        this.uid = map[uidKey];

  Map toMap() => {
        cardsKey: cards.map((e) => e.toMap()),
        timeStampKey: timeStamp,
        titleKey: title,
        uidKey: uid,
      };

  String toJson() => jsonEncode(this.toMap());

  void addCard(FlashCard card) {
    cards.add(card);
  }

  void removeCard(FlashCard card) {
    cards.remove(card);
  }

  void removeAt(int index) {
    cards.removeAt(index);
  }
}
