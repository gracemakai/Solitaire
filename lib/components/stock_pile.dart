import 'package:flame/components.dart';

import 'card.dart';

class StockPile extends PositionComponent {

  @override
  bool get debugMode => true;

  final List<Card> _cards = [];

  void acquireCard(Card card){
    assert(!card.isFaceUp);

    card.position = position;
    card.priority = _cards.length;
    _cards.add(card);
  }
}