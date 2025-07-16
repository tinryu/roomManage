import 'package:app_project/l10n/app_localizations.dart';
import 'package:app_project/screens/rooms/room_details_screen.dart'
    show RoomDetailScreen;
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/room_model.dart';

class RoomListScreen extends StatefulWidget {
  const RoomListScreen({super.key});

  // Function to fetch data from Supabase
  Future<List<Map<String, dynamic>>> _fetchRooms() async {
    final response = await Supabase.instance.client
        .from('rooms')
        .select()
        .then((data) => data)
        .catchError((error) {
          throw Exception('Error fetching data: $error');
        });
    return response;
  }

  @override
  State<RoomListScreen> createState() => _RoomListScreenState();
}

class _RoomListScreenState extends State<RoomListScreen> {
  bool isGrid = false;
  late List<Room> rooms;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.rooms,
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(icon: Icon(Icons.filter_list), onPressed: () {}),
          IconButton(
            icon: Icon(isGrid ? Icons.view_list : Icons.grid_view),
            onPressed: () {
              setState(() {
                isGrid = !isGrid;
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: widget._fetchRooms(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No rooms found.'));
          } else {
            final rooms = snapshot.data!;

            List<Object> results = rooms.map((room) => room as Object).toList();
            debugPrint('Rooms: $results');
            return isGrid ? _buildGridView(results) : _buildListView(results);
          }
        },
      ),
    );
  }

  Widget _buildListView(rooms) {
    var rooml = rooms; // Example to access room data
    return ListView.builder(
      itemCount: rooml.length,
      itemBuilder: (context, index) {
        var item = rooml[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            // leading: Image.asset(room.imageUrl, width: 60, fit: BoxFit.cover),
            title: Text(item['name']),
            subtitle: Text(item['destription']),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      RoomDetailScreen(detailroom: Room.fromJson(item)),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildGridView(rooms) {
    var roomG = rooms; // Example to acces
    return GridView.builder(
      itemCount: rooms.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        var itemG = roomG[index];
        return Card(
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      RoomDetailScreen(detailroom: Room.fromJson(itemG)),
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image.asset(
                //   room.imageUrl,
                //   height: 100,
                //   width: double.infinity,
                //   fit: BoxFit.cover,
                // ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    itemG['name'],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    itemG['destription'],
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
