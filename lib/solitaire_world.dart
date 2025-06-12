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

    var cardToDeal = cards.length - 1;
    var nMovingCards = 0;

    for (var i = 0; i < 7; i++) {
      for (var j = i; j < 7; j++) {
        final card = cards[cardToDeal--];
        card.doMove(tableauPiles[i].position, start: nMovingCards * 0.15,
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
          position: Vector2(buttonX / 12, topGap / 3),priority: 1
        )
      ],
      // label,
      size: Vector2(SolitaireGame.cardWidth, 0.6 * topGap),
      position: Vector2(buttonX, topGap / 2),
      defaultSkin: RoundedRectComponent()
        ..setColor(const Color.fromRGBO(0, 255, 0, 1)),
      onReleased: () {
        if (action == Action.haveFun) {
          // Shortcut to the "win" sequence, for Tutorial purposes only.
          // letsCelebrate();
        } else {
          // Restart with a new deal or the same deal as before.
          game.action = action;
          game.world = SolitaireWorld();
        }
      },
    );
    add(button);
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
