import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'dart:math';

class Particle {
  Animatable tween;
  double size;
  Random random;
  DateTime start;
  int duration;
  String text;

  Particle(this.random, this.text) {
    start = DateTime.now();
    restart();
  }

  double progress(DateTime time) {
    return ((time.difference(start)).inMilliseconds / duration)
        .clamp(0.0, 1.0)
        .toDouble();
  }

  restart() {
    // reset start
    start = DateTime.now();
    // random position
    final startPosition = Offset(-0.2 + 1.4 * random.nextDouble(), 1.2);
    final endPosition = Offset(-0.2 + 1.4 * random.nextDouble(), -0.2);
    // shorter duration => faster
    duration = 2000 + random.nextInt(1000);
    size = 1 + random.nextDouble() - .5;
    tween = MultiTween<DefaultAnimationProperties>()
      ..add(
          DefaultAnimationProperties.x,
          Tween(begin: startPosition.dx, end: endPosition.dx),
          Duration(milliseconds: duration),
          Curves.easeInOutSine)
      ..add(
          DefaultAnimationProperties.y,
          Tween(begin: startPosition.dy, end: endPosition.dy),
          Duration(milliseconds: duration),
          Curves.easeIn);
  }

  maintainRestart(DateTime time) {
    if (progress(time) == 1.0) {
      restart();
    }
  }
}
