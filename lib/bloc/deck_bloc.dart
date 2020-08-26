import "package:rxdart/rxdart.dart";
import 'package:hive/hive.dart';
import 'package:flash_card/model/deck.dart';

class DeckBloc {
  static final instance = DeckBloc._();

  DeckBloc._();

  final _decksFetcher = BehaviorSubject<List<Deck>>();
  final _singleDeckFetcher = BehaviorSubject<Deck>();

  Stream<List<Deck>> get decks => _decksFetcher.stream;
  Stream<Deck> get deck => _singleDeckFetcher.stream;

  void addCard(FlashCard card) {
    _singleDeckFetcher.last.then((deck) {
      deck.addCard(card);
      _singleDeckFetcher.add(deck);
    });
  }

  void newDeck(String title) {
    var deck = Deck.create(title: title);

    //Add to the list of deck uids.
    var decksBoxes = Hive.box('decks');
    var lis = (decksBoxes.get('deckUids') as List)..add(deck.uid);
    decksBoxes.put('decks', lis);

    //Add the deck to Hive.
    var box = Hive.box(deck.uid);
    box.putAll(deck.toMap());
  }

  void setDeckTitle(String title) {
    _singleDeckFetcher.last.then((deck) {
      deck.title = title;
      var box = Hive.box(deck.uid);
      box.putAll(deck.toMap());
      _singleDeckFetcher.add(deck);
    });
  }

  dispose() {
    _decksFetcher.close();
    _singleDeckFetcher.close();
  }
}
