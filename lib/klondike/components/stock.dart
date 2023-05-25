import 'dart:ui';

import 'package:flame/experimental.dart';

import '../klondike.dart';
import 'card.dart';
import 'pile.dart';
import 'waste.dart';

final class Stock extends Pile with TapCallbacks {
  final _borderPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 10
    ..color = const Color(0xFF3F5B5D);
  final _circlePaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 100
    ..color = const Color(0x883F5B5D);

  Stock({super.position});

  @override
  void acquireCard(Card card) {
    assert(!card.isFaceUp);
    card.pile = this;
    card.position = position;
    card.priority = cards.length;
    cards.add(card);
  }

  @override
  void onTapUp(TapUpEvent event) {
    final wastePile = parent!.firstChild<Waste>()!;
    if (cards.isEmpty) {
      wastePile.removeAllCards().reversed.forEach((card) {
        card.flip();
        acquireCard(card);
      });
    } else {
      for (var i = 0; i < 3; i++) {
        if (cards.isNotEmpty) {
          final card = cards.removeLast();
          card.flip();
          wastePile.acquireCard(card);
        }
      }
    }
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(Klondike.cardRRect, _borderPaint);
    canvas.drawCircle(
      Offset(width / 2, height / 2),
      Klondike.cardWidth * 0.3,
      _circlePaint,
    );
  }

  @override
  bool canMoveCard(Card card) => false;

  @override
  bool canAcceptCard(Card card) => false;

  @override
  void removeCard(Card card) =>
      throw StateError('cannot remove cards from here');

  @override
  void returnCard(Card card) =>
      throw StateError('cannot remove cards from here');
}
