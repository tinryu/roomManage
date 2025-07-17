import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ResourcesScreen extends StatelessWidget {
  const ResourcesScreen({super.key});

  // Function to fetch data from Supabase
  Future<List<Map<String, dynamic>>> _fetchResources() async {
    final response = await Supabase.instance.client
        .from('resource')
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
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchResources(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No users found.'));
          } else {
            final resource = snapshot.data!;
            return ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: resource.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 8.0,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ID: ${resource[index]['id']}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4.0),
                        Text('Name: ${resource[index]['name']}'),
                        Text('Quantity: ${resource[index]['quantity']}'),
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
