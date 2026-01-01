import 'package:flutter/material.dart';
import 'package:flutter_notification_system/flutter_notification_system.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

final getIt = GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Register notification module
  registerNotificationModule(getIt);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NotificationViewModel>.value(
      value: getIt<NotificationViewModel>(),
      child: Consumer<NotificationViewModel>(
        builder: (context, viewModel, _) {
          viewModel.setAppContext(context);

          return AppNotificationListener(
            child: MaterialApp(
              title: 'Flutter Notification System Example',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
                useMaterial3: true,
              ),
              home: const ExampleHomePage(),
            ),
          );
        },
      ),
    );
  }
}

class ExampleHomePage extends StatelessWidget {
  const ExampleHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final notificationVM = getIt<NotificationViewModel>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Notification System Example'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Basic Notifications',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Success notification
              ElevatedButton.icon(
                onPressed: () {
                  notificationVM.showSuccess(
                    message: 'Operation completed successfully!',
                  );
                },
                icon: const Icon(Icons.check_circle),
                label: const Text('Show Success'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 12),

              // Error notification
              ElevatedButton.icon(
                onPressed: () {
                  notificationVM.showError(
                    ErrorItem(message: 'An error occurred. Please try again.'),
                  );
                },
                icon: const Icon(Icons.error),
                label: const Text('Show Error'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 12),

              // Warning notification
              ElevatedButton.icon(
                onPressed: () {
                  notificationVM.showWarning(
                    message: 'This is a warning message.',
                  );
                },
                icon: const Icon(Icons.warning),
                label: const Text('Show Warning'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 12),

              // Info notification
              ElevatedButton.icon(
                onPressed: () {
                  notificationVM.showInfo(
                    message: 'Here is some useful information.',
                  );
                },
                icon: const Icon(Icons.info),
                label: const Text('Show Info'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 32),

              const Divider(),
              const SizedBox(height: 16),

              const Text(
                'Priority Notifications',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Critical priority
              ElevatedButton.icon(
                onPressed: () {
                  notificationVM.showError(
                    ErrorItem(message: 'Critical: Immediate action required!'),
                    priority: NotificationPriority.critical,
                  );
                },
                icon: const Icon(Icons.priority_high),
                label: const Text('Critical Priority'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade900,
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 12),

              // High priority
              ElevatedButton.icon(
                onPressed: () {
                  notificationVM.showWarning(
                    message: 'High priority notification',
                    priority: NotificationPriority.high,
                  );
                },
                icon: const Icon(Icons.arrow_upward),
                label: const Text('High Priority'),
              ),
              const SizedBox(height: 32),

              const Divider(),
              const SizedBox(height: 16),

              const Text(
                'Dialog Notifications',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Dialog with action
              ElevatedButton.icon(
                onPressed: () {
                  notificationVM.showError(
                    ErrorItem(
                      message:
                          'Are you sure you want to proceed? This action cannot be undone.',
                    ),
                    priority: NotificationPriority.critical,
                  );
                },
                icon: const Icon(Icons.question_answer),
                label: const Text('Show Dialog'),
              ),
              const SizedBox(height: 32),

              const Divider(),
              const SizedBox(height: 16),

              const Text(
                'Custom Duration',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Long duration
              ElevatedButton.icon(
                onPressed: () {
                  notificationVM.showInfo(
                    message: 'This notification will stay for 5 seconds',
                    duration: const Duration(seconds: 5),
                  );
                },
                icon: const Icon(Icons.timer),
                label: const Text('Long Duration (5s)'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
