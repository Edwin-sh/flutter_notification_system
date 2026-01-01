import 'package:flutter/material.dart';

/// Utilidades para animaciones de notificaciones
class NotificationAnimations {
  /// Duración por defecto de las animaciones
  static const Duration defaultDuration = Duration(milliseconds: 300);

  /// Curva de animación por defecto
  static const Curve defaultCurve = Curves.easeInOut;

  /// Animación de entrada desde arriba
  static SlideTransition slideFromTop(
    Animation<double> animation,
    Widget child,
  ) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, -1),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: defaultCurve)),
      child: child,
    );
  }

  /// Animación de entrada desde abajo
  static SlideTransition slideFromBottom(
    Animation<double> animation,
    Widget child,
  ) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: defaultCurve)),
      child: child,
    );
  }

  /// Animación de fade in
  static FadeTransition fadeIn(Animation<double> animation, Widget child) {
    return FadeTransition(opacity: animation, child: child);
  }

  /// Animación de escala
  static ScaleTransition scale(Animation<double> animation, Widget child) {
    return ScaleTransition(
      scale: CurvedAnimation(parent: animation, curve: Curves.elasticOut),
      child: child,
    );
  }

  /// Animación combinada: slide + fade
  static Widget slideAndFade(
    Animation<double> animation,
    Widget child, {
    bool fromTop = true,
  }) {
    final slideAnimation = Tween<Offset>(
      begin: fromTop ? const Offset(0, -1) : const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: animation, curve: defaultCurve));

    return SlideTransition(
      position: slideAnimation,
      child: FadeTransition(opacity: animation, child: child),
    );
  }

  /// Animación de rebote
  static Widget bounce(Animation<double> animation, Widget child) {
    return ScaleTransition(
      scale: CurvedAnimation(parent: animation, curve: Curves.bounceOut),
      child: child,
    );
  }

  /// Animación personalizada con múltiples efectos
  static Widget custom({
    required Animation<double> animation,
    required Widget child,
    bool fade = true,
    bool slide = true,
    bool scale = false,
    bool fromTop = true,
    Curve curve = defaultCurve,
  }) {
    Widget result = child;

    if (scale) {
      result = ScaleTransition(
        scale: CurvedAnimation(parent: animation, curve: curve),
        child: result,
      );
    }

    if (slide) {
      result = SlideTransition(
        position: Tween<Offset>(
          begin: fromTop ? const Offset(0, -0.5) : const Offset(0, 0.5),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: curve)),
        child: result,
      );
    }

    if (fade) {
      result = FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: curve),
        child: result,
      );
    }

    return result;
  }
}
