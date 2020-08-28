import 'package:flash_card/model/flash_card.dart';
import 'package:flash_card/resource/constants.dart';
import 'package:path_provider/path_provider.dart';
import "package:rxdart/rxdart.dart";
import 'package:hive/hive.dart';
import 'package:flash_card/model/deck.dart';

export 'package:flash_card/model/deck.dart';
export 'package:flash_card/model/flash_card.dart';

class DeckBloc {
  static final instance = DeckBloc._();

  DeckBloc._();

  final _decksFetcher = BehaviorSubject<List<Deck>>();
  final _singleDeckFetcher = BehaviorSubject<Deck>();

  Stream<List<Deck>> get decks => _decksFetcher.stream;
  Stream<Deck> get deck => _singleDeckFetcher.stream;

  void getAllDecks() async {
    var uids = <String>[];

    var decksRefBox = await Hive.openBox(deckUids);
    print(decksRefBox.values);
    uids = decksRefBox.values.whereType<String>().toList();
    print("uids is $uids");

    var decks = <Deck>[];

    for (var uid in uids) {
      Hive.openBox(uid).then((box) {
        var deck = box.get('deck') as Deck;
        if (_singleDeckFetcher.hasValue == false) {
          _singleDeckFetcher.sink.add(deck);
        }
        print("The deck is ${deck.title ?? 'null'}");
        decks.add(deck);
        _decksFetcher.sink.add(decks);
      });
    }

    _decksFetcher.sink.add(decks);
  }

  void addCard(FlashCard card) {
    print("Trying to add ${card.title} ${_singleDeckFetcher.hasValue}");
    _singleDeckFetcher.first.then((deck) {
      print("Adding card ${card.title} to deck ${deck.title}");
      deck.addCard(card);
      deck.save();

      // Hive.openBox(deck.uid).then((box) {
      //   box.put('deck', deck);
      // });
      _singleDeckFetcher.add(deck);
    });
  }

  void selectDeck(String uid) async {
    print('selecting $uid');
    var decksRefBox = await Hive.openBox(uid);
    var deck = decksRefBox.get('deck');
    _singleDeckFetcher.sink.add(deck);
  }

  void newDeck(String title) async {
    print('The title is $title');
    var deck = Deck.create(title: title);

    var exists = await Hive.boxExists('deckUids');

    if (!exists) {
      var appDocDir = await getApplicationDocumentsDirectory();
      Hive.init(appDocDir.path);
      var decksRefBox = await Hive.openBox('deckUids');
      decksRefBox.add(deck.uid);
    } else {
      var decksRefBox = await Hive.openBox('deckUids');
      decksRefBox.add(deck.uid);
    }

    exists = await Hive.boxExists(deck.uid);

    if (!exists) {
      Hive.openBox(deck.uid).then((box) {
        var box = Hive.box(deck.uid);
        box.put('deck', deck);
        deck.save();
      });
    }

    getAllDecks();
  }

  void setDeckTitle(String title) {
    _singleDeckFetcher.last.then((deck) {
      deck.title = title;
      var box = Hive.box(deck.uid);
      box.put('deck', deck);
      _singleDeckFetcher.add(deck);
    });
  }

  dispose() {
    _decksFetcher.close();
    _singleDeckFetcher.close();
  }
}
