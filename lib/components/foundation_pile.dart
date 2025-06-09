import 'dart:ui';

import 'package:flame/components.dart';
import 'package:solitaire/solitaire_game.dart';

import '../suit.dart';
import 'card.dart';

class FoundationPile extends PositionComponent {
  final Suit suit;

  FoundationPile(int intSuit, {super.position})
      : suit = Suit.fromInt(intSuit),
        super(size: SolitaireGame.cardSize);

  @override
  bool get debugMode => true;

  final List<Card> _cards = [];
  final _borderPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 10
    ..color = const Color(0x50ffffff);
  late final _suitPaint = Paint()
    ..color = suit.isRed ? const Color(0x3a000000) : const Color(0x64000000)
    ..blendMode = BlendMode.luminosity;

  void acquireCard(Card card) {
    assert(card.isFaceUp);

    card.position = position;
    card.priority = _cards.length;
    _cards.add(card);
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(SolitaireGame.cardRRect, _borderPaint);
    suit.sprite.render(canvas,
        position: size / 2,
        anchor: Anchor.center,
        size: Vector2.all(SolitaireGame.cardWidth * 0.6),
        overridePaint: _suitPaint);
  }
}
