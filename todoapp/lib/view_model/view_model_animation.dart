import 'package:flutter/material.dart';

class ViewModelAnimation extends ChangeNotifier {
  final List<AnimationController> _controllers = [];
  final List<Animation<double>> _animations = [];

  List<AnimationController> get controllers => _controllers;
  List<Animation<double>> get animations => _animations;

  void initializeAnimation(TickerProvider vsync, int cardCount) {
    for (int i = 0; i < cardCount; i++) {
      final controller = AnimationController(
        duration: const Duration(milliseconds: 500),
        vsync: vsync,
      );

      final animation = Tween(begin: -5.0, end: 5.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.elasticIn),
      );

      _controllers.add(controller);
      _animations.add(animation);

      controller.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        }
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void shakeCard(int index) {
    if (_controllers[index].isAnimating) {
      _controllers[index].stop();
    }
    _controllers[index].forward();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
