import 'package:flutter/material.dart';
import 'package:flutter_notification_system/flutter_notification_system.dart';
import 'package:get_it/get_it.dart';

/// Advanced example demonstrating queue management and priorities
class AdvancedExamplePage extends StatefulWidget {
  const AdvancedExamplePage({super.key});

  @override
  State<AdvancedExamplePage> createState() => _AdvancedExamplePageState();
}

class _AdvancedExamplePageState extends State<AdvancedExamplePage> {
  final getIt = GetIt.instance;

  @override
  Widget build(BuildContext context) {
    final notificationVM = getIt<NotificationViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Advanced Features')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Priority Notifications',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: () {
                notificationVM.showInfo(
                  message: 'Low priority notification',
                  priority: NotificationPriority.low,
                );
              },
              child: const Text('Low Priority'),
            ),
            const SizedBox(height: 8),

            ElevatedButton(
              onPressed: () {
                notificationVM.showWarning(
                  message: 'High priority notification',
                  priority: NotificationPriority.high,
                );
              },
              child: const Text('High Priority'),
            ),
            const SizedBox(height: 8),

            ElevatedButton(
              onPressed: () {
                notificationVM.showError(
                  ErrorItem(message: 'Critical error occurred!'),
                  priority: NotificationPriority.critical,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Critical Priority'),
            ),
            const SizedBox(height: 24),

            const Text(
              'Queue Management',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: () {
                // Add multiple notifications to queue
                notificationVM.showInfo(
                  message: 'First notification',
                  priority: NotificationPriority.low,
                );
                notificationVM.showInfo(
                  message: 'Second notification',
                  priority: NotificationPriority.normal,
                );
                notificationVM.showWarning(
                  message: 'Third notification (higher priority)',
                  priority: NotificationPriority.high,
                );
              },
              child: const Text('Add Multiple to Queue'),
            ),
            const SizedBox(height: 24),

            const Text(
              'Custom Durations',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: () {
                notificationVM.showSuccess(
                  message: 'Short notification (1 second)',
                  duration: const Duration(seconds: 1),
                );
              },
              child: const Text('Short Duration'),
            ),
            const SizedBox(height: 8),

            ElevatedButton(
              onPressed: () {
                notificationVM.showInfo(
                  message: 'Long notification (10 seconds)',
                  duration: const Duration(seconds: 10),
                );
              },
              child: const Text('Long Duration'),
            ),
          ],
        ),
      ),
    );
  }
}
