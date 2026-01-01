/// Enum que define los tipos de notificaciones disponibles en el sistema
enum NotificationTypeEnum {
  /// Notificación de éxito - indica que una operación se completó correctamente
  success,

  /// Notificación de información - proporciona información general al usuario
  info,

  /// Notificación de advertencia - alerta sobre situaciones que requieren atención
  warning,

  /// Notificación de error - indica que una operación falló
  error,
}

/// Extensión para obtener propiedades adicionales de cada tipo de notificación
extension NotificationTypeExtension on NotificationTypeEnum {
  /// Obtiene el emoji asociado al tipo de notificación
  String get emoji {
    switch (this) {
      case NotificationTypeEnum.success:
        return '✅';
      case NotificationTypeEnum.info:
        return 'ℹ️';
      case NotificationTypeEnum.warning:
        return '⚠️';
      case NotificationTypeEnum.error:
        return '❌';
    }
  }

  /// Obtiene el título por defecto según el tipo
  String get defaultTitle {
    switch (this) {
      case NotificationTypeEnum.success:
        return 'Éxito';
      case NotificationTypeEnum.info:
        return 'Información';
      case NotificationTypeEnum.warning:
        return 'Advertencia';
      case NotificationTypeEnum.error:
        return 'Error';
    }
  }

  /// Indica si este tipo de notificación es crítico
  bool get isCritical {
    return this == NotificationTypeEnum.error;
  }

  /// Indica si este tipo de notificación debe mostrarse en un dialog
  bool get shouldShowDialog {
    return this == NotificationTypeEnum.error;
  }
}
