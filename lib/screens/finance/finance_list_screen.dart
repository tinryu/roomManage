import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FinanceScreen extends StatelessWidget {
  const FinanceScreen({super.key});

  // Function to fetch data from Supabase
  Future<List<Map<String, dynamic>>> _fetchFinance() async {
    final response = await Supabase.instance.client
        .from('finance')
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
        future: _fetchFinance(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No users found.'));
          } else {
            final finance = snapshot.data!;
            return ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: finance.length,
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
                          'ID: ${finance[index]['id']}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4.0),
                        Text('Amount: ${finance[index]['amount']}'),
                        Text('Date transfer: ${finance[index]['date_trans']}'),
                        Text('Type transfer: ${finance[index]['type']}'),
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
