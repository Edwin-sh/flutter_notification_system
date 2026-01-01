import 'dart:collection';
import '../models/notification_data.dart';
import '../models/notification_priority.dart';
import '../models/notification_type.dart';

/// Sistema de cola con prioridades para gestionar notificaciones
class NotificationQueue {
  final Queue<NotificationData> _queue = Queue<NotificationData>();
  final int maxSize;

  NotificationQueue({this.maxSize = 3});

  void enqueue(NotificationData notification) {
    if (_queue.length >= maxSize) {
      _removeLowestPriorityIfNecessary(notification);
    }

    if (_queue.isEmpty) {
      _queue.add(notification);
      return;
    }

    final list = _queue.toList();
    int insertIndex = list.length;

    for (int i = 0; i < list.length; i++) {
      if (notification.priority.isHigherThan(list[i].priority)) {
        insertIndex = i;
        break;
      }
    }

    if (insertIndex == list.length) {
      _queue.add(notification);
    } else {
      final newList = List<NotificationData>.from(list);
      newList.insert(insertIndex, notification);
      _queue.clear();
      _queue.addAll(newList);
    }
  }

  void _removeLowestPriorityIfNecessary(NotificationData newNotification) {
    if (_queue.isEmpty) return;

    final list = _queue.toList();
    NotificationData? lowestPriorityNotification = list.first;

    for (var notification in list) {
      if (notification.priority.isLowerThan(
        lowestPriorityNotification!.priority,
      )) {
        lowestPriorityNotification = notification;
      }
    }

    if (lowestPriorityNotification != null &&
        newNotification.priority.isHigherThan(
          lowestPriorityNotification.priority,
        )) {
      _queue.remove(lowestPriorityNotification);
    }
  }

  NotificationData? dequeue() {
    if (_queue.isEmpty) return null;
    return _queue.removeFirst();
  }

  NotificationData? peek() {
    if (_queue.isEmpty) return null;
    return _queue.first;
  }

  void remove(NotificationData notification) {
    _queue.remove(notification);
  }

  void removeById(String id) {
    _queue.removeWhere((notification) => notification.id == id);
  }

  void clear() {
    _queue.clear();
  }

  int get length => _queue.length;
  bool get isEmpty => _queue.isEmpty;
  bool get isFull => _queue.length >= maxSize;
  List<NotificationData> get notifications => List.unmodifiable(_queue);

  List<NotificationData> getByType(NotificationTypeEnum type) {
    return _queue.where((n) => n.type == type).toList();
  }

  List<NotificationData> getByPriority(NotificationPriority priority) {
    return _queue.where((n) => n.priority == priority).toList();
  }
}
