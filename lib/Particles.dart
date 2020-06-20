import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:samehomediffhacks/Models/Particle.dart';
import 'package:samehomediffhacks/ParticlePainter.dart';
import 'dart:math';

class Particles extends StatefulWidget {
  final int numberOfParticles;
  final String text;
  final VoidCallback onFinished;

  Particles(this.numberOfParticles, this.text, this.onFinished);

  @override
  _ParticlesState createState() => _ParticlesState();
}

class _ParticlesState extends State<Particles> {
  final Random random = Random();

  final List<Particle> particles = [];

  @override
  void initState() {
    print("Particles: ${widget.numberOfParticles} ${widget.text}");
    List.generate(widget.numberOfParticles, (index) {
      particles.add(Particle(random, widget.text));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LoopAnimation<int>(
      tween: ConstantTween(1),
      builder: (context, time, i) {
        _countParticles();
        return CustomPaint(
          painter: ParticlePainter(particles),
        );
      },
    );
  }

  _countParticles() {
    DateTime now = DateTime.now();
    int finished = 0;
    particles.forEach((particle) { if (particle.progress(now) == 1) finished += 1;  });
    if(finished == particles.length) {
      widget.onFinished();
    }
    // particles.forEach((particle) => particle.maintainRestart(DateTime.now()));
  }
}