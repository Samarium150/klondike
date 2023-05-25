import 'dart:ui';

import 'package:flame/components.dart';

import '../klondike.dart';
import 'card.dart';
import 'pile.dart';

final class Tableau extends Pile {
  final _borderPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 10
    ..color = const Color(0x50ffffff);

  final Vector2 _fanOffset = Vector2(0, Klondike.cardHeight * 0.05);
  final Vector2 _fanOffset1 = Vector2(0, Klondike.cardHeight * 0.05);
  final Vector2 _fanOffset2 = Vector2(0, Klondike.cardHeight * 0.20);

  Tableau({super.position});

  @override
  void acquireCard(Card card) {
    card.pile = this;
    if (cards.isEmpty) {
      card.position = position;
    } else {
      card.position = cards.last.position + _fanOffset;
    }
    card.priority = cards.length;
    cards.add(card);
  }

  void flipTopCard() {
    assert(cards.last.isFaceDown);
    cards.last.flip();
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(Klondike.cardRRect, _borderPaint);
  }

  @override
  bool canMoveCard(Card card) => card.isFaceUp;

  @override
  bool canAcceptCard(Card card) {
    if (cards.isEmpty) {
      return card.rank.value == 13;
    } else {
      final topCard = cards.last;
      return card.suit.isRed == !topCard.suit.isRed &&
          card.rank.value == topCard.rank.value - 1;
    }
  }

  @override
  void removeCard(Card card) {
    assert(cards.contains(card) && card.isFaceUp);
    final index = cards.indexOf(card);
    cards.removeRange(index, cards.length);
    if (cards.isNotEmpty && cards.last.isFaceDown) {
      flipTopCard();
    }
  }

  @override
  void returnCard(Card card) {
    final index = cards.indexOf(card);
    card.position =
        index == 0 ? position : cards[index - 1].position + _fanOffset;
    card.priority = index;
  }

  void layOutCards() {
    if (cards.isEmpty) {
      return;
    }
    cards[0].position.setFrom(position);
    for (var i = 1; i < cards.length; i++) {
      cards[i].position
        ..setFrom(cards[i - 1].position)
        ..add(cards[i - 1].isFaceDown ? _fanOffset1 : _fanOffset2);
    }
    height = Klondike.cardHeight * 1.5 + cards.last.y - cards.first.y;
  }

  List<Card> cardsOnTop(Card card) {
    assert(card.isFaceUp && cards.contains(card));
    final index = cards.indexOf(card);
    return cards.getRange(index + 1, cards.length).toList();
  }
}
