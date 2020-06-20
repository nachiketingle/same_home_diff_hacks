import 'package:samehomediffhacks/Models/Particle.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:flutter/material.dart';

class ParticlePainter extends CustomPainter {
  List<Particle> particles;

  ParticlePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    particles.forEach((particle) {
      // create the text to renderer
      final textStyle = TextStyle(
        fontSize: 30,
      );
      final textSpan = TextSpan(
        text: particle.text,
        style: textStyle,
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout(
        minWidth: 0,
        maxWidth: size.width,
      );
      // get the progress value
      var progress = particle.progress(DateTime.now());
      // animate to given progress
      final animation = particle.tween.transform(progress);
      // get the offset position
      final position =
          Offset(animation.get(DefaultAnimationProperties.x) * size.width, animation.get(DefaultAnimationProperties.y) * size.height);
      // paint it
      textPainter.paint(canvas, position);
    });
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
