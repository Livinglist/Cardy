import 'dart:convert';

import 'package:flash_card/resource/constants.dart';

class FlashCard {
  final String content;
  final String title;
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
