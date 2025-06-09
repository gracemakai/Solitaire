import 'package:flame/components.dart';
import 'package:solitaire/components/pile.dart';
import 'package:solitaire/solitaire_game.dart';

import 'card.dart';

class WastePile extends PositionComponent implements Pile {

  @override
  bool get debugMode => true;

  final List<Card> _cards = [];
  final Vector2 _fanOffset = Vector2(SolitaireGame.cardWidth * 0.2, 0);

  @override
  void acquireCard(Card card){
    assert(card.isFaceUp);

    card.pile = this;
    card.position = position;
    card.priority = _cards.length;
    _cards.add(card);
    _fanOutTopCards();
  }

  void _fanOutTopCards(){
    final n = _cards.length;
    for(var i = 0; i < n; i++){
      _cards[i].position = position;
    }

    if(n == 2){
      _cards[1].position.add(_fanOffset);
    }else{
      _cards[n - 2].position.add(_fanOffset);
      _cards[n - 2].position.addScaled(_fanOffset, 2);
    }
  }

  List<Card> removeAllCards(){
    final cards = _cards.toList();
    _cards.clear();
    return cards;
  }

  @override
  bool canMoveCard(Card card) => _cards.isNotEmpty && card ==_cards.last;

  @override
  bool canAcceptCard(Card card) => false;

  @override
  void returnCard(Card card) {
    card.priority = _cards.indexOf(card);
    _fanOutTopCards();
  }

  @override
  void removeCard(Card card) {
    _cards.remove(card);
  }
}