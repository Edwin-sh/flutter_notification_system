## 3.0.2 (2026-01-08)

### 🔄 Mejoras de Compatibilidad
* **Actualización de get_it**: Se actualizó `get_it` a la versión `^8.0.3` para mejorar la compatibilidad con otros paquetes que puedan usar versiones más antiguas de GetIt.
* **Convivencia mejorada**: Esta actualización permite que la librería coexista sin conflictos con otros proyectos que tengan diferentes versiones de get_it como dependencia.

## 3.0.1 (2026-01-05)

**BREAKING CHANGES** - Integración con `flutter_clean_mvvm_toolkit`

### 🚀 Mejoras Principales
* **Integración con `flutter_clean_mvvm_toolkit`**: Se han reemplazado los modelos internos `ErrorItem` y `OperationResult` por los de la librería `flutter_clean_mvvm_toolkit` para una mejor interoperabilidad y estandarización.
* **Limpieza de código**: Eliminación de modelos redundantes y mixins que ahora son proporcionados por el toolkit.
* **Ajuste en Notificaciones de Error**: Se ha eliminado el título por defecto en las notificaciones de error para permitir una mayor flexibilidad y evitar títulos redundantes cuando no se especifican en el `ErrorItem`.
* **Dependencias**: Actualización de `flutter_clean_mvvm_toolkit` a `^0.2.0`.

## 2.0.0 (2026-01-01)

**BREAKING CHANGES** - Nueva API simplificada y auto-configurable

### 🚀 Mejoras Principales
* **Auto-configuración completa**: Ya no es necesario registrar dependencias manualmente con GetIt
* **ChangeNotifierProvider incluido**: AppNotificationListener configura todo internamente
* **Nueva API simplificada**: Dos formas fáciles de mostrar notificaciones
  - Extensión de BuildContext: `context.showSuccess('mensaje')`
  - Helper estático: `NotificationSystem.showSuccess('mensaje')`
* **GetIt interno**: La librería gestiona su propia instancia de GetIt sin conflictos
* **Menos boilerplate**: De ~30 líneas de configuración a solo 1 widget wrapper

### ✨ Nuevas Características
* Clase `NotificationSystem` para acceso global sin BuildContext
* Extensión `NotificationContextExtension` en BuildContext
* Función helper `getNotificationViewModel()` con auto-inicialización
* Función `resetNotificationSystem()` para testing y reinicio

### 🔄 Migración desde 1.x

**Antes (v1.x):**
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

**Ahora (v2.0):**
```dart
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  Widget build(context) => AppNotificationListener(
    child: MaterialApp(...),
  );
}

// Uso - Opción 1
context.showSuccess('OK');

// Uso - Opción 2
NotificationSystem.showSuccess('OK');
```

### ⚠️ Cambios Deprecados
* `registerNotificationModule()` - Ahora se configura automáticamente
* `unregisterNotificationModule()` - Usar `resetNotificationSystem()` en su lugar
* `resetNotificationModule()` - Usar `resetNotificationSystem()` en su lugar
* Uso manual de GetIt externo - La librería usa su propia instancia interna

### 📝 Notas
* Los métodos deprecados siguen funcionando para compatibilidad hacia atrás
* Se recomienda migrar a la nueva API para código más limpio y simple
* Ejemplos actualizados con la nueva API en el package

## 1.0.1

* Added comprehensive example app demonstrating all features
* Basic notifications example with all types (success, error, warning, info)
* Advanced features example (custom animations, themes, queue management)
* Operation tracking example with CRUD operations and mixins
* Improved package score for pub.dev

## 1.0.0

* Initial release of Flutter Notification System
* Complete notification management system following Clean Architecture
* Support for SnackBars with customizable themes and animations
* Support for dialogs with confirmation callbacks
* Error handling system with ErrorItem models
* NotificationQueue for managing multiple notifications
* Priority-based notification system (low, medium, high, critical)
* Type-safe notification types (success, error, warning, info)
* Dependency injection support with GetIt
* Provider integration for state management
* Fully customizable themes and animations
* Built-in fade and slide animations
* Operation result pattern with Either monad (dartz)
* Comprehensive test coverage
