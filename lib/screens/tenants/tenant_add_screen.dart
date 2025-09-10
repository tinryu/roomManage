import 'dart:io';

import 'package:app_project/utils/localization_manager.dart';
import 'package:flutter/material.dart';
import 'package:app_project/models/tenant.dart';
import 'package:app_project/providers/tenant_provider.dart';
import 'package:app_project/widgets/shared/base_add_screen.dart';

class AddTenantScreen extends BaseAddScreen<Tenant> {
  AddTenantScreen({super.key, super.initialItem})
    : super(
        title: initialItem == null
            ? LocalizationManager.local.addTenant
            : LocalizationManager.local.editTenant,
        submitButtonText: initialItem == null
            ? LocalizationManager.local.addTenant
            : LocalizationManager.local.editTenant,
      );

  @override
  BaseAddScreenState<Tenant, AddTenantScreen> createState() =>
      _AddTenantScreenState();
}

class _AddTenantScreenState
    extends BaseAddScreenState<Tenant, AddTenantScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  DateTime _checkIn = DateTime.now();
  DateTime? _checkOut;

  @override
  void initState() {
    super.initState();
    final t = widget.initialItem;
    if (t != null) {
      _nameController.text = t.name;
      _phoneController.text = t.phone;
      _emailController.text = t.email ?? '';
      _checkIn = t.checkIn;
      _checkOut = t.checkOut;
      setImagePath(t.imageUrl);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  void onInit() {
    // Additional initialization if needed
  }

  @override
  void onDispose() {
    // Additional cleanup if needed
  }

  Future<void> _pickDate({required bool isCheckIn}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isCheckIn ? _checkIn : (_checkOut ?? DateTime.now()),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          _checkIn = picked;
        } else {
          _checkOut = picked;
        }
      });
    }
  }

  @override
  Future<void> onSubmit() async {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final email = _emailController.text.trim().isEmpty
        ? null
        : _emailController.text.trim();
    final isEditing = widget.initialItem != null;

    final provider = ref.read(tenantProvider.notifier);
    if (isEditing) {
      await provider.updateTenant(
        id: widget.initialItem!.id,
        name: name,
        phone: phone,
        email: email,
        checkIn: _checkIn,
        checkOut: _checkOut,
        imageFile:
            imagePath != null && imagePath != widget.initialItem?.imageUrl
            ? File(imagePath!)
            : null,
        imageUrl: widget.initialItem?.imageUrl,
      );
    } else {
      await provider.addTenant(
        name: name,
        phone: phone,
        email: email,
        checkIn: _checkIn,
        checkOut: _checkOut,
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
      TextFormField(
        controller: _nameController,
        decoration: InputDecoration(
          labelText: LocalizationManager.local.fullName,
          prefixIcon: Icon(Icons.person),
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter tenant name';
          }
          return null;
        },
      ),
      const SizedBox(height: 16),
      TextFormField(
        controller: _phoneController,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          labelText: LocalizationManager.local.phoneNumber,
          prefixIcon: Icon(Icons.phone),
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter phone number';
          }
          return null;
        },
      ),
      SizedBox(height: 16),
      TextFormField(
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          labelText: LocalizationManager.local.email,
          prefixIcon: Icon(Icons.email),
          border: OutlineInputBorder(),
        ),
      ),
      SizedBox(height: 16),
      _buildDateField(
        label: LocalizationManager.local.tenantCheckInDate,
        date: _checkIn,
        onTap: () => _pickDate(isCheckIn: true),
      ),
      SizedBox(height: 16),
      _buildDateField(
        label: LocalizationManager.local.tenantCheckOutDate,
        date: _checkOut,
        onTap: () => _pickDate(isCheckIn: false),
        isOptional: true,
      ),
    ];
  }

  Widget _buildDateField({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
    bool isOptional = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          prefixIcon: const Icon(Icons.calendar_today),
          suffixIcon: isOptional ? null : const Icon(Icons.arrow_drop_down),
        ),
        child: Text(
          date != null
              ? '${date.day}/${date.month}/${date.year}'
              : isOptional
              ? 'Select date (optional)'
              : 'Select date',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}
