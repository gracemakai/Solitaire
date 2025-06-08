import 'package:flame/components.dart';
import 'package:solitaire/rank.dart';
import 'package:solitaire/solitaire_game.dart';
import 'package:solitaire/suit.dart';

class Card extends PositionComponent {
  final Rank rank;
  final Suit suit;
  bool _faceUp;

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
}
