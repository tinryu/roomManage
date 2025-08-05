import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RoomDropdown extends StatefulWidget {
  final void Function(Map<String, dynamic>?) onRoomSelected;

  const RoomDropdown({super.key, required this.onRoomSelected});

  @override
  // ignore: library_private_types_in_public_api
  _RoomDropdownState createState() => _RoomDropdownState();
}

class _RoomDropdownState extends State<RoomDropdown> {
  List<Map<String, dynamic>> _rooms = [];
  Map<String, dynamic>? _selectedRoom;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchRooms();
  }

  Future<void> _fetchRooms() async {
    final response = await Supabase.instance.client
        .from('rooms')
        .select('id, name')
        .order('name');

    setState(() {
      _rooms = List<Map<String, dynamic>>.from(response);
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return CircularProgressIndicator();

    return DropdownButtonFormField<Map<String, dynamic>>(
      value: _selectedRoom,
      decoration: InputDecoration(labelText: 'Select Room'),
      items: _rooms.map((room) {
        return DropdownMenuItem(value: room, child: Text(room['name']));
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedRoom = value;
        });
        widget.onRoomSelected(value);
      },
      validator: (value) => value == null ? 'Please select a room' : null,
    );
  }
}
