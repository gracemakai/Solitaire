import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:solitaire/solitaire_world.dart';

enum Action {newDeal, sameDeal, changeDraw, haveFun}

class SolitaireGame extends FlameGame<SolitaireWorld> {
  static const double cardGap = 175.0;
  static const double topGap = 500.0;
  static const double cardWidth = 1000.0;
  static const double cardHeight = 1400.0;
  static const double cardRadius = 100.0;
  static const double cardSpaceWidth = cardWidth + cardGap;
  static const double cardSpaceHeight = cardHeight + cardGap;
  static final Vector2 cardSize = Vector2(cardWidth, cardHeight);
  static final cardRRect = RRect.fromRectAndRadius(
    const Rect.fromLTWH(0, 0, cardWidth, cardHeight),
    const Radius.circular(cardRadius),
  );
  int solitaireDraw = 1;
  // Constant used when creating Random seed.
  static const int maxInt = 0xFFFFFFFE;
  int seed = 1;
  Action action = Action.newDeal;

  SolitaireGame(): super(world: SolitaireWorld());
}

Sprite solitaireSprite(double x, double y, double width, double height) {
  return Sprite(
    Flame.images.fromCache('sprites.png'),
    srcPosition: Vector2(x, y),
    srcSize: Vector2(width, height),
  );
}
