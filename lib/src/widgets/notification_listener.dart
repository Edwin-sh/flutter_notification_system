import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/notification_view_model.dart';
import '../models/notification_data.dart';
import '../models/notification_config.dart';
import '../utils/notification_theme.dart';
import '../di/notification_di.dart';
import 'notification_presenter.dart';

/// Variable global para el contexto de la aplicación
BuildContext? applicationContext;

/// Widget que escucha cambios en NotificationViewModel y muestra notificaciones
///
/// Este widget se encarga de toda la configuración necesaria:
/// - Registra automáticamente las dependencias con GetIt
/// - Configura el ChangeNotifierProvider
/// - Escucha y muestra las notificaciones
///
/// Ejemplo de uso simplificado:
/// ```dart
/// MaterialApp(
///   home: AppNotificationListener(
///     child: HomePage(),
///   ),
/// )
/// ```
///
/// Con configuración personalizada:
/// ```dart
/// AppNotificationListener(
///   config: NotificationConfig(maxQueueSize: 10),
///   theme: NotificationTheme.dark(),
///   child: HomePage(),
/// )
/// ```
class AppNotificationListener extends StatelessWidget {
  /// Widget hijo que será envuelto por el listener
  final Widget child;

  /// Configuración opcional del sistema de notificaciones
  final NotificationConfig? config;

  /// Tema personalizado para las notificaciones
  final NotificationTheme? theme;

  /// Builder personalizado para las notificaciones
  final NotificationBuilder? customBuilder;

  /// Estrategia de presentación personalizada
  final PresentationStrategy? presentationStrategy;

  const AppNotificationListener({
    super.key,
    required this.child,
    this.config,
    this.theme,
    this.customBuilder,
    this.presentationStrategy,
  });

  @override
  Widget build(BuildContext context) {
    // Obtener el ViewModel (se auto-inicializa internamente)
    final viewModel = getNotificationViewModel(config: config);

    // Establecer contexto global si no está definido
    applicationContext ??= context;

    // Envolver con ChangeNotifierProvider y Selector
    return ChangeNotifierProvider<NotificationViewModel>.value(
      value: viewModel,
      child: Builder(
        builder: (context) {
          // Establecer el contexto de la app en el ViewModel
          viewModel.setAppContext(context);

          return Selector<NotificationViewModel, NotificationData?>(
            selector: (_, vm) => vm.notification,
            shouldRebuild: (previous, next) => previous != next,
            builder: (context, notification, _) {
              if (notification != null) {
                // Usar PostFrameCallback para ejecutar después del build
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _handleNotification(context, notification);

                  // Limpiar la notificación después de mostrarla
                  context.read<NotificationViewModel>().clear();
                });
              }

              return child;
            },
          );
        },
      ),
    );
  }

  /// Maneja la presentación de una notificación
  void _handleNotification(
    BuildContext context,
    NotificationData notification,
  ) {
    // Usar estrategia personalizada si está disponible
    if (presentationStrategy != null) {
      presentationStrategy!.present(context, notification);
      return;
    }

    // Usar presenter por defecto
    final presenter = NotificationPresenter(
      theme: theme,
      customBuilder: customBuilder,
    );

    presenter.present(context, notification);
  }
}

/// Widget alternativo que permite mayor control sobre el ciclo de vida
///
/// Incluye ChangeNotifierProvider y auto-gestiona GetIt internamente.
///
/// Ejemplo de uso:
/// ```dart
/// AppNotificationController(
///   onNotificationShown: (notification) => print('Shown: ${notification.message}'),
///   onNotificationDismissed: (notification) => print('Dismissed'),
///   child: MyHomePage(),
/// )
/// ```
class AppNotificationController extends StatefulWidget {
  final Widget child;
  final NotificationConfig? config;
  final NotificationTheme? theme;
  final NotificationBuilder? customBuilder;
  final void Function(NotificationData)? onNotificationShown;
  final void Function(NotificationData)? onNotificationDismissed;

  const AppNotificationController({
    super.key,
    required this.child,
    this.config,
    this.theme,
    this.customBuilder,
    this.onNotificationShown,
    this.onNotificationDismissed,
  });

  @override
  State<AppNotificationController> createState() =>
      _AppNotificationControllerState();
}

class _AppNotificationControllerState extends State<AppNotificationController> {
  NotificationData? _lastNotification;
  late NotificationViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    // Obtener el ViewModel (se auto-inicializa internamente)
    _viewModel = getNotificationViewModel(config: widget.config);
  }

  @override
  Widget build(BuildContext context) {
    applicationContext = context;

    return ChangeNotifierProvider<NotificationViewModel>.value(
      value: _viewModel,
      child: Builder(
        builder: (context) {
          // Establecer el contexto de la app en el ViewModel
          _viewModel.setAppContext(context);

          return Selector<NotificationViewModel, NotificationData?>(
            selector: (_, viewModel) => viewModel.notification,
            shouldRebuild: (previous, next) => previous != next,
            builder: (context, notification, _) {
              if (notification != null && notification != _lastNotification) {
                _lastNotification = notification;

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _handleNotification(context, notification);
                  widget.onNotificationShown?.call(notification);

                  // Auto-limpiar después de mostrar
                  Future.delayed(
                    notification.duration ?? const Duration(seconds: 2),
                    () {
                      if (mounted) {
                        context.read<NotificationViewModel>().clear();
                        widget.onNotificationDismissed?.call(notification);
                        _lastNotification = null;
                      }
                    },
                  );
                });
              }

              return widget.child;
            },
          );
        },
      ),
    );
  }

  void _handleNotification(
    BuildContext context,
    NotificationData notification,
  ) {
    final presenter = NotificationPresenter(
      theme: widget.theme,
      customBuilder: widget.customBuilder,
    );

    presenter.present(context, notification);
  }
}
