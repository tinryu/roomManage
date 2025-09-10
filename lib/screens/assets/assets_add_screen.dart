import 'dart:io';
import 'package:flutter/material.dart';
import 'package:app_project/models/asset.dart';
import 'package:app_project/providers/asset_provider.dart';
import 'package:app_project/widgets/shared/base_add_screen.dart';
import 'package:app_project/utils/localization_manager.dart';

class AddAssetScreen extends BaseAddScreen<Asset> {
  AddAssetScreen({super.key, super.initialItem})
    : super(
        title: initialItem == null
            ? LocalizationManager.local.addAsset
            : LocalizationManager.local.editAsset,
        submitButtonText: initialItem == null
            ? LocalizationManager.local.addAsset
            : LocalizationManager.local.editAsset,
      );
  @override
  BaseAddScreenState<Asset, AddAssetScreen> createState() =>
      _AssetsAddScreenState();
}

class _AssetsAddScreenState extends BaseAddScreenState<Asset, AddAssetScreen> {
  final _nameController = TextEditingController();
  final _conditionController = TextEditingController();
  final _roomIdController = TextEditingController();
  final _quantityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final a = widget.initialItem;
    if (a != null) {
      _nameController.text = a.name;
      _conditionController.text = a.condition;
      _roomIdController.text = a.roomId.toString();
      _quantityController.text = a.quantity.toString();
      setImagePath(a.imageUrl);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _conditionController.dispose();
    _roomIdController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  void onInit() {}

  @override
  void onDispose() {}

  @override
  Future<void> onSubmit() async {
    final name = _nameController.text.trim();
    final condition = _conditionController.text.trim();
    final quantity = int.parse(_quantityController.text.trim());
    final isEditing = widget.initialItem != null;

    final provider = ref.read(assetProvider.notifier);
    if (isEditing) {
      await provider.updateAsset(
        id: widget.initialItem!.id,
        name: name,
        condition: condition,
        roomId: null,
        quantity: quantity,
        imageFile:
            imagePath != null && imagePath != widget.initialItem?.imageUrl
            ? File(imagePath!)
            : null,
        imageUrl: widget.initialItem?.imageUrl,
      );
    } else {
      await provider.addAsset(
        name: name,
        condition: condition,
        roomId: null,
        quantity: quantity,
        imageFile: imagePath != null ? File(imagePath!) : null,
      );
    }
  }

  @override
  List<Widget> buildFormFields() {
    return [
      _buildImagePicker(),
      const SizedBox(height: 20),
      ..._buildFormFields(),
    ];
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: pickImage,
      child: Center(
        child: Stack(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey[200],
              backgroundImage: imagePath != null
                  ? imagePath!.startsWith('http')
                        ? NetworkImage(imagePath!)
                        : FileImage(File(imagePath!)) as ImageProvider
                  : null,
              child: imagePath == null
                  ? const Icon(Icons.person, size: 60, color: Colors.grey)
                  : null,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildFormFields() {
    return [
      // Asset Name Field
      Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: LocalizationManager.local.assetName,
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter an asset name';
                  }
                  return null;
                },
                maxLength: 100,
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 16),
      // Condition and Quantity Row
      Row(
        children: [
          // Condition Field
          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _conditionController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: LocalizationManager.local.assetCondition,
                        border: OutlineInputBorder(),
                      ),
                      maxLength: 50,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Quantity Field
          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _quantityController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: LocalizationManager.local.quantity,
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          final quantity = int.tryParse(value);
                          if (quantity == null || quantity < 1) {
                            return 'Enter valid quantity';
                          }
                        }
                        return null;
                      },
                      maxLength: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ];
  }
}
