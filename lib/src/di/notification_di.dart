import 'package:get_it/get_it.dart';
import '../view_models/notification_view_model.dart';
import '../models/notification_config.dart';

/// Instancia interna de GetIt para el sistema de notificaciones
final _notificationGetIt = GetIt.asNewInstance();

/// Inicializa el sistema de notificaciones con GetIt interno
///
/// Se llama automáticamente al usar AppNotificationListener
void _initializeNotificationSystem({NotificationConfig? config}) {
  if (!_notificationGetIt.isRegistered<NotificationViewModel>()) {
    _notificationGetIt.registerLazySingleton<NotificationViewModel>(
      () => NotificationViewModel(config: config),
    );
  }
}

/// Obtiene la instancia del NotificationViewModel
///
/// Se auto-inicializa si es necesario
NotificationViewModel getNotificationViewModel({NotificationConfig? config}) {
  _initializeNotificationSystem(config: config);
  return _notificationGetIt<NotificationViewModel>();
}

/// Reinicia el sistema de notificaciones con nueva configuración
///
/// Útil para testing o cuando se necesita reinicializar
void resetNotificationSystem({NotificationConfig? config}) {
  if (_notificationGetIt.isRegistered<NotificationViewModel>()) {
    _notificationGetIt.unregister<NotificationViewModel>();
  }
  _initializeNotificationSystem(config: config);
}

// ============================================================================
// MÉTODOS LEGACY (Deprecados - mantenidos por compatibilidad)
// ============================================================================

/// [Deprecated] Registra el módulo de notificaciones en GetIt
///
/// Ya no es necesario llamar este método. El sistema se auto-inicializa.
@Deprecated(
  'El sistema de notificaciones ahora se auto-inicializa. '
  'Simplemente usa AppNotificationListener sin registro previo.',
)
void registerNotificationModule(GetIt getIt, {NotificationConfig? config}) {
  // Registrar NotificationViewModel como Singleton
  if (!getIt.isRegistered<NotificationViewModel>()) {
    getIt.registerLazySingleton<NotificationViewModel>(
      () => NotificationViewModel(config: config),
    );
  }
}

/// [Deprecated] Desregistra el módulo de notificaciones
@Deprecated('Usa resetNotificationSystem() en su lugar.')
void unregisterNotificationModule(GetIt getIt) {
  if (getIt.isRegistered<NotificationViewModel>()) {
    getIt.unregister<NotificationViewModel>();
  }
}

/// [Deprecated] Resetea el módulo de notificaciones
@Deprecated('Usa resetNotificationSystem() en su lugar.')
void resetNotificationModule(GetIt getIt, {NotificationConfig? config}) {
  unregisterNotificationModule(getIt);
  registerNotificationModule(getIt, config: config);
}
