import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:solitaire/components/foundation.dart';
import 'package:solitaire/components/stock.dart';
import 'package:solitaire/components/waste.dart';

import 'components/card.dart';
import 'components/pile.dart';

class SolitaireGame extends FlameGame {
  static const double cardGap = 175.0;
  static const double cardWidth = 1000.0;
  static const double cardHeight = 1400.0;
  static const double cardRadius = 100.0;
  static final Vector2 cardSize = Vector2(cardWidth, cardHeight);

  @override
  Future<void> onLoad() async {
    await Flame.images.load('sprites.png');

    final stock = Stock()
      ..size = cardSize
      ..position = Vector2(cardGap, cardGap);

    final waste = Waste()
      ..size = cardSize
      ..position = Vector2(cardWidth + 2 * cardGap, cardGap);

    final foundation = List.generate(
        4,
        (i) => Foundation()
          ..size = cardSize
          ..position = Vector2((i + 3) * (cardWidth + cardGap), cardGap));

    final piles = List.generate(
        7,
        (i) => Pile()
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

    final random = Random();
    for (var i = 0; i < 7; i++) {
      for (var j = 0; j < 4; j++) {
        final card = Card(intRank: random.nextInt(13) + 1, intSuit: random.nextInt(4))
          ..position = Vector2(100 + i * 1150, 100 + j * 1500)
          ..addToParent(world);
        if (random.nextDouble() < 0.9) { // flip face up with 90% probability
          card.flip();
        }
      }
    }
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
