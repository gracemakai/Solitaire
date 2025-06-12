import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:solitaire/components/pile.dart';
import 'package:solitaire/components/tableau_pile.dart';
import 'package:solitaire/rank.dart';
import 'package:solitaire/solitaire_game.dart';
import 'package:solitaire/suit.dart';

class Card extends PositionComponent with DragCallbacks {
  final Rank rank;
  final Suit suit;
  bool _faceUp;
  Pile? pile;
  final List<Card> attachedCards = [];

  Card({required int intRank, required int intSuit})
      : rank = Rank.fromInt(intRank),
        suit = Suit.fromInt(intSuit),
        _faceUp = false,
        super(size: SolitaireGame.cardSize);

  bool _isDragging = false;
  Vector2 _whereCardStarted = Vector2(0, 0);
  bool _isAnimatedFlip = false;
  bool _isFaceUpView = false;

  bool get isFaceUp => _faceUp;
  bool get isFaceDown => !_faceUp;
  void flip() {
    if (_isAnimatedFlip) {
      _faceUp = _isFaceUpView;
    } else {
      _faceUp = !_faceUp;
      _isFaceUpView = _faceUp;
    }
  }

  @override
  String toString() => rank.label + suit.label;

  @override
  void render(Canvas canvas) {
    if (_isFaceUpView) {
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
  static final Sprite flameSprite = solitaireSprite(1367, 6, 357, 501);

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

  static final blueFilter = Paint()
    ..colorFilter = const ColorFilter.mode(
      Color(0x880d8bff),
      BlendMode.srcATop,
    );

  static final Sprite redJack = solitaireSprite(81, 565, 562, 488);
  static final Sprite redQueen = solitaireSprite(717, 541, 486, 515);
  static final Sprite redKing = solitaireSprite(1305, 532, 407, 549);
  static final Sprite blackJack = solitaireSprite(81, 565, 562, 488)
    ..paint = blueFilter;
  static final Sprite blackQueen = solitaireSprite(717, 541, 486, 515)
    ..paint = blueFilter;
  static final Sprite blackKing = solitaireSprite(1305, 532, 407, 549)
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
      canvas.translate(size.x / 2, size.y / 2);
      canvas.rotate(pi);
      canvas.translate(-size.x / 2, -size.y / 2);
    }
    sprite.render(
      canvas,
      position: Vector2(relativeX * size.x, relativeY * size.y),
      anchor: Anchor.center,
      size: sprite.srcSize.scaled(scale),
    );
    if (rotate) {
      canvas.restore();
    }
  }

  void doMove(
    Vector2 to, {
    double speed = 10,
    double start = 0,
    Curve curve = Curves.easeOutQuad,
    VoidCallback? onComplete,
  }) {
    assert(speed > 0);
    final dt = (to - position).length / (speed * size.x);

    assert(dt > 0);

    priority = 100;

    add(MoveToEffect(
        to, EffectController(duration: dt, startDelay: start, curve: curve),
        onComplete: () {
       onComplete?.call;
    }));
  }

  void doMoveAndFlip(
    Vector2 to, {
    double speed = 10,
    double start = 0,
    Curve curve = Curves.easeOutQuad,
    VoidCallback? onComplete,
  }) {
    assert(speed > 0);
    final dt = (to - position).length / (speed * size.x);

    assert(dt > 0);

    priority = 100;

    add(MoveToEffect(
        to, EffectController(duration: dt, startDelay: start, curve: curve),
        onComplete: () {
      turnFaceUp(onComplete: onComplete);
    }));
  }

  void turnFaceUp({
    double time = 0.3,
    double start = 0.0,
    VoidCallback? onComplete,
  }) {
    assert(_isFaceUpView == false, 'Card should be facing down before turning');
    assert(time > 0.0);

    _isAnimatedFlip = true;
    anchor = Anchor.topCenter;
    position += Vector2(width / 2, 0);
    priority = 100;

    add(ScaleEffect.to(
        Vector2(scale.x / 100, scale.y),
        EffectController(
            startDelay: start,
            curve: Curves.easeOutSine,
            duration: time / 2,
            onMax: () {
              _isFaceUpView = true;
            },
            reverseDuration: time / 2,
            onMin: () {
              _isAnimatedFlip = false;
              _faceUp = true;
              anchor = Anchor.topLeft;
              position -= Vector2(width / 2, 0);
            }), onComplete: () {
      onComplete?.call();
    }));
  }

  @override
  void onDragStart(DragStartEvent event) {
    if (pile?.canMoveCard(this) ?? false) {
      super.onDragStart(event);
      _isDragging = true;
      priority = 100;
      _whereCardStarted = Vector2(position.x, position.y);

      if (pile is TableauPile) {
        attachedCards.clear();
        final extraCards = (pile! as TableauPile).cardsOnTop(this);

        for (final card in extraCards) {
          card.priority = attachedCards.length + 101;
          attachedCards.add(card);
        }
      }
    }
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (!_isDragging) {
      return;
    }
    final delta = event.localDelta;
    position.add(delta);
    for (var card in attachedCards) {
      card.position.add(delta);
    }
  }

  @override
  void onDragEnd(DragEndEvent event) {
    if (!_isDragging) {
      return;
    }
    _isDragging = false;
    super.onDragEnd(event);
    final dropPiles = parent!
        .componentsAtPoint(position + size / 2)
        .whereType<Pile>()
        .toList();

    if (dropPiles.isNotEmpty) {
      if (dropPiles.first.canAcceptCard(this)) {
        pile!.removeCard(this);
        dropPiles.first.acquireCard(this);

        if (attachedCards.isNotEmpty) {
          for (var card in attachedCards) {
            dropPiles.first.acquireCard(card);
          }
          attachedCards.clear();
        }
        return;
      }
    }

    doMove(_whereCardStarted, onComplete: () {
      pile!.returnCard(this);
    });

    if (attachedCards.isNotEmpty) {
      for (var card in attachedCards) {
        final offset = card.position - position;
        card.doMove(_whereCardStarted + offset, onComplete: () {
          pile!.returnCard(card);
        });
      }
      attachedCards.clear();
    }
  }
}
