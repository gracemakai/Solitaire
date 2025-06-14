import 'dart:ui';

import 'package:flame/components.dart';
import 'package:solitaire/components/pile.dart';
import 'package:solitaire/solitaire_game.dart';

import '../suit.dart';
import 'card.dart';

class FoundationPile extends PositionComponent implements Pile {
  final Suit suit;
  final VoidCallback checkWin;

  FoundationPile(int intSuit, this.checkWin, {super.position})
      : suit = Suit.fromInt(intSuit),
        super(size: SolitaireGame.cardSize);

  final List<Card> _cards = [];
  bool get isFull => _cards.length == 13;

  final _borderPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 10
    ..color = const Color(0x50ffffff);
  late final _suitPaint = Paint()
    ..color = suit.isRed ? const Color(0x3a000000) : const Color(0x64000000)
    ..blendMode = BlendMode.luminosity;

  @override
  void acquireCard(Card card) {
    assert(card.isFaceUp);

    card.pile = this;
    card.position = position;
    card.priority = _cards.length;
    _cards.add(card);
    if (isFull) {
      checkWin();
    }
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

  @override
  bool canMoveCard(Card card) => _cards.isNotEmpty && card == _cards.last;

  @override
  bool canAcceptCard(Card card) {
    final topCardRank = _cards.isEmpty ? 0 : _cards.last.rank.value;
    return card.suit == suit && card.rank.value == topCardRank + 1 &&
    card.attachedCards.isEmpty;
  }

  @override
  void returnCard(Card card) {
    card.position = position;
    card.priority = _cards.indexOf(card);
  }

  @override
  void removeCard(Card card) {
    assert(canMoveCard(card));
    _cards.removeLast();
  }
}
