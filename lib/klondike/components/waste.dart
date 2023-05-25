import 'package:flame/components.dart';

import '../klondike.dart';
import 'card.dart';
import 'pile.dart';

final class Waste extends Pile {
  Waste({super.position});

  final Vector2 _fanOffset = Vector2(Klondike.cardWidth * 0.2, 0);

  @override
  void acquireCard(Card card) {
    assert(card.isFaceUp);
    card.pile = this;
    card.position = position;
    card.priority = cards.length;
    cards.add(card);
  }

  void _fanOutTopCards() {
    final n = cards.length;
    for (var i = 0; i < n; i++) {
      cards[i].position = position;
    }
    if (n == 2) {
      cards[1].position.add(_fanOffset);
    } else if (n >= 3) {
      cards[n - 2].position.add(_fanOffset);
      cards[n - 1].position.addScaled(_fanOffset, 2);
    }
  }

  List<Card> removeAllCards() {
    final ret = cards.toList();
    cards.clear();
    return ret;
  }

  @override
  bool canMoveCard(Card card) => cards.isNotEmpty && card == cards.last;

  @override
  bool canAcceptCard(Card card) => false;

  @override
  void removeCard(Card card) {
    assert(canMoveCard(card));
    cards.removeLast();
    _fanOutTopCards();
  }

  @override
  void returnCard(Card card) {
    card.priority = cards.indexOf(card);
    _fanOutTopCards();
  }
}
