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
- � **Auto-Configurable**: No requiere registro manual de dependencias
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
  flutter_notification_system: ^3.0.1
```

Luego ejecuta:

```bash
flutter pub get
```

## 🚀 Uso Rápido

### 1. Configuración Simple (Nueva API)

La librería ahora se integra nativamente con `flutter_clean_mvvm_toolkit`, utilizando sus modelos estandarizados para errores y resultados de operaciones.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_notification_system/flutter_notification_system.dart';

void main() {
  // ¡Ya NO es necesario inicializar GetIt ni registrar módulos!
  // La librería se encarga de todo automáticamente
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Solo envuelve tu app con AppNotificationListener
    // ¡Eso es todo! La librería configura todo internamente:
    // - GetIt y sus dependencias
    // - ChangeNotifierProvider
    // - Sistema de notificaciones
    return AppNotificationListener(
      // Configuración opcional
      config: NotificationConfig(
        maxQueueSize: 10,
      ),
      child: MaterialApp(
        title: 'Mi App',
        home: HomePage(),
      ),
    );
  }
}
```

### 2. Mostrar Notificaciones

Ahora tienes **dos formas simples** de mostrar notificaciones:

#### Opción 1: Usando el contexto (BuildContext extension)

```dart
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Método 1: Extensión de BuildContext
        context.showSuccess('¡Operación exitosa!');
        context.showError(ErrorItem(
          title: 'Error',
          message: 'Error al guardar',
          code: ErrorCode.unknownError,
        ));
        context.showWarning('Advertencia de seguridad');
        context.showInfo('Nueva actualización disponible');
      },
      child: Text('Mostrar notificación'),
    );
  }
}
```

#### Opción 2: Usando el helper estático (desde cualquier lugar)

```dart
// Puedes usar NotificationSystem desde cualquier parte del código
// incluso fuera de widgets o sin BuildContext
class MyService {
  Future<void> saveData() async {
    try {
      await api.save();
      NotificationSystem.showSuccess('Datos guardados correctamente');
    } catch (e) {
      NotificationSystem.showError(
        ErrorItem(
          title: 'Error',
          message: 'Error al guardar: $e',
          code: ErrorCode.unknownError,
        ),
      );
    }
  }
}
```

### 3. Notificaciones con Prioridades

```dart
// Prioridad baja
context.showInfo(
  'Sincronización en segundo plano',
  priority: NotificationPriority.low,
);

// Prioridad alta
NotificationSystem.showWarning(
  'Batería baja',
  priority: NotificationPriority.high,
);

// Prioridad crítica (interrumpe otras notificaciones)
context.showError(
  ErrorItem(
    title: 'Error Crítico',
    message: 'Conexión perdida',
    code: ErrorCode.networkError,
    errorLevel: ErrorLevelEnum.critical,
  ),
  priority: NotificationPriority.critical,
);
```

### 4. Duraciones Personalizadas

```dart
// Notificación corta (1 segundo)
NotificationSystem.showSuccess(
  'Guardado',
  duration: const Duration(seconds: 1),
);

// Notificación larga (10 segundos)
context.showInfo(
  'Leyendo documentación importante...',
  duration: const Duration(seconds: 10),
);
```

## 🎨 Personalización

### Configuración al Inicializar

```dart
AppNotificationListener(
  config: NotificationConfig(
    maxQueueSize: 10,
    // Otras opciones de configuración...
  ),
  theme: NotificationTheme.dark(), // Tema oscuro
  child: MaterialApp(...),
)
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

## 🔄 Migración desde v1.x

Si estás actualizando desde la versión 1.x, aquí está el cambio:

### Antes (v1.x)
```dart
final getIt = GetIt.instance;

void main() {
  registerNotificationModule(getIt);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Widget build(context) => ChangeNotifierProvider.value(
    value: getIt<NotificationViewModel>(),
    child: Consumer<NotificationViewModel>(
      builder: (context, vm, _) {
        vm.setAppContext(context);
        return AppNotificationListener(child: MaterialApp(...));
      },
    ),
  );
}

// Uso
getIt<NotificationViewModel>().showSuccess(message: 'OK');
```

### Ahora (v2.0)
```dart
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  Widget build(context) => AppNotificationListener(
    child: MaterialApp(...),
  );
}

// Uso
context.showSuccess('OK');
// o
NotificationSystem.showSuccess('OK');
```

## 🧪 Testing

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_notification_system/flutter_notification_system.dart';

void main() {
  group('NotificationViewModel', () {
    late NotificationViewModel viewModel;

    setUp(() {
      viewModel = getNotificationViewModel();
    });

    tearDown(() {
      resetNotificationSystem();
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
│   │   └── notification_config.dart
│   ├── view_models/         # Lógica de presentación
│   │   └── notification_view_model.dart
│   ├── widgets/             # Componentes UI
│   │   ├── notification_listener.dart
│   │   ├── notification_presenter.dart
│   │   ├── custom_snackbar.dart
│   │   └── custom_dialog.dart
│   ├── utils/               # Utilidades
│   │   ├── notification_queue.dart
│   │   ├── notification_theme.dart
│   │   ├── notification_animations.dart
│   │   └── notification_helpers.dart
│   └── di/                  # Inyección de dependencias
│       └── notification_di.dart
└── flutter_notification_system.dart
```

## 📚 Ejemplos

Ver la carpeta `/example` para ejemplos completos que demuestran:
- ✅ Uso básico con las dos APIs (context y NotificationSystem)
- ✅ Notificaciones con diferentes prioridades
- ✅ Duraciones personalizadas
- ✅ Gestión de cola de notificaciones
- ✅ Personalización de temas y animaciones

## 🤝 Ventajas de la v3.0

1. **🔗 Integración con Toolkit**: Interoperabilidad nativa con `flutter_clean_mvvm_toolkit`.
2. **🚀 Configuración Instantánea**: De ~30 líneas a 1 widget wrapper.
3. **💡 API Intuitiva**: Dos formas simples de mostrar notificaciones.
4. **🔒 Sin Conflictos**: GetIt interno no interfiere con tu GetIt global.
5. **📦 Auto-Contenida**: La librería maneja todas sus dependencias.
6. **🎯 BuildContext Extension**: Sintaxis natural y familiar.
7. **🌍 Helper Estático**: Acceso desde cualquier lugar sin contexto.

## 📄 Licencia

MIT License - ver [LICENSE](LICENSE) para detalles.

---

**Versión**: 3.0.1  
**Fecha**: Enero 2026  
**Cambios**: Integración con Clean MVVM Toolkit y modelos estandarizados.
