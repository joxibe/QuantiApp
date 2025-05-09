import 'package:flutter/material.dart';

class AppAnimations {
  // Duraciones
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  
  // Curvas
  static const Curve defaultCurve = Curves.easeOutCubic;
  static const Curve bouncyCurve = Curves.elasticOut;
  static const Curve smoothCurve = Curves.easeInOutCubic;
  
  // Offsets para animaciones
  static const double defaultOffset = 32.0;
  static const double smallOffset = 16.0;
  
  // Escalas
  static const double pressedScale = 0.95;
  static const double hoverScale = 1.02;

  // Animaciones predefinidas
  static Animation<double> fadeIn(AnimationController controller) {
    return Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: smoothCurve,
    ));
  }

  static Animation<Offset> slideUp(AnimationController controller) {
    return Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: smoothCurve,
    ));
  }

  static Animation<double> scale(AnimationController controller) {
    return Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: bouncyCurve,
    ));
  }
} 