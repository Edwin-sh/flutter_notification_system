import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/notification_view_model.dart';
import '../models/notification_data.dart';
import '../utils/notification_theme.dart';
import 'notification_presenter.dart';

/// Variable global para el contexto de la aplicación
BuildContext? applicationContext;

/// Widget que escucha cambios en NotificationViewModel y muestra notificaciones
///
/// Debe envolver la aplicación para interceptar y mostrar todas las notificaciones.
/// Usa el patrón Selector para optimizar reconstrucciones.
///
/// Ejemplo de uso:
/// ```dart
/// MaterialApp(
///   home: AppNotificationListener(
///     child: HomePage(),
///   ),
/// )
/// ```
class AppNotificationListener extends StatelessWidget {
  /// Widget hijo que será envuelto por el listener
  final Widget child;

  /// Contexto donde se mostrarán las notificaciones
  final BuildContext? notificationContext;

  /// Tema personalizado para las notificaciones
  final NotificationTheme? theme;

  /// Builder personalizado para las notificaciones
  final NotificationBuilder? customBuilder;

  /// Estrategia de presentación personalizada
  final PresentationStrategy? presentationStrategy;

  const AppNotificationListener({
    Key? key,
    required this.child,
    this.notificationContext,
    this.theme,
    this.customBuilder,
    this.presentationStrategy,
  }) : super(key: key);

  /// Constructor que usa el contexto global de la aplicación
  factory AppNotificationListener.withGlobalContext({
    Key? key,
    required Widget child,
    NotificationTheme? theme,
    NotificationBuilder? customBuilder,
    PresentationStrategy? presentationStrategy,
  }) {
    return AppNotificationListener(
      key: key,
      child: child,
      notificationContext: applicationContext,
      theme: theme,
      customBuilder: customBuilder,
      presentationStrategy: presentationStrategy,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Establecer contexto global si no está definido
    applicationContext ??= context;

    return Selector<NotificationViewModel, NotificationData?>(
      selector: (_, viewModel) => viewModel.notification,
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
  }

  /// Maneja la presentación de una notificación
  void _handleNotification(
    BuildContext context,
    NotificationData notification,
  ) {
    final effectiveContext = notificationContext ?? context;

    // Usar estrategia personalizada si está disponible
    if (presentationStrategy != null) {
      presentationStrategy!.present(effectiveContext, notification);
      return;
    }

    // Usar presenter por defecto
    final presenter = NotificationPresenter(
      theme: theme,
      customBuilder: customBuilder,
    );

    presenter.present(effectiveContext, notification);
  }
}

/// Widget alternativo que permite mayor control sobre el ciclo de vida
class AppNotificationController extends StatefulWidget {
  final Widget child;
  final NotificationTheme? theme;
  final NotificationBuilder? customBuilder;
  final void Function(NotificationData)? onNotificationShown;
  final void Function(NotificationData)? onNotificationDismissed;

  const AppNotificationController({
    Key? key,
    required this.child,
    this.theme,
    this.customBuilder,
    this.onNotificationShown,
    this.onNotificationDismissed,
  }) : super(key: key);

  @override
  State<AppNotificationController> createState() =>
      _AppNotificationControllerState();
}

class _AppNotificationControllerState extends State<AppNotificationController> {
  NotificationData? _lastNotification;

  @override
  Widget build(BuildContext context) {
    applicationContext = context;

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
