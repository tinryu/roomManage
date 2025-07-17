import 'package:flutter/material.dart';
import '../../models/room_model.dart';

class RoomDetailScreen extends StatelessWidget {
  final Room detailroom;

  const RoomDetailScreen({super.key, required this.detailroom});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(detailroom.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              detailroom.imageUrl,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16),
            Text(
              detailroom.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(detailroom.destription, style: const TextStyle(fontSize: 12)),
            const SizedBox(height: 16),
            Text(detailroom.content, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
