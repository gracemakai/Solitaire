import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/palette.dart';
import 'package:flame/text.dart';

import 'components/card.dart';
import 'components/foundation_pile.dart';
import 'components/stock_pile.dart';
import 'components/tableau_pile.dart';
import 'components/waste_pile.dart';
import 'solitaire_game.dart';

class SolitaireWorld extends World with HasGameReference<SolitaireGame> {
  final cardGap = SolitaireGame.cardGap;
  final topGap = SolitaireGame.topGap;
  final cardSpaceWidth = SolitaireGame.cardSpaceWidth;
  final cardSpaceHeight = SolitaireGame.cardSpaceHeight;

  final stock = StockPile(position: Vector2(0.0, 0.0));
  final waste = WastePile(position: Vector2(0.0, 0.0));
  final List<FoundationPile> foundations = [];
  final List<TableauPile> tableauPiles = [];
  final List<Card> cards = [];
  late Vector2 playAreaSize;

  @override
  Future<void> onLoad() async {
    await Flame.images.load('sprites.png');

    stock.position = Vector2(cardGap, topGap);
    waste.position = Vector2(cardSpaceWidth + cardGap, topGap);

    for (var i = 0; i < 4; i++) {
      foundations.add(
        FoundationPile(
          i,
          checkWin,
          position: Vector2((i + 3) * cardSpaceWidth + cardGap, topGap),
        ),
      );
    }
    for (var i = 0; i < 7; i++) {
      tableauPiles.add(
        TableauPile(
          position: Vector2(
            cardGap + i * (cardSpaceWidth + cardGap),
            cardSpaceHeight + topGap,
          ),
        ),
      );
    }

    for (var rank = 1; rank <= 13; rank++) {
      for (var suit = 0; suit < 4; suit++) {
        final card = Card(intRank: rank, intSuit: suit);
        card.position = stock.position;
        cards.add(card);
      }
    }

    add(stock);
    add(waste);
    addAll(foundations);
    addAll(tableauPiles);
    addAll(cards);

    playAreaSize =
        Vector2(7 * (cardSpaceWidth + cardGap), 4 * (cardSpaceHeight + topGap));
    final gameMidX = playAreaSize.x / 2;

    addButton('New deal', gameMidX, Action.newDeal);
    addButton('Same deal', gameMidX + cardSpaceWidth, Action.sameDeal);
    addButton('Draw 1 or 3', gameMidX + 2 * cardSpaceWidth, Action.changeDraw);
    addButton('Have fun', gameMidX + 3 * cardSpaceWidth, Action.haveFun);

    final camera = game.camera;
    camera.viewfinder.visibleGameSize = playAreaSize;
    camera.viewfinder.position = Vector2(gameMidX, 0);
    camera.viewfinder.anchor = Anchor.topCenter;

    deal();
  }

  void deal() {
    assert(cards.length == 52,
        'There has to be 52 cards. Currently at ${cards.length}');

    if (game.action != Action.sameDeal) {
      game.seed = Random().nextInt(SolitaireGame.maxInt);
      if (game.action == Action.changeDraw) {
        game.solitaireDraw = (game.solitaireDraw == 3) ? 1 : 3;
      }
    }

    cards.shuffle(Random(game.seed));

    var dealPriority = 1;
    for (final card in cards) {
      card.priority = dealPriority++;
    }

    var cardToDeal = cards.length - 1;
    var nMovingCards = 0;
    for (var i = 0; i < 7; i++) {
      for (var j = i; j < 7; j++) {
        final card = cards[cardToDeal--];
        card.doMove(tableauPiles[j].position, speed: 15.0, start: nMovingCards * 0.15,
            onComplete: () {
          tableauPiles[j].acquireCard(card);
          nMovingCards--;

          if (nMovingCards == 0) {
            var delayFactor = 0;

            for (final tableauPile in tableauPiles) {
              delayFactor++;
              tableauPile.flipTopCard(start: delayFactor * 0.15);
            }
          }
        });
        nMovingCards++;
      }
    }
    for (var n = 0; n <= cardToDeal; n++) {
      stock.acquireCard(cards[n]);
    }
  }

  void addButton(String label, double buttonX, Action action) {
    final buttonSize = Vector2(SolitaireGame.cardWidth + 10, 0.6 * topGap);

    final button = AdvancedButtonComponent(
      children: [
        TextComponent(
            text: label,
            textRenderer: TextPaint(
              style: const TextStyle(
                fontSize: 150,
                color: Color.fromRGBO(0, 0, 0, 1.0),
              ),
            ),
            anchor: Anchor.center,
            position: buttonSize / 2,
            priority: 1)
      ],
      // label,
      size: buttonSize,
      position: Vector2(buttonX, topGap / 5),
      defaultSkin: RoundedRectComponent()
        ..setColor(const Color.fromRGBO(0, 255, 0, 1)),
      onReleased: () {
        if (action == Action.haveFun) {
          // Shortcut to the "win" sequence, for Tutorial purposes only.
          letsCelebrate();
        } else {
          // Restart with a new deal or the same deal as before.
          game.action = action;
          game.world = SolitaireWorld();
        }
      },
    );
    add(button);
  }

  void checkWin() {
    var nCompleted = 0;
    for (final foundation in foundations) {
      if (foundation.isFull) {
        nCompleted++;
      }
    }
    if (nCompleted == foundations.length) {
      // All foundations are full, the game is won.
      letsCelebrate();
    }
  }

  void letsCelebrate({int phase = 1}) {
    // Deal won: bring all cards to the middle of the screen (phase 1)
    // then scatter them to points just outside the screen (phase 2).
    //
    // First get the device's screen-size in game co-ordinates, then get the
    // top-left of the off-screen area that will accept the scattered cards.
    // Note: The play area is anchored at TopCenter, so topLeft.y is fixed.

    final cameraZoom = game.camera.viewfinder.zoom;
    final zoomedScreen = game.size / cameraZoom;
    final screenCenter = (playAreaSize - SolitaireGame.cardSize) / 2;
    final topLeft = Vector2(
      (playAreaSize.x - zoomedScreen.x) / 2 - SolitaireGame.cardWidth,
      -SolitaireGame.cardHeight,
    );
    final nCards = cards.length;
    final offscreenHeight = zoomedScreen.y + SolitaireGame.cardSize.y;
    final offscreenWidth = zoomedScreen.x + SolitaireGame.cardSize.x;
    final spacing = 2.0 * (offscreenHeight + offscreenWidth) / nCards;

    // Starting points, directions and lengths of offscreen rect's sides.
    final corner = [
      Vector2(0.0, 0.0),
      Vector2(0.0, offscreenHeight),
      Vector2(offscreenWidth, offscreenHeight),
      Vector2(offscreenWidth, 0.0),
    ];
    final direction = [
      Vector2(0.0, 1.0),
      Vector2(1.0, 0.0),
      Vector2(0.0, -1.0),
      Vector2(-1.0, 0.0),
    ];
    final length = [
      offscreenHeight,
      offscreenWidth,
      offscreenHeight,
      offscreenWidth,
    ];

    var side = 0;
    var cardsToMove = nCards;
    var offScreenPosition = corner[side] + topLeft;
    var space = length[side];
    var cardNum = 0;

    while (cardNum < nCards) {
      final cardIndex = phase == 1 ? cardNum : nCards - cardNum - 1;
      final card = cards[cardIndex];
      card.priority = cardIndex + 1;
      if (card.isFaceDown) {
        card.flip();
      }
      // Start cards a short time apart to give a riffle effect.
      final delay = phase == 1 ? cardNum * 0.02 : 0.5 + cardNum * 0.04;
      final destination = (phase == 1) ? screenCenter : offScreenPosition;
      card.doMove(
        destination,
        speed: (phase == 1) ? 15.0 : 5.0,
        start: delay,
        onComplete: () {
          cardsToMove--;
          if (cardsToMove == 0) {
            if (phase == 1) {
              letsCelebrate(phase: 2);
            } else {
              // Restart with a new deal after winning or pressing "Have fun".
              game.action = Action.newDeal;
              game.world = SolitaireWorld();
            }
          }
        },
      );
      cardNum++;
      if (phase == 1) {
        continue;
      }

      // Phase 2: next card goes to same side with full spacing, if possible.
      offScreenPosition = offScreenPosition + direction[side] * spacing;
      space = space - spacing;
      if ((space < 0.0) && (side < 3)) {
        // Out of space: change to the next side and use excess spacing there.
        side++;
        offScreenPosition = corner[side] + topLeft - direction[side] * space;
        space = length[side] + space;
      }
    }
  }
}

class RoundedRectComponent extends PositionComponent with HasPaint {
  @override
  void render(Canvas canvas) {
    canvas.drawRRect(
      RRect.fromLTRBAndCorners(
        0,
        0,
        width,
        height,
        topLeft: Radius.circular(height),
        topRight: Radius.circular(height),
        bottomRight: Radius.circular(height),
        bottomLeft: Radius.circular(height),
      ),
      paint,
    );
  }
}
