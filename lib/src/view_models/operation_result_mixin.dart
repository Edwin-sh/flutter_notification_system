import 'package:flutter/foundation.dart';
import '../models/operation_result.dart';

/// Mixin que proporciona gestión de resultados de operaciones en ViewModels
///
/// Facilita el manejo de éxitos y errores en operaciones CRUD con auto-limpieza.
/// El patrón de "usar y limpiar" permite detectar cambios en las páginas/formularios
/// y evita que las notificaciones se muestren múltiples veces.
///
/// Ejemplo de uso:
/// ```dart
/// class MyViewModel extends ChangeNotifier with OperationResultMixin {
///   Future<void> saveData() async {
///     final result = await _useCase();
///     result.fold(
///       (error) => setOperationFailure(OperationFailure(error)),
///       (_) => setOperationSuccess(OperationSuccess('¡Guardado!')),
///     );
///   }
/// }
/// ```
mixin OperationResultMixin on ChangeNotifier {
  OperationSuccess? _operationSuccess;
  OperationFailure? _operationFailure;

  /// Resultado exitoso de la última operación (null si no hay)
  OperationSuccess? get operationSuccess => _operationSuccess;

  /// Resultado fallido de la última operación (null si no hay)
  OperationFailure? get operationFailure => _operationFailure;

  /// Indica si hay un resultado exitoso pendiente
  bool get hasOperationSuccess => _operationSuccess != null;

  /// Indica si hay un resultado fallido pendiente
  bool get hasOperationFailure => _operationFailure != null;

  /// Indica si hay algún resultado pendiente (éxito o fallo)
  bool get hasOperationResult => hasOperationSuccess || hasOperationFailure;

  /// Establece un resultado exitoso y notifica a los listeners
  ///
  /// Implementa auto-limpieza: establece el resultado, notifica,
  /// luego lo limpia y notifica nuevamente.
  void setOperationSuccess(OperationSuccess operationResult) {
    _operationSuccess = operationResult;
    _operationFailure = null;

    if (kDebugMode) {
      print('✅ Operation Success: ${operationResult.message}');
    }

    // Notificar con el resultado
    notifyListeners();

    // Auto-limpieza: limpiar y notificar nuevamente
    Future.microtask(() {
      _operationSuccess = null;
      notifyListeners();
    });
  }

  /// Establece un resultado fallido y notifica a los listeners
  ///
  /// Implementa auto-limpieza: establece el resultado, notifica,
  /// luego lo limpia y notifica nuevamente.
  void setOperationFailure(OperationFailure operationResult) {
    _operationFailure = operationResult;
    _operationSuccess = null;

    if (kDebugMode) {
      print('❌ Operation Failure: ${operationResult.message}');
      if (operationResult.errorItem.technicalDetails != null) {
        print(
          '   Technical Details: ${operationResult.errorItem.technicalDetails}',
        );
      }
    }

    // Notificar con el resultado
    notifyListeners();

    // Auto-limpieza: limpiar y notificar nuevamente
    Future.microtask(() {
      _operationFailure = null;
      notifyListeners();
    });
  }

  /// Limpia manualmente ambos resultados
  void clearOperationResults() {
    _operationSuccess = null;
    _operationFailure = null;
    notifyListeners();
  }

  /// Limpia solo el resultado exitoso
  void clearOperationSuccess() {
    _operationSuccess = null;
    notifyListeners();
  }

  /// Limpia solo el resultado fallido
  void clearOperationFailure() {
    _operationFailure = null;
    notifyListeners();
  }
}
