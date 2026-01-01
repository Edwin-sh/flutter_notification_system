/// Flutter Notification System Library
///
/// A comprehensive, type-safe notification management system for Flutter applications
/// following Clean Architecture principles.
///
/// Features:
/// - Multiple notification types (success, error, warning, info)
/// - Notification queue and priority management
/// - Customizable themes and animations
/// - Operation result tracking with mixins
/// - Integration with Clean Architecture patterns
/// - Comprehensive testing support

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

// DI
export 'src/di/notification_di.dart';

// Re-exports from dependencies
export 'package:provider/provider.dart'
    show ChangeNotifierProvider, Consumer, Selector;
export 'package:get_it/get_it.dart' show GetIt;
export 'package:dartz/dartz.dart' show Either, Left, Right;
