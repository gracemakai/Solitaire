import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:solitaire/components/foundation_pile.dart';
import 'package:solitaire/components/stock_pile.dart';
import 'package:solitaire/components/waste_pile.dart';

import 'components/card.dart';
import 'components/tableau_pile.dart';

class SolitaireGame extends FlameGame {
  static const double cardGap = 175.0;
  static const double cardWidth = 1000.0;
  static const double cardHeight = 1400.0;
  static const double cardRadius = 100.0;
  static final Vector2 cardSize = Vector2(cardWidth, cardHeight);
  static final cardRRect = RRect.fromRectAndRadius(
    const Rect.fromLTWH(0, 0, cardWidth, cardHeight),
    const Radius.circular(cardRadius),
  );

  @override
  Future<void> onLoad() async {
    await Flame.images.load('sprites.png');

    final stock = StockPile()
      ..size = cardSize
      ..position = Vector2(cardGap, cardGap);

    final waste = WastePile()
      ..size = cardSize
      ..position = Vector2(cardWidth + 2 * cardGap, cardGap);

    final foundation = List.generate(
        4,
        (i) => FoundationPile()
          ..size = cardSize
          ..position = Vector2((i + 3) * (cardWidth + cardGap), cardGap));

    final piles = List.generate(
        7,
        (i) => TableauPile()
          ..size = cardSize
          ..position = Vector2(
              cardGap + i * (cardWidth + cardGap),
              cardHeight + 2 * cardGap));

    world.add(stock);
    world.add(waste);
    world.addAll(foundation);
    world.addAll(piles);

    camera.viewfinder.visibleGameSize =
        Vector2(cardWidth * 7 + cardGap * 8, 4 * cardHeight + 3 * cardGap);
    camera.viewfinder.position = Vector2(cardWidth * 3.5 + cardGap * 4, 0);
    camera.viewfinder.anchor = Anchor.topCenter;

    final cards = [
      for(var rank = 1; rank <=13; rank++)
        for(var suit = 0; suit < 4; suit++)
          Card(intRank: rank, intSuit: suit)
    ];

    cards.shuffle();
    world.addAll(cards);
    cards.forEach(stock.acquireCard);
  }
}

  Sprite solitaireSprite(
    {required double x,
      required double y,
      required double width,
      required double height}) {
  return Sprite(
    Flame.images.fromCache('sprites.png'),
    srcPosition: Vector2(x, y),
    srcSize: Vector2(width, height),
  );
}
