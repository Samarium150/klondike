import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';

import 'components/card.dart';
import 'components/foundation.dart';
import 'components/stock.dart';
import 'components/tableau.dart';
import 'components/waste.dart';

final class Klondike extends FlameGame {
  static const double cardWidth = 1000.0;
  static const double cardHeight = 1400.0;
  static const double cardGap = 175.0;
  static const double cardRadius = 100.0;
  static final Vector2 cardSize = Vector2(cardWidth, cardHeight);
  static final cardRRect = RRect.fromRectAndRadius(
    const Rect.fromLTWH(0, 0, cardWidth, cardHeight),
    const Radius.circular(cardRadius),
  );

  @override
  Future<void> onLoad() async {
    await Flame.images.load('klondike-sprites.png');
    final stock = Stock()
      ..size = cardSize
      ..position = Vector2(cardGap, cardGap);
    final waste = Waste()
      ..size = cardSize
      ..position = Vector2(cardWidth + 2 * cardGap, cardGap);
    final foundations = List.generate(
      4,
      (i) => Foundation(i)
        ..size = cardSize
        ..position =
            Vector2((i + 3) * (cardWidth + cardGap) + cardGap, cardGap),
    );
    final piles = List.generate(
      7,
      (i) => Tableau()
        ..size = cardSize
        ..position = Vector2(
          cardGap + i * (cardWidth + cardGap),
          cardHeight + 2 * cardGap,
        ),
    );

    final world = World()
      ..add(stock)
      ..add(waste)
      ..addAll(foundations)
      ..addAll(piles);
    add(world);

    final camera = CameraComponent.withFixedResolution(
      world: world,
      width: cardWidth * 7 + cardGap * 8,
      height: 4 * cardHeight + 3 * cardGap,
    )
      ..viewfinder.position = Vector2(cardWidth * 3.5 + cardGap * 4, 0)
      ..viewfinder.anchor = Anchor.topCenter;
    add(camera);

    final cards = [
      for (var rank = 1; rank <= 13; rank++)
        for (var suit = 0; suit < 4; suit++) Card(rank, suit)
    ];
    cards.shuffle();
    world.addAll(cards);

    for (var i = 0; i < 7; i++) {
      for (var j = i; j < 7; j++) {
        piles[j].acquireCard(cards.removeLast());
      }
      piles[i].flipTopCard();
    }
    cards.forEach(stock.acquireCard);
  }
}
