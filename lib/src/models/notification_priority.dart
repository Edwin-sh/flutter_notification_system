/// Enum que define los niveles de prioridad para las notificaciones
///
/// Utilizado por el sistema de cola para determinar el orden de visualización
/// cuando hay múltiples notificaciones pendientes.
enum NotificationPriority {
  /// Prioridad baja - se muestra después de todas las demás
  low(0),

  /// Prioridad normal - comportamiento por defecto
  normal(1),

  /// Prioridad alta - se muestra antes que las normales y bajas
  high(2),

  /// Prioridad crítica - se muestra inmediatamente, interrumpe otras notificaciones
  critical(3);

  /// Valor numérico de la prioridad para comparaciones
  final int value;

  const NotificationPriority(this.value);

  /// Compara esta prioridad con otra
  bool isHigherThan(NotificationPriority other) {
    return value > other.value;
  }

  /// Compara esta prioridad con otra
  bool isLowerThan(NotificationPriority other) {
    return value < other.value;
  }
}
