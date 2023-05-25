import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';

import '../klondike.dart';
import '../model/suit.dart';
import 'card.dart';
import 'pile.dart';

final class Foundation extends Pile {
  final Suit suit;

  final _borderPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 10
    ..color = const Color(0x50ffffff);
  late final _suitPaint = Paint()
    ..color = suit.isRed ? const Color(0x3a000000) : const Color(0x64000000)
    ..blendMode = BlendMode.luminosity;

  Foundation(int suit, {super.position}) : suit = Suit.fromInt(suit);

  @override
  void acquireCard(Card card) {
    assert(card.isFaceUp);
    card.pile = this;
    card.position = position;
    card.priority = cards.length;
    cards.add(card);
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(Klondike.cardRRect, _borderPaint);
    suit.sprite.render(
      canvas,
      position: size / 2,
      anchor: Anchor.center,
      size: Vector2.all(Klondike.cardWidth * 0.6),
      overridePaint: _suitPaint,
    );
  }

  @override
  bool canMoveCard(Card card) => cards.isNotEmpty && card == cards.last;

  @override
  bool canAcceptCard(Card card) {
    final topCardRank = cards.isEmpty ? 0 : cards.last.rank.value;
    return card.suit == suit &&
        card.rank.value == topCardRank + 1 &&
        card.attachedCards.isEmpty;
  }

  @override
  void removeCard(Card card) {
    assert(canMoveCard(card));
    cards.removeLast();
  }

  @override
  void returnCard(Card card) {
    card.position = position;
    card.priority = cards.indexOf(card);
  }
}
