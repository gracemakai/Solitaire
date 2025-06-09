import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:solitaire/components/pile.dart';
import 'package:solitaire/rank.dart';
import 'package:solitaire/solitaire_game.dart';
import 'package:solitaire/suit.dart';

class Card extends PositionComponent with DragCallbacks {
  final Rank rank;
  final Suit suit;
  bool _faceUp;
  Pile? pile;

  Card({required int intRank, required int intSuit})
      : rank = Rank.fromInt(intRank),
        suit = Suit.fromInt(intSuit),
        _faceUp = false,
        super(size: SolitaireGame.cardSize);

  bool get isFaceUp => _faceUp;
  bool get isFaceDown => !_faceUp;
  void flip() => _faceUp = !_faceUp;

  @override
  String toString() => rank.label + suit.label;

  @override
  void render(Canvas canvas) {
    if (_faceUp) {
      _renderFront(canvas);
    } else {
      _renderBack(canvas);
    }
  }

  static final Paint backBackgroundPaint = Paint()
    ..color = const Color(0xff380c02);
  static final Paint backBorderPaint1 = Paint()
    ..color = const Color(0xffdbaf58)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 10;
  static final Paint backBorderPaint2 = Paint()
    ..color = const Color(0x5CEF971B)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 35;
  static final RRect cardRRect = RRect.fromRectAndRadius(
    SolitaireGame.cardSize.toRect(),
    const Radius.circular(SolitaireGame.cardRadius),
  );
  static final RRect backRRectInner = cardRRect.deflate(40);
  static final Sprite flameSprite =
      solitaireSprite(x: 1367, y: 6, width: 357, height: 501);

  static final Paint frontBackgroundPaint = Paint()
    ..color = const Color(0xff000000);
  static final Paint redBorderPaint = Paint()
    ..color = const Color(0xffece8a3)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 10;
  static final Paint blackBorderPaint = Paint()
    ..color = const Color(0xff7ab2e8)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 10;

  static final Sprite redJack =
      solitaireSprite(x: 81, y: 565, width: 562, height: 488);
  static final Sprite redQueen =
      solitaireSprite(x: 717, y: 541, width: 486, height: 515);
  static final Sprite redKing =
      solitaireSprite(x: 1305, y: 532, width: 407, height: 549);

  static final blueFilter = Paint()
    ..colorFilter = const ColorFilter.mode(
      Color(0x880d8bff),
      BlendMode.srcATop,
    );
  static final Sprite blackJack =
      solitaireSprite(x: 81, y: 565, width: 562, height: 488)
        ..paint = blueFilter;
  static final Sprite blackQueen =
      solitaireSprite(x: 717, y: 541, width: 486, height: 515)
        ..paint = blueFilter;
  static final Sprite blackKing =
      solitaireSprite(x: 1305, y: 532, width: 407, height: 549)
        ..paint = blueFilter;

  void _renderFront(Canvas canvas) {
    canvas.drawRRect(cardRRect, frontBackgroundPaint);
    canvas.drawRRect(cardRRect, suit.isRed ? redBorderPaint : blackBorderPaint);

    final rankSprite = suit.isBlack ? rank.blackSprite : rank.redSprite;
    final suitSprite = suit.sprite;

    _drawSprite(
        canvas: canvas, sprite: rankSprite, relativeX: 0.1, relativeY: 0.08);
    _drawSprite(
        canvas: canvas,
        sprite: rankSprite,
        relativeX: 0.1,
        relativeY: 0.08,
        rotate: true);
    _drawSprite(
        canvas: canvas,
        sprite: suitSprite,
        relativeX: 0.1,
        relativeY: 0.18,
        scale: 0.5);
    _drawSprite(
        canvas: canvas,
        sprite: suitSprite,
        relativeX: 0.1,
        relativeY: 0.18,
        scale: 0.5,
        rotate: true);

    switch (rank.value) {
      case 1:
        _drawSprite(
            canvas: canvas,
            sprite: suitSprite,
            relativeX: 0.5,
            relativeY: 0.5,
            scale: 2.5);
      case 2:
        _drawSprite(
            canvas: canvas,
            sprite: suitSprite,
            relativeX: 0.5,
            relativeY: 0.25);
        _drawSprite(
            canvas: canvas,
            sprite: suitSprite,
            relativeX: 0.5,
            relativeY: 0.25,
            rotate: true);
      case 3:
        _drawSprite(
            canvas: canvas, sprite: suitSprite, relativeX: 0.5, relativeY: 0.2);
        _drawSprite(
            canvas: canvas, sprite: suitSprite, relativeX: 0.5, relativeY: 0.5);
        _drawSprite(
            canvas: canvas,
            sprite: suitSprite,
            relativeX: 0.5,
            relativeY: 0.2,
            rotate: true);
      case 4:
        _drawSprite(
            canvas: canvas,
            sprite: suitSprite,
            relativeX: 0.3,
            relativeY: 0.25);
        _drawSprite(
            canvas: canvas,
            sprite: suitSprite,
            relativeX: 0.7,
            relativeY: 0.25);
        _drawSprite(
            canvas: canvas,
            sprite: suitSprite,
            relativeX: 0.3,
            relativeY: 0.25,
            rotate: true);
        _drawSprite(
            canvas: canvas,
            sprite: suitSprite,
            relativeX: 0.7,
            relativeY: 0.25,
            rotate: true);
      case 5:
        _drawSprite(
            canvas: canvas,
            sprite: suitSprite,
            relativeX: 0.3,
            relativeY: 0.25);
        _drawSprite(
            canvas: canvas,
            sprite: suitSprite,
            relativeX: 0.7,
            relativeY: 0.25);
        _drawSprite(
            canvas: canvas,
            sprite: suitSprite,
            relativeX: 0.3,
            relativeY: 0.25,
            rotate: true);
        _drawSprite(
            canvas: canvas,
            sprite: suitSprite,
            relativeX: 0.7,
            relativeY: 0.25,
            rotate: true);
        _drawSprite(
            canvas: canvas, sprite: suitSprite, relativeX: 0.5, relativeY: 0.5);
      case 6:
        _drawSprite(
            canvas: canvas,
            sprite: suitSprite,
            relativeX: 0.3,
            relativeY: 0.25);
        _drawSprite(
            canvas: canvas,
            sprite: suitSprite,
            relativeX: 0.7,
            relativeY: 0.25);
        _drawSprite(
            canvas: canvas, sprite: suitSprite, relativeX: 0.3, relativeY: 0.5);
        _drawSprite(
            canvas: canvas, sprite: suitSprite, relativeX: 0.7, relativeY: 0.5);
        _drawSprite(
            canvas: canvas,
            sprite: suitSprite,
            relativeX: 0.3,
            relativeY: 0.25,
            rotate: true);
        _drawSprite(
            canvas: canvas,
            sprite: suitSprite,
            relativeX: 0.7,
            relativeY: 0.25,
            rotate: true);
      case 7:
        _drawSprite(
            canvas: canvas, sprite: suitSprite, relativeX: 0.3, relativeY: 0.2);
        _drawSprite(
            canvas: canvas, sprite: suitSprite, relativeX: 0.7, relativeY: 0.2);
        _drawSprite(
            canvas: canvas,
            sprite: suitSprite,
            relativeX: 0.5,
            relativeY: 0.35);
        _drawSprite(
            canvas: canvas, sprite: suitSprite, relativeX: 0.3, relativeY: 0.5);
        _drawSprite(
            canvas: canvas, sprite: suitSprite, relativeX: 0.7, relativeY: 0.5);
        _drawSprite(
            canvas: canvas,
            sprite: suitSprite,
            relativeX: 0.3,
            relativeY: 0.2,
            rotate: true);
        _drawSprite(
            canvas: canvas,
            sprite: suitSprite,
            relativeX: 0.7,
            relativeY: 0.2,
            rotate: true);
      case 8:
        _drawSprite(
            canvas: canvas, sprite: suitSprite, relativeX: 0.3, relativeY: 0.2);
        _drawSprite(
            canvas: canvas, sprite: suitSprite, relativeX: 0.7, relativeY: 0.2);
        _drawSprite(
            canvas: canvas,
            sprite: suitSprite,
            relativeX: 0.5,
            relativeY: 0.35);
        _drawSprite(
            canvas: canvas, sprite: suitSprite, relativeX: 0.3, relativeY: 0.5);
        _drawSprite(
            canvas: canvas, sprite: suitSprite, relativeX: 0.7, relativeY: 0.5);
        _drawSprite(
            canvas: canvas,
            sprite: suitSprite,
            relativeX: 0.3,
            relativeY: 0.2,
            rotate: true);
        _drawSprite(
            canvas: canvas,
            sprite: suitSprite,
            relativeX: 0.7,
            relativeY: 0.2,
            rotate: true);
        _drawSprite(
            canvas: canvas,
            sprite: suitSprite,
            relativeX: 0.5,
            relativeY: 0.35,
            rotate: true);
      case 9:
        _drawSprite(
            canvas: canvas, sprite: suitSprite, relativeX: 0.3, relativeY: 0.2);
        _drawSprite(
            canvas: canvas, sprite: suitSprite, relativeX: 0.7, relativeY: 0.2);
        _drawSprite(
            canvas: canvas, sprite: suitSprite, relativeX: 0.5, relativeY: 0.3);
        _drawSprite(
            canvas: canvas, sprite: suitSprite, relativeX: 0.3, relativeY: 0.4);
        _drawSprite(
            canvas: canvas, sprite: suitSprite, relativeX: 0.7, relativeY: 0.4);
        _drawSprite(
            canvas: canvas,
            sprite: suitSprite,
            relativeX: 0.3,
            relativeY: 0.2,
            rotate: true);
        _drawSprite(
            canvas: canvas,
            sprite: suitSprite,
            relativeX: 0.7,
            relativeY: 0.2,
            rotate: true);
        _drawSprite(
            canvas: canvas,
            sprite: suitSprite,
            relativeX: 0.3,
            relativeY: 0.4,
            rotate: true);
        _drawSprite(
            canvas: canvas,
            sprite: suitSprite,
            relativeX: 0.7,
            relativeY: 0.4,
            rotate: true);
      case 10:
        _drawSprite(
            canvas: canvas, sprite: suitSprite, relativeX: 0.3, relativeY: 0.2);
        _drawSprite(
            canvas: canvas, sprite: suitSprite, relativeX: 0.7, relativeY: 0.2);
        _drawSprite(
            canvas: canvas, sprite: suitSprite, relativeX: 0.5, relativeY: 0.3);
        _drawSprite(
            canvas: canvas, sprite: suitSprite, relativeX: 0.3, relativeY: 0.4);
        _drawSprite(
            canvas: canvas, sprite: suitSprite, relativeX: 0.7, relativeY: 0.4);
        _drawSprite(
            canvas: canvas,
            sprite: suitSprite,
            relativeX: 0.3,
            relativeY: 0.2,
            rotate: true);
        _drawSprite(
            canvas: canvas,
            sprite: suitSprite,
            relativeX: 0.7,
            relativeY: 0.2,
            rotate: true);
        _drawSprite(
            canvas: canvas,
            sprite: suitSprite,
            relativeX: 0.5,
            relativeY: 0.3,
            rotate: true);
        _drawSprite(
            canvas: canvas,
            sprite: suitSprite,
            relativeX: 0.3,
            relativeY: 0.4,
            rotate: true);
        _drawSprite(
            canvas: canvas,
            sprite: suitSprite,
            relativeX: 0.7,
            relativeY: 0.4,
            rotate: true);
      case 11:
        _drawSprite(
            canvas: canvas,
            sprite: suit.isRed ? redJack : blackJack,
            relativeX: 0.5,
            relativeY: 0.5);
      case 12:
        _drawSprite(
            canvas: canvas,
            sprite: suit.isRed ? redQueen : blackQueen,
            relativeX: 0.5,
            relativeY: 0.5);
      case 13:
        _drawSprite(
            canvas: canvas,
            sprite: suit.isRed ? redKing : blackKing,
            relativeX: 0.5,
            relativeY: 0.5);
    }
  }

  void _renderBack(Canvas canvas) {
    canvas.drawRRect(cardRRect, backBackgroundPaint);
    canvas.drawRRect(cardRRect, backBorderPaint1);
    canvas.drawRRect(backRRectInner, backBorderPaint2);
    flameSprite.render(canvas, position: size / 2, anchor: Anchor.center);
  }

  void _drawSprite({
    required Canvas canvas,
    required Sprite sprite,
    required double relativeX,
    required double relativeY,
    double scale = 1,
    bool rotate = false,
  }) {
    if (rotate) {
      canvas.save();
      canvas.translate(
        size.x / 2,
        size.y / 2,
      );
      canvas.rotate(pi);
      canvas.translate(-size.x / 2, -size.y / 2);
    }

    sprite.render(canvas,
        position: Vector2(relativeX * size.x, relativeY * size.y),
        anchor: Anchor.center,
        size: sprite.srcSize.scaled(scale));

    if (rotate) {
      canvas.restore();
    }
  }

  @override
  void onDragStart(DragStartEvent event) {
    if (pile?.canMoveCard(this) ?? false) {
      super.onDragStart(event);
      priority = 100;
    }
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (!isDragged) {
      return;
    }
    position += event.localDelta;
  }

  @override
  void onDragEnd(DragEndEvent event) {
    if (!isDragged) {
      return;
    }

    super.onDragEnd(event);
    final dropPiles = parent!
        .componentsAtPoint(position + size / 2)
        .whereType<Pile>()
        .toList();


    if (dropPiles.isNotEmpty) {

      if(dropPiles.first.canAcceptCard(this)){
        pile!.removeCard(this);
        dropPiles.first.acquireCard(this);
        return;
      }
    }
    pile!.returnCard(this);
  }
}
