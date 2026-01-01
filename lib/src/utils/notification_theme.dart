import 'package:flutter/material.dart';
import '../models/notification_type.dart';

/// Tema visual para las notificaciones
///
/// Define colores, estilos de texto y otros aspectos visuales
/// para cada tipo de notificación.
class NotificationTheme {
  /// Color para notificaciones de éxito
  final Color successColor;

  /// Color para notificaciones de información
  final Color infoColor;

  /// Color para notificaciones de advertencia
  final Color warningColor;

  /// Color para notificaciones de error
  final Color errorColor;

  /// Color de fondo para SnackBar
  final Color? backgroundColor;

  /// Color del texto
  final Color textColor;

  /// Estilo del texto del mensaje
  final TextStyle? messageStyle;

  /// Estilo del texto del título
  final TextStyle? titleStyle;

  /// Radio de borde
  final double borderRadius;

  /// Elevación de la sombra
  final double elevation;

  /// Padding interno
  final EdgeInsets padding;

  /// Opacidad del fondo
  final double backgroundOpacity;

  const NotificationTheme({
    this.successColor = const Color(0xFF4CAF50),
    this.infoColor = const Color(0xFF2196F3),
    this.warningColor = const Color(0xFFFF9800),
    this.errorColor = const Color(0xFFF44336),
    this.backgroundColor,
    this.textColor = Colors.white,
    this.messageStyle,
    this.titleStyle,
    this.borderRadius = 8.0,
    this.elevation = 6.0,
    this.padding = const EdgeInsets.all(16.0),
    this.backgroundOpacity = 1.0,
  });

  /// Tema claro por defecto
  static const NotificationTheme light = NotificationTheme();

  /// Tema oscuro
  static const NotificationTheme dark = NotificationTheme(
    successColor: Color(0xFF66BB6A),
    infoColor: Color(0xFF42A5F5),
    warningColor: Color(0xFFFFB74D),
    errorColor: Color(0xFFEF5350),
    textColor: Colors.white,
  );

  /// Tema global actual (puede ser sobrescrito)
  static NotificationTheme current = light;

  /// Obtiene el color apropiado según el tipo de notificación
  Color getColorForType(NotificationTypeEnum type) {
    switch (type) {
      case NotificationTypeEnum.success:
        return successColor;
      case NotificationTypeEnum.info:
        return infoColor;
      case NotificationTypeEnum.warning:
        return warningColor;
      case NotificationTypeEnum.error:
        return errorColor;
    }
  }

  /// Obtiene el icono apropiado según el tipo de notificación
  IconData getIconForType(NotificationTypeEnum type) {
    switch (type) {
      case NotificationTypeEnum.success:
        return Icons.check_circle;
      case NotificationTypeEnum.info:
        return Icons.info;
      case NotificationTypeEnum.warning:
        return Icons.warning;
      case NotificationTypeEnum.error:
        return Icons.error;
    }
  }

  /// Crea una copia del tema con los valores especificados modificados
  NotificationTheme copyWith({
    Color? successColor,
    Color? infoColor,
    Color? warningColor,
    Color? errorColor,
    Color? backgroundColor,
    Color? textColor,
    TextStyle? messageStyle,
    TextStyle? titleStyle,
    double? borderRadius,
    double? elevation,
    EdgeInsets? padding,
    double? backgroundOpacity,
  }) {
    return NotificationTheme(
      successColor: successColor ?? this.successColor,
      infoColor: infoColor ?? this.infoColor,
      warningColor: warningColor ?? this.warningColor,
      errorColor: errorColor ?? this.errorColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textColor: textColor ?? this.textColor,
      messageStyle: messageStyle ?? this.messageStyle,
      titleStyle: titleStyle ?? this.titleStyle,
      borderRadius: borderRadius ?? this.borderRadius,
      elevation: elevation ?? this.elevation,
      padding: padding ?? this.padding,
      backgroundOpacity: backgroundOpacity ?? this.backgroundOpacity,
    );
  }
}
