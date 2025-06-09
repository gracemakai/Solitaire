import 'dart:ui';

import 'package:flame/components.dart';
import 'package:solitaire/components/card.dart';
import 'package:solitaire/components/pile.dart';
import 'package:solitaire/solitaire_game.dart';

class TableauPile extends PositionComponent implements Pile {
  @override
  bool get debugMode => true;

  final _borderPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 10
    ..color = const Color(0x50ffffff);

  final List<Card> _cards = [];
  final Vector2 _fanOffset1 = Vector2(0, SolitaireGame.cardHeight * 0.05);
  final Vector2 _fanOffset2 = Vector2(0, SolitaireGame.cardHeight * 0.20);

  @override
  void acquireCard(Card card) {
    card.pile = this;
    if (_cards.isEmpty) {
      card.position = position;
    } else {
      card.position = _cards.last.position + _fanOffset1;
    }
    card.priority = _cards.length;
    _cards.add(card);
    layoutCards();
  }

  void flipTopCard() {
    assert(_cards.last.isFaceDown);

    _cards.last.flip();
  }

  void layoutCards(){
    if(_cards.isEmpty){
      return;
    }
    _cards[0].position.setFrom(position);
    for(var i = 1; i < _cards.length; i++){
      _cards[i].position..setFrom(_cards[i - 1].position)..add(_cards[i - 1].isFaceDown ? _fanOffset1 : _fanOffset2);
    }
    height = SolitaireGame.cardHeight * 1.5 + _cards.last.y - _cards.first.y;
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(SolitaireGame.cardRRect, _borderPaint);
  }

  @override
  bool canMoveCard(Card card) => _cards.isNotEmpty && card == _cards.last;

  @override
  bool canAcceptCard(Card card) {
    if (_cards.isEmpty) {
      return card.rank.value == 13;
    } else {
      final topCard = _cards.last;

      return card.suit.isRed == !topCard.suit.isRed &&
          card.rank.value == topCard.rank.value - 1;
    }
  }

  @override
  void returnCard(Card card) {
    final index = _cards.indexOf(card);
    card.position = index == 0 ? position : _cards[index - 1].position + _fanOffset1;
    card.priority = index;
    layoutCards();
  }

  @override
  void removeCard(Card card) {
    _cards.remove(card);
    layoutCards();
  }
}
