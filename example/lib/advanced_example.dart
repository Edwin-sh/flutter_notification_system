import 'package:flutter/material.dart';
import 'package:flutter_clean_mvvm_toolkit/flutter_clean_mvvm_toolkit.dart';
import 'package:flutter_notification_system/flutter_notification_system.dart';

/// Advanced example demonstrating queue management and priorities
class AdvancedExamplePage extends StatefulWidget {
  const AdvancedExamplePage({super.key});

  @override
  State<AdvancedExamplePage> createState() => _AdvancedExamplePageState();
}

class _AdvancedExamplePageState extends State<AdvancedExamplePage> {
  @override
  Widget build(BuildContext context) {
    // Ya no es necesario obtener el ViewModel de GetIt
    // Se puede usar context.notifications o NotificationSystem directamente

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
                context.showInfo(
                  'Low priority notification',
                  priority: NotificationPriority.low,
                );
              },
              child: const Text('Low Priority'),
            ),
            const SizedBox(height: 8),

            ElevatedButton(
              onPressed: () {
                context.showWarning(
                  'High priority notification',
                  priority: NotificationPriority.high,
                );
              },
              child: const Text('High Priority'),
            ),
            const SizedBox(height: 8),

            ElevatedButton(
              onPressed: () {
                context.showError(
                  ErrorItem(title: 'Error', message: 'Critical error occurred!', code: ErrorCode.unknownError),
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
                NotificationSystem.showInfo(
                  'First notification',
                  priority: NotificationPriority.low,
                );
                NotificationSystem.showInfo(
                  'Second notification',
                  priority: NotificationPriority.normal,
                );
                NotificationSystem.showWarning(
                  'Third notification (higher priority)',
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
                context.showSuccess(
                  'Short notification (1 second)',
                  duration: const Duration(seconds: 1),
                );
              },
              child: const Text('Short Duration'),
            ),
            const SizedBox(height: 8),

            ElevatedButton(
              onPressed: () {
                context.showInfo(
                  'Long notification (10 seconds)',
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
