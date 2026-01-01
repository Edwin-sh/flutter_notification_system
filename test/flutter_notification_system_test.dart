import 'package:flutter/foundation.dart';
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

    test('should initialize with null notification', () {
      expect(viewModel.notification, isNull);
      expect(viewModel.isShowingNotification, isFalse);
      expect(viewModel.queueLength, equals(0));
    });

    test('should set notification when showNotification is called', () {
      // Act
      viewModel.showNotification(
        message: 'Test notification',
        type: NotificationTypeEnum.success,
      );

      // Assert
      expect(viewModel.notification, isNotNull);
      expect(viewModel.notification?.message, equals('Test notification'));
      expect(
        viewModel.notification?.type,
        equals(NotificationTypeEnum.success),
      );
      expect(viewModel.isShowingNotification, isTrue);
    });

    test('should set notification when showSuccess is called', () {
      // Act
      viewModel.showSuccess(message: 'Success message');

      // Assert
      expect(viewModel.notification, isNotNull);
      expect(
        viewModel.notification?.type,
        equals(NotificationTypeEnum.success),
      );
      expect(viewModel.notification?.message, equals('Success message'));
    });

    test('should set notification when showError is called', () {
      // Arrange
      final error = ErrorItem(message: 'Test error', title: 'Error Title');

      // Act
      viewModel.showError(error);

      // Assert
      expect(viewModel.notification, isNotNull);
      expect(viewModel.notification?.message, equals('Test error'));
      expect(viewModel.notification?.type, equals(NotificationTypeEnum.error));
      expect(viewModel.notification?.error, equals(error));
    });

    test('should clear notification when clear is called', () {
      // Arrange
      viewModel.showNotification(
        message: 'Test',
        type: NotificationTypeEnum.info,
      );

      // Act
      viewModel.clear();

      // Assert
      expect(viewModel.notification, isNull);
      expect(viewModel.isShowingNotification, isFalse);
    });

    test('should notify listeners when notification changes', () {
      // Arrange
      var notified = false;
      viewModel.addListener(() {
        notified = true;
      });

      // Act
      viewModel.showNotification(
        message: 'Test',
        type: NotificationTypeEnum.info,
      );

      // Assert
      expect(notified, isTrue);
    });

    test('should enqueue notifications when one is showing', () {
      // Arrange
      viewModel.showNotification(
        message: 'First',
        type: NotificationTypeEnum.info,
      );

      // Act
      viewModel.showNotification(
        message: 'Second',
        type: NotificationTypeEnum.info,
      );

      // Assert
      expect(viewModel.queueLength, equals(1));
      expect(viewModel.notification?.message, equals('First'));
    });

    test('should process next notification after clearing', () async {
      // Arrange
      viewModel.showNotification(
        message: 'First',
        type: NotificationTypeEnum.info,
      );
      viewModel.showNotification(
        message: 'Second',
        type: NotificationTypeEnum.info,
      );

      // Act
      viewModel.clear();
      await Future.delayed(const Duration(milliseconds: 10));

      // Assert
      expect(viewModel.notification?.message, equals('Second'));
      expect(viewModel.queueLength, equals(0));
    });

    test('should prioritize critical notifications', () {
      // Arrange
      viewModel.showNotification(
        message: 'Normal',
        type: NotificationTypeEnum.info,
        priority: NotificationPriority.normal,
      );

      // Act - Critical should interrupt
      viewModel.showNotification(
        message: 'Critical',
        type: NotificationTypeEnum.error,
        priority: NotificationPriority.critical,
      );

      // Assert
      expect(viewModel.notification?.message, equals('Critical'));
    });

    test('should cancel notification by id', () {
      // Arrange
      viewModel.showNotification(
        message: 'Test',
        type: NotificationTypeEnum.info,
      );
      final notificationId = viewModel.notification!.id;

      // Act
      viewModel.cancelNotification(notificationId);

      // Assert
      expect(viewModel.notification, isNull);
    });

    test('should clear queue', () {
      // Arrange
      viewModel.showNotification(
        message: 'First',
        type: NotificationTypeEnum.info,
      );
      viewModel.showNotification(
        message: 'Second',
        type: NotificationTypeEnum.info,
      );
      viewModel.showNotification(
        message: 'Third',
        type: NotificationTypeEnum.info,
      );

      // Act
      viewModel.clearQueue();

      // Assert
      expect(viewModel.queueLength, equals(0));
    });
  });

  group('NotificationQueue', () {
    late NotificationQueue queue;

    setUp(() {
      queue = NotificationQueue(maxSize: 3);
    });

    test('should enqueue notifications', () {
      // Act
      queue.enqueue(NotificationData.success(message: 'Test'));

      // Assert
      expect(queue.length, equals(1));
      expect(queue.isEmpty, isFalse);
    });

    test('should dequeue notifications in priority order', () {
      // Arrange
      queue.enqueue(
        NotificationData.info(
          message: 'Normal',
          priority: NotificationPriority.normal,
        ),
      );
      queue.enqueue(
        NotificationData.warning(
          message: 'High',
          priority: NotificationPriority.high,
        ),
      );
      queue.enqueue(
        NotificationData.info(
          message: 'Low',
          priority: NotificationPriority.low,
        ),
      );

      // Act & Assert
      expect(queue.dequeue()?.message, equals('High'));
      expect(queue.dequeue()?.message, equals('Normal'));
      expect(queue.dequeue()?.message, equals('Low'));
    });

    test('should respect max size', () {
      // Arrange & Act
      for (int i = 0; i < 5; i++) {
        queue.enqueue(NotificationData.info(message: 'Test $i'));
      }

      // Assert
      expect(queue.length, lessThanOrEqualTo(3));
    });

    test('should peek without removing', () {
      // Arrange
      final notification = NotificationData.success(message: 'Test');
      queue.enqueue(notification);

      // Act
      final peeked = queue.peek();

      // Assert
      expect(peeked, equals(notification));
      expect(queue.length, equals(1));
    });

    test('should clear all notifications', () {
      // Arrange
      queue.enqueue(NotificationData.success(message: 'Test 1'));
      queue.enqueue(NotificationData.success(message: 'Test 2'));

      // Act
      queue.clear();

      // Assert
      expect(queue.isEmpty, isTrue);
      expect(queue.length, equals(0));
    });
  });

  group('OperationResultMixin', () {
    late TestViewModel viewModel;

    setUp(() {
      viewModel = TestViewModel();
    });

    test('should set operation success', () {
      // Arrange
      final success = OperationSuccess('Success message');

      // Act
      viewModel.setOperationSuccess(success);

      // Assert - Success should be set initially
      expect(viewModel.hasOperationSuccess, isTrue);
      expect(viewModel.operationSuccess?.message, equals('Success message'));
      expect(viewModel.operationFailure, isNull);
    });

    test('should set operation failure', () {
      // Arrange
      final failure = OperationFailure(ErrorItem(message: 'Error message'));

      // Act
      viewModel.setOperationFailure(failure);

      // Assert
      expect(viewModel.hasOperationFailure, isTrue);
      expect(viewModel.operationFailure?.message, equals('Error message'));
      expect(viewModel.operationSuccess, isNull);
    });

    test('should auto-clear after setting success', () async {
      // Arrange
      final success = OperationSuccess('Success');

      // Act
      viewModel.setOperationSuccess(success);
      await Future.delayed(const Duration(milliseconds: 10));

      // Assert - Should be cleared after microtask
      expect(viewModel.operationSuccess, isNull);
    });

    test('should notify listeners on operation result', () {
      // Arrange
      var notificationCount = 0;
      viewModel.addListener(() {
        notificationCount++;
      });

      // Act
      viewModel.setOperationSuccess(OperationSuccess('Success'));

      // Assert - Should notify twice: once with result, once after clear
      expect(notificationCount, greaterThanOrEqualTo(1));
    });

    test('should clear operation results manually', () {
      // Arrange
      viewModel.setOperationSuccess(OperationSuccess('Success'));

      // Act
      viewModel.clearOperationResults();

      // Assert
      expect(viewModel.operationSuccess, isNull);
      expect(viewModel.operationFailure, isNull);
    });
  });
}

// Test ViewModel for OperationResultMixin
class TestViewModel extends ChangeNotifier with OperationResultMixin {}
