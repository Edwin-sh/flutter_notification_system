import 'package:equatable/equatable.dart';
import 'error_item.dart';

/// Clase inmutable que representa un resultado exitoso de una operación
///
/// Utilizada con [OperationResultMixin] para notificar éxitos en operaciones CRUD.
class OperationSuccess extends Equatable {
  /// Mensaje descriptivo del éxito
  final String message;

  /// Título opcional del éxito
  final String? title;

  /// Datos adicionales opcionales del resultado
  final Map<String, dynamic>? data;

  const OperationSuccess(this.message, {this.title, this.data});

  @override
  List<Object?> get props => [message, title, data];

  @override
  String toString() => 'OperationSuccess(message: $message, title: $title)';
}

/// Clase inmutable que representa un resultado fallido de una operación
///
/// Utilizada con [OperationResultMixin] para notificar errores en operaciones CRUD.
class OperationFailure extends Equatable {
  /// ErrorItem con detalles del fallo
  final ErrorItem errorItem;

  const OperationFailure(this.errorItem);

  /// Getter de conveniencia para el mensaje de error
  String get message => errorItem.message;

  /// Getter de conveniencia para el título de error
  String? get title => errorItem.title;

  @override
  List<Object?> get props => [errorItem];

  @override
  String toString() => 'OperationFailure(errorItem: $errorItem)';
}
