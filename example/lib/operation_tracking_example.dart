import 'package:flutter/material.dart';
import 'package:flutter_clean_mvvm_toolkit/flutter_clean_mvvm_toolkit.dart';
import 'package:flutter_notification_system/flutter_notification_system.dart';

/// Example demonstrating CRUD operations with notification tracking
class OperationTrackingExample extends StatefulWidget {
  const OperationTrackingExample({super.key});

  @override
  State<OperationTrackingExample> createState() =>
      _OperationTrackingExampleState();
}

class _OperationTrackingExampleState extends State<OperationTrackingExample> {
  bool _isLoading = false;
  final List<String> _items = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Operation Tracking')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'CRUD Operations with Notifications',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: _isLoading ? null : _createItem,
              icon: const Icon(Icons.add),
              label: const Text('Create Item'),
            ),
            const SizedBox(height: 12),

            ElevatedButton.icon(
              onPressed: _isLoading || _items.isEmpty ? null : _updateItem,
              icon: const Icon(Icons.edit),
              label: const Text('Update First Item'),
            ),
            const SizedBox(height: 12),

            ElevatedButton.icon(
              onPressed: _isLoading || _items.isEmpty ? null : _deleteItem,
              icon: const Icon(Icons.delete),
              label: const Text('Delete First Item'),
            ),
            const SizedBox(height: 12),

            ElevatedButton.icon(
              onPressed: _isLoading ? null : _simulateError,
              icon: const Icon(Icons.error),
              label: const Text('Simulate Error'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 24),

            if (_isLoading) const Center(child: CircularProgressIndicator()),

            const Divider(),
            const SizedBox(height: 16),

            const Text(
              'Items:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            Expanded(
              child: _items.isEmpty
                  ? const Center(
                      child: Text('No items. Create one to get started!'),
                    )
                  : ListView.builder(
                      itemCount: _items.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(child: Text('${index + 1}')),
                            title: Text(_items[index]),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _createItem() async {
    setState(() => _isLoading = true);

    await Future.delayed(const Duration(seconds: 1));

    final newItem = 'Item ${_items.length + 1}';
    setState(() {
      _items.add(newItem);
      _isLoading = false;
    });

    NotificationSystem.showSuccess('Item created successfully!');
  }

  Future<void> _updateItem() async {
    if (_items.isEmpty) return;

    setState(() => _isLoading = true);

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _items[0] = '${_items[0]} (Updated)';
      _isLoading = false;
    });

    NotificationSystem.showSuccess('Item updated successfully!');
  }

  Future<void> _deleteItem() async {
    if (_items.isEmpty) return;

    setState(() => _isLoading = true);

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _items.removeAt(0);
      _isLoading = false;
    });

    NotificationSystem.showSuccess('Item deleted successfully!');
  }

  Future<void> _simulateError() async {
    setState(() => _isLoading = true);

    await Future.delayed(const Duration(seconds: 1));

    setState(() => _isLoading = false);

    NotificationSystem.showError(
      ErrorItem(
        title: 'Error',
        message: 'Connection timeout. Please check your internet.',
        code: ErrorCode.networkError,
        errorLevel: ErrorLevelEnum.severe,
      ),
    );
  }
}
