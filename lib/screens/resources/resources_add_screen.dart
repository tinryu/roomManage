import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ResourcesAddScreen extends StatefulWidget {
  const ResourcesAddScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ResourcesAddScreenState createState() => _ResourcesAddScreenState();
}

class _ResourcesAddScreenState extends State<ResourcesAddScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();

  final List<String> quantityOptions = ['1', '2', '3', '4', '5'];
  final List<String> roomOptions = [
    'Room 101',
    'Room 102',
    'Room 201',
    'Room 202',
  ];

  String? _selectedQuantity;
  String? _selectedRoom;
  File? _image;

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _image = File(picked.path);
      });
    }
  }

  Future<String?> _uploadImage(File imageFile) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      debugPrint('No user logged in');
      return null;
    }
    final fileName = basename(imageFile.path);
    final fileBytes = await imageFile.readAsBytes();

    final response = await Supabase.instance.client.storage
        .from('images') // your Supabase storage bucket name
        .uploadBinary(
          'uploads/$fileName',
          fileBytes,
          fileOptions: const FileOptions(upsert: true),
        );
    if (response.isNotEmpty) {
      final publicUrl = Supabase.instance.client.storage
          .from('images')
          .getPublicUrl('uploads/$fileName');
      return publicUrl;
    }
    return null;
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    String? imageUrl;
    if (_image != null) {
      imageUrl = await _uploadImage(_image!);
    }
    final response = await Supabase.instance.client.from('resource').insert({
      'name': _nameController.text,
      'quantity': _selectedQuantity,
      'roomid': _selectedRoom,
      'image_url': imageUrl ?? '',
    });

    if (response.error == null) {
      ScaffoldMessenger.of(
        context as BuildContext,
      ).showSnackBar(SnackBar(content: Text('Data submitted successfully!')));
      _formKey.currentState?.reset();
      setState(() {
        _image = null;
        _selectedQuantity = null;
        _selectedRoom = null;
      });
    } else {
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(
        SnackBar(content: Text('Error: ${response.error!.message}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Item')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter name' : null,
              ),
              DropdownButtonFormField<String>(
                value: _selectedQuantity,
                decoration: InputDecoration(labelText: 'Quantity'),
                items: quantityOptions.map((qty) {
                  return DropdownMenuItem(value: qty, child: Text(qty));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedQuantity = value;
                  });
                },
                validator: (value) => value == null ? 'Select quantity' : null,
              ),
              DropdownButtonFormField<String>(
                value: _selectedRoom,
                decoration: InputDecoration(labelText: 'Room Number'),
                items: roomOptions.map((room) {
                  return DropdownMenuItem(value: room, child: Text(room));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedRoom = value;
                  });
                },
                validator: (value) => value == null ? 'Select room' : null,
              ),
              SizedBox(height: 20),
              _image != null
                  ? Image.file(_image!, height: 150)
                  : Text('No image selected'),
              TextButton.icon(
                onPressed: _pickImage,
                icon: Icon(Icons.image),
                label: Text('Upload Image'),
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: _submitForm, child: Text('Submit')),
            ],
          ),
        ),
      ),
    );
  }
}
