import 'package:flutter/material.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Users'), backgroundColor: Colors.blue),
      body: const Center(
        child: Text('Users Screen', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
