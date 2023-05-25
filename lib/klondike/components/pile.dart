import 'package:flame/components.dart';

import '../klondike.dart';
import 'card.dart';

abstract class Pile extends PositionComponent {
  /// Which cards are currently placed onto this pile. The first card in the
  /// list is at the bottom, the last card is on top.
  final List<Card> cards = [];

  Pile({super.position}) : super(size: Klondike.cardSize);

  bool canMoveCard(Card card);

  bool canAcceptCard(Card card);

  void acquireCard(Card card);

  void removeCard(Card card);

  void returnCard(Card card);
}
