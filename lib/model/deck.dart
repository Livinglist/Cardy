import 'dart:convert';

import 'package:flash_card/resource/constants.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'flash_card.dart';

part 'deck.g.dart';

@HiveType(typeId: 1)
class Deck extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  final int timeStamp;

  @HiveField(2)
  final List<FlashCard> cards;

  @HiveField(3)
  final String uid;

  Deck({this.cards, this.timeStamp, this.title, this.uid})
      : assert(title != null);

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

  @override
  bool operator ==(Object other) {
    if (other is Deck && other.uid == this.uid) return true;
    return false;
  }

  @override
  int get hashCode => uid.hashCode;
}
