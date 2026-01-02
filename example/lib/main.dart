import 'package:flutter/material.dart';
import 'package:flutter_notification_system/flutter_notification_system.dart';

void main() {
  // Ya NO es necesario inicializar GetIt ni registrar el módulo
  // La librería se encarga de todo automáticamente
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Solo es necesario envolver con AppNotificationListener
    // El listener se encarga de:
    // - Registrar GetIt automáticamente
    // - Configurar ChangeNotifierProvider
    // - Escuchar y mostrar notificaciones
    return AppNotificationListener(
      // Configuración opcional del sistema
      config: NotificationConfig(maxQueueSize: 10),
      // Tema opcional personalizado
      // theme: NotificationTheme.dark(),
      child: MaterialApp(
        title: 'Flutter Notification System Example',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const ExampleHomePage(),
      ),
    );
  }
}

class ExampleHomePage extends StatelessWidget {
  const ExampleHomePage({super.key});

  @override
  Widget build(BuildContext context) {
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

              // Método 1: Usando BuildContext extension
              ElevatedButton.icon(
                onPressed: () {
                  context.showSuccess('Operation completed successfully!');
                },
                icon: const Icon(Icons.check_circle),
                label: const Text('Success (usando context)'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 12),

              // Método 2: Usando NotificationSystem estático
              ElevatedButton.icon(
                onPressed: () {
                  NotificationSystem.showError(
                    ErrorItem(message: 'An error occurred. Please try again.'),
                  );
                },
                icon: const Icon(Icons.error),
                label: const Text('Error (usando NotificationSystem)'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 12),

              // Warning notification
              ElevatedButton.icon(
                onPressed: () {
                  context.showWarning('This is a warning message!');
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
                  NotificationSystem.showInfo(
                    'This is an informative message',
                    duration: const Duration(seconds: 4),
                  );
                },
                icon: const Icon(Icons.info),
                label: const Text('Info (usando helper)'),
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
                  context.showError(
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
                  NotificationSystem.showWarning(
                    'High priority notification',
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
                'Custom Duration',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Long duration
              ElevatedButton.icon(
                onPressed: () {
                  context.showInfo(
                    'This notification will stay for 5 seconds',
                    duration: const Duration(seconds: 5),
                  );
                },
                icon: const Icon(Icons.timer),
                label: const Text('Long Duration (5s)'),
              ),
              const SizedBox(height: 12),

              // Short duration
              ElevatedButton.icon(
                onPressed: () {
                  NotificationSystem.showSuccess(
                    'Quick message!',
                    duration: const Duration(seconds: 1),
                  );
                },
                icon: const Icon(Icons.flash_on),
                label: const Text('Short Duration (1s)'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
