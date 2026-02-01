import 'package:flutter/material.dart';

import '../router/app_router.dart';

/// Profile Page - Displays user profile information
/// Supports query parameters: userId, name, tab
class ProfilePage extends StatelessWidget {
  final String? userId;
  final String? name;
  final String? tab;

  const ProfilePage({super.key, this.userId, this.name, this.tab});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Profile'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.person, size: 100, color: Colors.deepPurple),
              const SizedBox(height: 20),
              const Text('Profile Page', style: TextStyle(fontSize: 24)),
              const SizedBox(height: 30),

              // Query Parameters Card
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Query Parameters:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(),
                      _buildParamRow('userId', userId),
                      _buildParamRow('name', name),
                      _buildParamRow('tab', tab),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => const HomeRoute().go(context),
                child: const Text('Back to Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildParamRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w500)),
          Expanded(
            child: Text(
              value ?? 'null',
              style: TextStyle(
                color: value != null ? Colors.deepPurple : Colors.grey,
                fontStyle: value != null ? FontStyle.normal : FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
