import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  // Function to fetch data from Supabase
  Future<List<Map<String, dynamic>>> _fetchClients() async {
    final response = await Supabase.instance.client
        .from('clients')
        .select()
        .then((data) => data)
        .catchError((error) {
          throw Exception('Error fetching data: $error');
        });
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Users'), backgroundColor: Colors.blue),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchClients(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No users found.'));
          } else {
            final client = snapshot.data!;
            return ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: client.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ID: ${client[index]['id']}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4.0),
                        Text('Name: ${client[index]['name']}'),
                        Text('Email: ${client[index]['email']}'),
                        Text('Phone: ${client[index]['phone']}'),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
