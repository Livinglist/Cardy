import 'dart:convert';

import 'package:flash_card/resource/constants.dart';
import 'package:hive/hive.dart';

part 'flash_card.g.dart';

@HiveType(typeId: 0)
class FlashCard extends HiveObject {
  @HiveField(0)
  String content;

  @HiveField(1)
  String title;

  @HiveField(2)
  final int timeStamp;

  FlashCard({this.content, this.timeStamp, this.title}) : assert(title != null);

  FlashCard.create({this.content, this.title})
      : assert(title != null),
        this.timeStamp = DateTime.now().toUtc().millisecondsSinceEpoch;

  FlashCard.fromMap(Map map)
      : this.content = map[contentKey],
        this.timeStamp = map[timeStampKey],
        this.title = map[titleKey];

  Map toMap() => {
        contentKey: content,
        timeStampKey: timeStamp,
        titleKey: title,
      };

  String toJson() => jsonEncode(this.toMap());
}
