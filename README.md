<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages).
-->

# Flutter Notification System 🔔

Una librería completa de gestión de notificaciones para Flutter que sigue los principios de Clean Architecture.

## ✨ Características

- 🎯 **Type-Safe**: Sistema completamente tipado con Dart
- 🏗️ **Clean Architecture**: Separación clara de responsabilidades
- 📊 **Queue Management**: Cola de notificaciones con sistema de prioridades
- 🎨 **Personalizable**: Temas, colores, animaciones y builders personalizados
- 🔄 **Operation Tracking**: Mixin para rastrear resultados de operaciones CRUD
- 🧪 **Testeable**: Cobertura completa de tests unitarios e integración
- ⚡ **Performance**: Optimizado con Selector y Mixin patterns
- 🔔 **Múltiples tipos**: Success, Error, Warning, Info
- 📱 **Responsive**: SnackBars y Dialogs adaptativos
- 🎭 **Animaciones**: Múltiples efectos de animación configurables

## 📦 Instalación

Agrega esto a tu `pubspec.yaml`:


```yaml
dependencies:
  flutter_notification_system: ^1.0.0
```

Luego ejecuta:

```bash
flutter pub get
```

## 🚀 Uso Rápido

### 1. Configuración Inicial

```dart
import 'package:flutter_notification_system/flutter_notification_system.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Registrar módulo de notificaciones
  registerNotificationModule(getIt);
  
  runApp(MyApp());
}
```

### 2. Configurar en App Root

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NotificationViewModel>.value(
      value: getIt<NotificationViewModel>(),
      child: Consumer<NotificationViewModel>(
        builder: (context, viewModel, _) {
          viewModel.setAppContext(context);
          
          return AppNotificationListener(
            child: MaterialApp(
              title: 'Mi App',
              home: HomePage(),
            ),
          );
        },
      ),
    );
  }
}
```

### 3. Mostrar Notificaciones

```dart
// Notificación de éxito
getIt<NotificationViewModel>().showSuccess(
  message: 'Operación completada exitosamente',
);

// Notificación de información
getIt<NotificationViewModel>().showInfo(
  message: 'Datos actualizados',
);

// Notificación de advertencia
getIt<NotificationViewModel>().showWarning(
  message: 'Verifique los datos ingresados',
);

// Notificación de error desde ErrorItem
getIt<NotificationViewModel>().showError(
  ErrorItem(
    message: 'No se pudo guardar el registro',
    title: 'Error de Base de Datos',
    errorLevel: ErrorLevelEnum.severe,
  ),
);
```

### 4. Uso con ViewModels y OperationResultMixin

```dart
class PatientViewModel extends ChangeNotifier with OperationResultMixin {
  final SavePatientUseCase _savePatientUseCase;

  PatientViewModel(this._savePatientUseCase);

  Future<void> savePatient(Patient patient) async {
    final result = await _savePatientUseCase(patient);
    
    result.fold(
      (error) => setOperationFailure(OperationFailure(error)),
      (_) => setOperationSuccess(
        OperationSuccess('Paciente guardado exitosamente'),
      ),
    );
  }
}

// En tu widget
class PatientFormPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PatientViewModel>.value(
      value: getIt<PatientViewModel>(),
      child: Consumer<PatientViewModel>(
        builder: (context, viewModel, _) {
          // Escuchar resultados de operaciones
          final success = viewModel.operationSuccess;
          final failure = viewModel.operationFailure;

          if (success != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              getIt<NotificationViewModel>().showSuccess(
                message: success.message,
              );
              Navigator.pop(context);
            });
          } else if (failure != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              getIt<NotificationViewModel>().showError(
                failure.errorItem,
              );
            });
          }

          return Scaffold(
            appBar: AppBar(title: Text('Paciente')),
            body: PatientForm(viewModel: viewModel),
          );
        },
      ),
    );
  }
}
```

## 🎨 Personalización

### Configuración Global

```dart
void main() {
  // Configurar antes de iniciar la app
  NotificationConfig.global = NotificationConfig(
    successDuration: Duration(seconds: 3),
    errorDuration: null, // null = manual
    warningDuration: Duration(seconds: 4),
    infoDuration: Duration(seconds: 2),
    maxQueueSize: 5,
    animationDuration: Duration(milliseconds: 300),
    showCloseButton: true,
    enableAnimations: true,
    enableSwipeToDismiss: true,
  );

  runApp(MyApp());
}
```

### Tema Personalizado

```dart
// Tema claro personalizado
NotificationTheme.current = NotificationTheme(
  successColor: Color(0xFF4CAF50),
  errorColor: Color(0xFFF44336),
  warningColor: Color(0xFFFF9800),
  infoColor: Color(0xFF2196F3),
  borderRadius: 12.0,
  elevation: 8.0,
  titleStyle: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  ),
);

// O usar tema oscuro predefinido
NotificationTheme.current = NotificationTheme.dark;
```

### Widget Personalizado

```dart
AppNotificationListener(
  customBuilder: (context, notification) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.purple,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(Icons.star, color: Colors.white),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              notification.message,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  },
  child: YourApp(),
)
```

### Notificaciones con Prioridad

```dart
// Prioridad baja
getIt<NotificationViewModel>().showInfo(
  message: 'Sincronización en segundo plano',
  priority: NotificationPriority.low,
);

// Prioridad alta
getIt<NotificationViewModel>().showWarning(
  message: 'Batería baja',
  priority: NotificationPriority.high,
);

// Prioridad crítica (interrumpe otras notificaciones)
getIt<NotificationViewModel>().showError(
  ErrorItem(
    message: 'Conexión perdida',
    errorLevel: ErrorLevelEnum.critical,
  ),
  priority: NotificationPriority.critical,
);
```

## 🧪 Testing

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_notification_system/flutter_notification_system.dart';

void main() {
  group('NotificationViewModel', () {
    late NotificationViewModel viewModel;

    setUp(() {
      viewModel = NotificationViewModel();
    });

    tearDown(() {
      viewModel.dispose();
    });

    test('should show notification', () {
      viewModel.showSuccess(message: 'Test');
      
      expect(viewModel.notification, isNotNull);
      expect(viewModel.notification?.message, equals('Test'));
    });
  });
}
```

## 🏛️ Arquitectura

```
lib/
├── src/
│   ├── models/              # Modelos de datos inmutables
│   │   ├── notification_data.dart
│   │   ├── notification_type.dart
│   │   ├── notification_priority.dart
│   │   ├── notification_config.dart
│   │   ├── operation_result.dart
│   │   └── error_item.dart
│   ├── view_models/         # Lógica de presentación
│   │   ├── notification_view_model.dart
│   │   └── operation_result_mixin.dart
│   ├── widgets/             # Componentes UI
│   │   ├── notification_listener.dart
│   │   ├── notification_presenter.dart
│   │   ├── custom_snackbar.dart
│   │   └── custom_dialog.dart
│   ├── utils/               # Utilidades
│   │   ├── notification_queue.dart
│   │   ├── notification_theme.dart
│   │   └── notification_animations.dart
│   └── di/                  # Inyección de dependencias
│       └── notification_di.dart
└── flutter_notification_system.dart
```

## 📚 Ejemplos Avanzados

Ver la carpeta `/example` para ejemplos completos de:
- Integración con Clean Architecture
- CRUD con notificaciones automáticas
- Personalización de temas
- Testing completo
- Manejo de errores

## 🤝 Mejoras sobre el Sistema Original

1. **Sistema de Prioridades**: Cola inteligente que prioriza notificaciones críticas
2. **Mejor Configuración**: Configuración global y por notificación
3. **Más Personalizable**: Temas, animaciones y builders personalizados
4. **Testing Mejorado**: Cobertura completa con tests unitarios
5. **Mejor Performance**: Optimizaciones en la cola y listeners
6. **Más Tipos de Widgets**: Múltiples estilos de SnackBars y Dialogs
7. **Documentación Completa**: Ejemplos y guías detalladas

## 📄 Licencia

MIT License - ver [LICENSE](LICENSE) para detalles.

---

**Versión**: 1.0.0  
**Fecha**: Enero 2026  
**Autor**: Sistema mejorado para proyectos Flutter empresariales
