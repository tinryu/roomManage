import 'dart:io';
import 'package:app_project/providers/asset_provider.dart';
import 'package:app_project/providers/tenant_provider.dart';
import 'package:app_project/utils/localization_manager.dart';
import 'package:flutter/material.dart';
import 'package:app_project/models/room.dart';
import 'package:app_project/models/asset.dart';
import 'package:app_project/providers/room_provider.dart';
import 'package:app_project/widgets/shared/base_add_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddRoomScreen extends BaseAddScreen<Room> {
  AddRoomScreen({super.key, super.initialItem})
    : super(
        title: initialItem == null
            ? LocalizationManager.local.addRoom
            : LocalizationManager.local.editRoom,
        submitButtonText: initialItem == null
            ? LocalizationManager.local.addRoom
            : LocalizationManager.local.editRoom,
      );
  @override
  BaseAddScreenState<Room, AddRoomScreen> createState() =>
      _AddRoomScreenState();
}

class _AddRoomScreenState extends BaseAddScreenState<Room, AddRoomScreen> {
  final _nameController = TextEditingController();
  final _tenantIdController = TextEditingController();
  final List<Asset?> _selectedAssets = [null]; // For dropdown selection
  bool _isOccupied = false;

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
    final r = widget.initialItem;
    if (r != null) {
      _nameController.text = r.name;
      _tenantIdController.text = r.tenantId?.toString() ?? '';
      _isOccupied = r.is_occupied;
      setImagePath(r.imageUrl);

      // Initialize asset selections if they exist
      if (r.asset_ids != null && r.asset_ids!.isNotEmpty) {
        _selectedAssets.clear();
        for (var id in r.asset_ids!) {
          // We'll populate these with actual asset data when the provider loads
          _selectedAssets.add(
            Asset(
              id: id,
              name: LocalizationManager.local.loading,
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

  @override
  void onInit() {}

  @override
  void onDispose() {}

  @override
  Future<void> onSubmit() async {
    final name = _nameController.text.trim();
    final tenantIdString = _tenantIdController.text.trim();
    final isOccupied = _isOccupied;
    final assetIds = _selectedAssets
        .where((asset) => asset != null)
        .map((asset) => asset!.id)
        .toList();
    final tenantId = tenantIdString.isNotEmpty
        ? int.tryParse(tenantIdString)
        : null;
    final provider = ref.read(roomProvider.notifier);
    if (widget.initialItem != null) {
      await provider.updateRoom(
        id: widget.initialItem!.id!,
        name: name,
        isOccupied: isOccupied,
        assetIds: assetIds,
        imageFile:
            imagePath != null && imagePath != widget.initialItem?.imageUrl
            ? File(imagePath!)
            : null,
        tenantId: tenantId,
        imageUrl: widget.initialItem?.imageUrl,
      );
    } else {
      await provider.addRoom(
        name: name,
        isOccupied: isOccupied,
        assetIds: assetIds,
        imageFile: imagePath != null ? File(imagePath!) : null,
        tenantId: tenantId,
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
      // Room Name
      Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  labelText: LocalizationManager.local.roomName,
                  border: OutlineInputBorder(),
                ),
                validator: (value) => (value == null || value.trim().isEmpty)
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
                            final List<DropdownMenuItem<int>> tenantOptions = [
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
                                labelText: 'Tenant ID',
                              ),
                              isExpanded: true,
                              style: Theme.of(
                                context,
                              ).textTheme.bodySmall?.copyWith(fontSize: 12),
                            );
                          },
                          loading: () =>
                              const Center(child: CircularProgressIndicator()),
                          error: (error, stack) => Text(
                            'Error loading tenants',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.error,
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
          const SizedBox(width: 10),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 6.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isOccupied
                        ? LocalizationManager.local.roomStatusOccupied
                        : LocalizationManager.local.roomStatusVacant,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
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
                    inactiveTrackColor: Theme.of(context).colorScheme.surface,
                  ),
                ],
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
                                final assetsAsync = ref.watch(assetProvider);
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
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 8,
                                        ),
                                      ),
                                      items: [
                                        const DropdownMenuItem<Asset>(
                                          value: null,
                                          child: Text(
                                            'Select an asset',
                                            textScaler: TextScaler.linear(0.8),
                                          ),
                                        ),
                                        ...availableAssets.map(
                                          (asset) => DropdownMenuItem<Asset>(
                                            value: asset,
                                            child: Text(
                                              asset.name,
                                              textScaler: TextScaler.linear(
                                                0.8,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                      onChanged: (Asset? newValue) {
                                        setState(() {
                                          _selectedAssets[index] = newValue;
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
                                  error: (error, stack) =>
                                      Text('Error loading assets: $error'),
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
                              padding: const EdgeInsets.only(left: 8, top: 8),
                            ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: _addAssetField,
                      icon: const Icon(Icons.add_circle_outline, size: 20),
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
    ];
  }
}
