import 'package:equatable/equatable.dart';

/// Enum para los niveles de error en la aplicación
enum ErrorLevelEnum {
  /// Error leve que no afecta la funcionalidad
  mild,

  /// Error moderado que puede afectar algunas funcionalidades
  moderate,

  /// Error severo que afecta funcionalidades críticas
  severe,

  /// Error crítico que impide el uso de la aplicación
  critical,
}

/// Clase inmutable que representa un error en la aplicación
class ErrorItem extends Equatable {
  final String message;
  final String? title;
  final ErrorLevelEnum errorLevel;
  final String? technicalDetails;
  final String? errorCode;
  final DateTime timestamp;

  ErrorItem({
    required this.message,
    this.title,
    this.errorLevel = ErrorLevelEnum.moderate,
    this.technicalDetails,
    this.errorCode,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  @override
  List<Object?> get props => [
    message,
    title,
    errorLevel,
    technicalDetails,
    errorCode,
    timestamp,
  ];

  @override
  String toString() {
    return 'ErrorItem(message: $message, title: $title, errorLevel: $errorLevel, errorCode: $errorCode)';
  }

  ErrorItem copyWith({
    String? message,
    String? title,
    ErrorLevelEnum? errorLevel,
    String? technicalDetails,
    String? errorCode,
    DateTime? timestamp,
  }) {
    return ErrorItem(
      message: message ?? this.message,
      title: title ?? this.title,
      errorLevel: errorLevel ?? this.errorLevel,
      technicalDetails: technicalDetails ?? this.technicalDetails,
      errorCode: errorCode ?? this.errorCode,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
