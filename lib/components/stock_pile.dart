import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:solitaire/components/pile.dart';
import 'package:solitaire/components/waste_pile.dart';
import 'package:solitaire/solitaire_game.dart';

import 'card.dart';

class StockPile extends PositionComponent with TapCallbacks, HasGameReference<SolitaireGame> implements Pile {

  StockPile({super.position}) : super(size: SolitaireGame.cardSize);

  final _borderPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 10
    ..color = const Color(0xFF3F5B5D);
  final _circlePaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 100
    ..color = const Color(0x883F5B5D);
  final List<Card> _cards = [];

  @override
  void acquireCard(Card card) {
    assert(!card.isFaceUp);

    card.pile = this;
    card.position = position;
    card.priority = _cards.length;
    _cards.add(card);
  }

  @override
  void onTapUp(TapUpEvent event) {
    final wastePile = parent!.firstChild<WastePile>()!;

    if(_cards.isEmpty){
      wastePile.removeAllCards().reversed.forEach((card){
        card.flip();
        acquireCard(card);
      });
    }else {
      for (var i = 0; i < game.solitaireDraw; i++) {
        if (_cards.isNotEmpty) {
          final card = _cards.removeLast();
          card.flip();
          wastePile.acquireCard(card);
        }
      }
    }
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(SolitaireGame.cardRRect, _borderPaint);
    canvas.drawCircle(Offset(width / 2, height / 2),
        SolitaireGame.cardWidth * 0.3, _circlePaint);
  }

  @override
  bool canMoveCard(Card card) => false;

  @override
  bool canAcceptCard(Card card) => false;

  @override
  void returnCard(Card card) => throw StateError('Cannot remove cards from this pile');

  @override
  void removeCard(Card card) => throw StateError('Cannot remove cards from this pile');
}
