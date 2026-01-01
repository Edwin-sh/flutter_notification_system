import 'package:get_it/get_it.dart';
import '../view_models/notification_view_model.dart';
import '../models/notification_config.dart';

/// Registra el módulo de notificaciones en GetIt
///
/// Debe ser llamado durante la inicialización de la aplicación:
/// ```dart
/// void main() {
///   registerNotificationModule(getIt);
///   runApp(MyApp());
/// }
/// ```
void registerNotificationModule(GetIt getIt, {NotificationConfig? config}) {
  // Registrar NotificationViewModel como Singleton
  getIt.registerLazySingleton<NotificationViewModel>(
    () => NotificationViewModel(config: config),
  );
}

/// Desregistra el módulo de notificaciones
///
/// Útil para testing o cuando se necesita reinicializar
void unregisterNotificationModule(GetIt getIt) {
  if (getIt.isRegistered<NotificationViewModel>()) {
    getIt.unregister<NotificationViewModel>();
  }
}

/// Resetea el módulo de notificaciones
///
/// Elimina y vuelve a registrar con nueva configuración
void resetNotificationModule(GetIt getIt, {NotificationConfig? config}) {
  unregisterNotificationModule(getIt);
  registerNotificationModule(getIt, config: config);
}
