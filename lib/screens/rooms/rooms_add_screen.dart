import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:app_project/models/room.dart';
import 'package:app_project/models/asset.dart';
import 'package:app_project/providers/room_provider.dart';
import 'package:app_project/providers/asset_provider.dart';
import 'package:app_project/providers/tenant_provider.dart';

class AddRoomScreen extends ConsumerStatefulWidget {
  final Room? initialRoom;
  const AddRoomScreen({super.key, this.initialRoom});

  @override
  ConsumerState<AddRoomScreen> createState() => _AddRoomScreenState();
}

class _AddRoomScreenState extends ConsumerState<AddRoomScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _tenantIdController = TextEditingController();
  final List<Asset?> _selectedAssets = [null]; // For dropdown selection

  bool _isOccupied = false;
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();
  String? _imagePath;

  void _addAssetField() {
    setState(() {
      _selectedAssets.add(null);
    });
  }

  void _removeAssetField(int index) {
    if (_selectedAssets.length > 1) {
      // Keep at least one field
      setState(() {
        _selectedAssets.removeAt(index);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    final r = widget.initialRoom;
    if (r != null) {
      _nameController.text = r.name;
      _tenantIdController.text = r.tenantId?.toString() ?? '';
      _isOccupied = r.is_occupied;
      _imagePath = r.imageUrl;

      // Initialize asset selections if they exist
      if (r.asset_ids != null && r.asset_ids!.isNotEmpty) {
        _selectedAssets.clear();
        for (var id in r.asset_ids!) {
          // We'll populate these with actual asset data when the provider loads
          _selectedAssets.add(
            Asset(
              id: id,
              name: 'Loading...',
              condition: '',
              quantity: 1,
              createdAt: DateTime.now(),
            ),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _tenantIdController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );
      if (image != null) {
        setState(() => _imagePath = image.path);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _saveRoom() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final isEditing = widget.initialRoom != null;
      final notifier = ref.read(roomProvider.notifier);
      final name = _nameController.text.trim();
      final isOccupied = _isOccupied;
      final tenantIdString = _tenantIdController.text.trim();

      // Get all non-empty asset IDs
      final assetIds = _selectedAssets
          .where((asset) => asset != null)
          .map((asset) => asset!.id)
          .toList();

      final tenantId = tenantIdString.isNotEmpty
          ? int.tryParse(tenantIdString)
          : null;

      if (isEditing) {
        await notifier.updateRoom(
          id: widget.initialRoom!.id!,
          name: name,
          isOccupied: isOccupied,
          assetIds: assetIds,
          imageFile:
              _imagePath != null && _imagePath != widget.initialRoom?.imageUrl
              ? File(_imagePath!)
              : null,
          tenantId: tenantId,
        );
      } else {
        await notifier.addRoom(
          name: name,
          isOccupied: isOccupied,
          assetIds: assetIds,
          imageFile: _imagePath != null ? File(_imagePath!) : null,
          tenantId: tenantId,
        );
        await ref.refresh(roomProvider.future);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEditing
                  ? 'Room updated successfully!'
                  : 'Room created successfully!',
            ),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving room: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.initialRoom != null ? 'Edit Room' : 'Add New Room'),
        centerTitle: true,
        actions: [
          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
            )
          else
            TextButton(
              onPressed: _saveRoom,
              child: const Text(
                'Save',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Room Name
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Room Name',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textScaler: TextScaler.linear(0.8),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(fontSize: 12),
                      controller: _nameController,
                      decoration: const InputDecoration(
                        hintText: 'Enter room name...',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      validator: (value) =>
                          (value == null || value.trim().isEmpty)
                          ? 'Please enter room name'
                          : null,
                      maxLength: 100,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Tenant ID and Occupied
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tenant ID',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textScaler: TextScaler.linear(0.8),
                          ),
                          const SizedBox(height: 8),
                          Consumer(
                            builder: (context, ref, _) {
                              final tenantsAsync = ref.watch(tenantProvider);
                              // Initialize with the current tenant ID from controller if it exists
                              final selectedTenantId =
                                  _tenantIdController.text.isNotEmpty
                                  ? int.tryParse(_tenantIdController.text)
                                  : null;

                              return tenantsAsync.when(
                                data: (tenants) {
                                  // Add a null option for no tenant
                                  final List<DropdownMenuItem<int>>
                                  tenantOptions = [
                                    const DropdownMenuItem<int>(
                                      value: null,
                                      child: Text(
                                        'Select a tenant',
                                        textScaler: TextScaler.linear(0.8),
                                      ),
                                    ),
                                    ...tenants.map<DropdownMenuItem<int>>(
                                      (tenant) => DropdownMenuItem<int>(
                                        value: tenant.id,
                                        child: Text(
                                          tenant.name,
                                          overflow: TextOverflow.ellipsis,
                                          textScaler: TextScaler.linear(0.8),
                                        ),
                                      ),
                                    ),
                                  ];

                                  return DropdownButtonFormField<int>(
                                    value: selectedTenantId,
                                    items: tenantOptions,
                                    onChanged: (int? value) {
                                      setState(() {
                                        _tenantIdController.text =
                                            value?.toString() ?? '';
                                      });
                                    },
                                    validator: (value) {
                                      // Add validation if needed
                                      return null;
                                    },
                                    hint: const Text('Select a tenant'),
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 8,
                                      ),
                                    ),
                                    isExpanded: true,
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(fontSize: 12),
                                  );
                                },
                                loading: () => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                                error: (error, stack) => Text(
                                  'Error loading tenants',
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.error,
                                      ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _isOccupied ? 'Occupied' : 'Vacant',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textScaler: TextScaler.linear(0.8),
                          ),
                          const SizedBox(height: 8),
                          Switch(
                            value: _isOccupied,
                            onChanged: (v) => setState(() => _isOccupied = v),
                            thumbIcon: _isOccupied
                                ? WidgetStateProperty.all(Icon(Icons.check))
                                : WidgetStateProperty.all(Icon(Icons.close)),
                            activeColor: Theme.of(context).colorScheme.primary,
                            activeTrackColor: Theme.of(
                              context,
                            ).colorScheme.primaryContainer,
                            inactiveTrackColor: Theme.of(
                              context,
                            ).colorScheme.surface,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Asset IDs
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Assets',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                          textScaler: TextScaler.linear(0.8),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Column(
                      children: [
                        ...List.generate(
                          _selectedAssets.length,
                          (index) => Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Consumer(
                                    builder: (context, ref, _) {
                                      final assetsAsync = ref.watch(
                                        assetProvider,
                                      );
                                      return assetsAsync.when(
                                        data: (assets) {
                                          final availableAssets = assets
                                              .where(
                                                (a) => !_selectedAssets.any(
                                                  (selected) =>
                                                      selected != null &&
                                                      selected.id == a.id &&
                                                      _selectedAssets.indexOf(
                                                            selected,
                                                          ) !=
                                                          index,
                                                ),
                                              )
                                              .toList();

                                          return DropdownButtonFormField<Asset>(
                                            value: _selectedAssets[index],
                                            decoration: const InputDecoration(
                                              labelText: 'Select Asset',
                                              border: OutlineInputBorder(),
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 8,
                                                  ),
                                            ),
                                            items: [
                                              const DropdownMenuItem<Asset>(
                                                value: null,
                                                child: Text(
                                                  'Select an asset',
                                                  textScaler: TextScaler.linear(
                                                    0.8,
                                                  ),
                                                ),
                                              ),
                                              ...availableAssets.map(
                                                (asset) =>
                                                    DropdownMenuItem<Asset>(
                                                      value: asset,
                                                      child: Text(
                                                        asset.name,
                                                        textScaler:
                                                            TextScaler.linear(
                                                              0.8,
                                                            ),
                                                      ),
                                                    ),
                                              ),
                                            ],
                                            onChanged: (Asset? newValue) {
                                              setState(() {
                                                _selectedAssets[index] =
                                                    newValue;
                                              });
                                            },
                                            validator: (value) {
                                              if (value == null) {
                                                return 'Please select an asset';
                                              }
                                              return null;
                                            },
                                          );
                                        },
                                        loading: () =>
                                            const CircularProgressIndicator(),
                                        error: (error, stack) => Text(
                                          'Error loading assets: $error',
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                if (_selectedAssets.length > 1)
                                  IconButton(
                                    icon: const Icon(
                                      Icons.remove_circle_outline,
                                      color: Colors.grey,
                                      size: 24,
                                    ),
                                    onPressed: () => _removeAssetField(index),
                                    padding: const EdgeInsets.only(
                                      left: 8,
                                      top: 8,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton.icon(
                            onPressed: _addAssetField,
                            icon: const Icon(
                              Icons.add_circle_outline,
                              size: 20,
                            ),
                            label: const Text(
                              'Add another asset',
                              textScaler: TextScaler.linear(0.8),
                            ),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 0,
                                vertical: 8,
                              ),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Image Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Room Image',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textScaler: TextScaler.linear(0.8),
                    ),
                    const SizedBox(height: 8),
                    if (_imagePath != null) ...[
                      Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: widget.initialRoom != null
                              ? _imagePath != widget.initialRoom?.imageUrl
                                    ? Image.file(
                                        File(_imagePath!),
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Container(
                                                  color: Colors.grey.shade200,
                                                  child: const Center(
                                                    child: Icon(
                                                      Icons.broken_image,
                                                      size: 50,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                      )
                                    : Image.network(
                                        widget.initialRoom!.imageUrl!,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Container(
                                                  color: Colors.grey.shade200,
                                                  child: const Center(
                                                    child: Icon(
                                                      Icons.broken_image,
                                                      size: 50,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                      )
                              : Image.file(
                                  File(_imagePath!),
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                        color: Colors.grey.shade200,
                                        child: const Center(
                                          child: Icon(
                                            Icons.broken_image,
                                            size: 50,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                            onPressed: _pickImage,
                            icon: const Icon(Icons.folder),
                            style: IconButton.styleFrom(
                              foregroundColor: Colors.blue,
                            ),
                          ),
                          IconButton(
                            onPressed: () => setState(() => _imagePath = null),
                            icon: const Icon(Icons.close),
                            style: IconButton.styleFrom(
                              foregroundColor: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ] else ...[
                      InkWell(
                        onTap: _pickImage,
                        child: Container(
                          width: double.infinity,
                          height: 120,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey.shade300,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_photo_alternate,
                                size: 40,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Tap to add image',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textScaler: TextScaler.linear(0.8),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
