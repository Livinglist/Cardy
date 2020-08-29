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

  ///A temp storage for removed card.
  FlashCard removedCard;

  Stream<List<Deck>> get decks => _decksFetcher.stream;
  Stream<Deck> get deck => _singleDeckFetcher.stream;

  void init() async {
    var uids = <String>[];

    var decksRefBox = await Hive.openBox(deckUidsKey);
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
        _decksFetcher.sink
            .add(decks..sort((a, b) => a.timeStamp.compareTo(b.timeStamp)));
      });
    }

    _decksFetcher.sink
        .add(decks..sort((a, b) => a.timeStamp.compareTo(b.timeStamp)));
  }

  void getAllDecks() async {
    var uids = <String>[];

    var decksRefBox = await Hive.openBox(deckUidsKey);
    print(decksRefBox.values);
    uids = decksRefBox.values.whereType<String>().toList();
    print("uids is $uids");

    var decks = <Deck>[];

    for (var uid in uids) {
      Hive.openBox(uid).then((box) {
        var deck = box.get('deck') as Deck;
        print("The deck is ${deck.title ?? 'null'}");
        decks.add(deck);
        _decksFetcher.sink
            .add(decks..sort((a, b) => a.timeStamp.compareTo(b.timeStamp)));
      });
    }

    _decksFetcher.sink
        .add(decks..sort((a, b) => a.timeStamp.compareTo(b.timeStamp)));
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

  void editCard(FlashCard card) {
    _singleDeckFetcher.first.then((deck) {
      // var cardToBeEdited = deck.cards.singleWhere((element) => element.timeStamp == card.timeStamp,
      //     orElse: () => null);
      // cardToBeEdited = deck.cards
      // deck.addCard(card);
      deck.save();

      // Hive.openBox(deck.uid).then((box) {
      //   box.put('deck', deck);
      // });
      _singleDeckFetcher.add(deck);
    });
  }

  Future<String> removeCardAt(int index) {
    return _singleDeckFetcher.first.then((deck) {
      if (deck.cards.isEmpty) return null;

      removedCard = deck.cards.elementAt(index);
      String title = removedCard.title;
      deck.cards.removeAt(index);
      deck.save();

      _singleDeckFetcher.add(deck);

      return title;
    });
  }

  void revertRemovingCard([int index]) {
    _singleDeckFetcher.first.then((deck) {
      if (index == null)
        deck.cards.add(removedCard);
      else
        deck.cards.insert(index, removedCard);
      deck.save();

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

    _singleDeckFetcher.sink.add(deck);

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

  Future<Deck> deleteDeck(Deck deck) {
    return decks.first.then((decks) {
      int index = decks.indexOf(deck) + 1;
      Deck nextDeck;
      if (decks.length == 1) {
        nextDeck = null;
      } else if (index >= decks.length) {
        nextDeck = decks[index - 2];
      } else {
        nextDeck = decks[index];
      }

      decks.remove(deck);
      deck.delete();
      Hive.openBox(deckUidsKey).then((box) {
        print('deleting ${deck.uid}');
        var values = box.values.toList();
        values.remove(deck.uid);
        box.clear().then((value) => box.addAll(values));
      });
      _decksFetcher.sink.add(decks);
      if (nextDeck != null) _singleDeckFetcher.sink.add(nextDeck);

      return nextDeck;
    });
  }

  void editDeckTitle(String title) {
    _singleDeckFetcher.first.then((deck) {
      deck.title = title;
      deck.save();
      _singleDeckFetcher.sink.add(deck);
      getAllDecks();
    });
  }

  dispose() {
    _decksFetcher.close();
    _singleDeckFetcher.close();
  }
}
