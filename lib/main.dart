import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'klondike/klondike.dart';

void main() {
  final klondike = Klondike();
  runApp(GameWidget(game: klondike));
}
