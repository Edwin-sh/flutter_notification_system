/// Flutter Notification System Library
///
/// A comprehensive, type-safe notification management system for Flutter applications
/// following Clean Architecture principles.
///
/// ## Características principales:
/// - Sistema auto-configurable (no requiere registro manual de dependencias)
/// - Múltiples tipos de notificaciones (success, error, warning, info)
/// - Gestión de cola y prioridades
/// - Temas y animaciones personalizables
/// - Seguimiento de resultados de operaciones con mixins
/// - Integración con Clean Architecture
/// - Soporte completo para testing
///
/// ## Uso básico:
/// ```dart
/// void main() {
///   runApp(MyApp());
/// }
///
/// class MyApp extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     return AppNotificationListener(
///       child: MaterialApp(
///         home: HomePage(),
///       ),
///     );
///   }
/// }
///
/// // Mostrar notificaciones desde cualquier lugar
/// class HomePage extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     return ElevatedButton(
///       onPressed: () {
///         // Método 1: Usando el helper global
///         NotificationSystem.showSuccess('Operación exitosa');
///
///         // Método 2: Usando context (requiere estar dentro de AppNotificationListener)
///         context.showSuccess('Operación exitosa');
///       },
///       child: Text('Mostrar notificación'),
///     );
///   }
/// }
/// ```
library;

// Core Models
export 'src/models/notification_data.dart';
export 'src/models/notification_type.dart';
export 'src/models/notification_priority.dart';
export 'src/models/notification_config.dart';
export 'src/models/operation_result.dart';
export 'src/models/error_item.dart';

// ViewModels
export 'src/view_models/notification_view_model.dart';
export 'src/view_models/operation_result_mixin.dart';

// Widgets
export 'src/widgets/notification_listener.dart';
export 'src/widgets/notification_presenter.dart';
export 'src/widgets/custom_snackbar.dart';
export 'src/widgets/custom_dialog.dart';

// Utilities
export 'src/utils/notification_queue.dart';
export 'src/utils/notification_theme.dart';
export 'src/utils/notification_animations.dart';
export 'src/utils/notification_helpers.dart'
    show NotificationSystem, NotificationContextExtension;

// DI - Helper global para acceso simplificado
export 'src/di/notification_di.dart'
    show
        getNotificationViewModel,
        resetNotificationSystem,
        // Deprecados - mantenidos por compatibilidad
        registerNotificationModule,
        unregisterNotificationModule,
        resetNotificationModule;

// Re-exports from dependencies (para usuarios avanzados)
export 'package:provider/provider.dart'
    show ChangeNotifierProvider, Consumer, Selector;
export 'package:dartz/dartz.dart' show Either, Left, Right;
