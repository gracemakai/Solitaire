import 'dart:ui';

import 'package:flame/components.dart';
import 'package:solitaire/components/card.dart';
import 'package:solitaire/solitaire_game.dart';

class TableauPile extends PositionComponent {

  @override
  bool get debugMode => true;

  final _borderPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 10
    ..color = const Color(0x50ffffff);

  final List<Card> _cards = [];
  final Vector2 _fanOffset = Vector2(0, SolitaireGame.cardHeight * 0.05);

  void acquireCard(Card card){
    if(_cards.isEmpty){
      card.position = position;
    }else{
      card.position = _cards.last.position + _fanOffset;
    }
    card.priority = _cards.length;
    _cards.add(card);
  }

  void flipTopCard(){
    assert(_cards.last.isFaceDown);

    _cards.last.flip();
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(SolitaireGame.cardRRect, _borderPaint);
  }
}