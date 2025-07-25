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
            return Column(
              children: [
                _buildAppBar(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: isGrid
                        ? _buildGridView(results)
                        : _buildListView(results),
                  ),
                ),
              ],
            );
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
          child: ListTile(
            leading: Image.asset(
              item['imageUrl'],
              width: 60,
              fit: BoxFit.cover,
            ),
            title: Text(
              item['name'],
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Text(item['destription'], style: TextStyle(fontSize: 12)),
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
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
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
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: Image.asset(itemG['imageUrl'], fit: BoxFit.cover),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 12.0, right: 12.0),
                  child: Text(
                    itemG['name'],
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0, right: 12.0),
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

  Widget _buildAppBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          icon: Icon(Icons.filter_list),
          onPressed: () {
            // Handle filter action
            AlertDialog(
              title: Text('Filter Options'),
              content: Text('Implement filter options here.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Close'),
                ),
              ],
            );
          },
        ),
        IconButton(
          icon: Icon(isGrid ? Icons.view_list : Icons.grid_view),
          onPressed: () {
            setState(() {
              isGrid = !isGrid;
            });
          },
        ),
      ],
    );
  }
}
