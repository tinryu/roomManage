import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:app_project/providers/asset_provider.dart';

class AddAssetScreen extends ConsumerStatefulWidget {
  const AddAssetScreen({super.key});

  @override
  ConsumerState<AddAssetScreen> createState() => _AddAssetScreenState();
}

class _AddAssetScreenState extends ConsumerState<AddAssetScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _conditionCtrl = TextEditingController();
  final TextEditingController _roomIdCtrl = TextEditingController();
  final TextEditingController _quantityCtrl = TextEditingController();

  File? _imageFile;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _imageFile = File(picked.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    final assetState = ref.watch(assetProvider);
    final assetNotifier = ref.read(assetProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Asset"),
        backgroundColor: const Color(0xFF4DB6E2),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: "Name"),
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),
              TextFormField(
                controller: _conditionCtrl,
                decoration: const InputDecoration(labelText: "Condition"),
              ),
              TextFormField(
                controller: _roomIdCtrl,
                decoration: const InputDecoration(labelText: "Room ID"),
              ),
              TextFormField(
                controller: _quantityCtrl,
                decoration: const InputDecoration(labelText: "Quantity"),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              _imageFile != null
                  ? Image.file(_imageFile!, height: 120)
                  : const SizedBox(),
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.image),
                label: const Text("Pick Image"),
              ),
              const SizedBox(height: 16),
              if (assetState.hasError)
                Text(
                  assetState.error.toString(),
                  style: const TextStyle(color: Colors.red),
                ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4DB6E2),
                ),
                onPressed: assetState.isLoading
                    ? null
                    : () async {
                        if (_formKey.currentState!.validate()) {
                          // Capture context before async operation
                          final navigator = Navigator.of(context);

                          await assetNotifier.addAsset(
                            name: _nameCtrl.text,
                            condition: _conditionCtrl.text,
                            roomId: _roomIdCtrl.text,
                            quantity: int.tryParse(_quantityCtrl.text) ?? 0,
                            imageFile: _imageFile,
                          );

                          // Use mounted check before navigation
                          if (mounted && !assetState.hasError) {
                            navigator.pop(true);
                          }
                        }
                      },
                child: assetState.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Save Asset"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
