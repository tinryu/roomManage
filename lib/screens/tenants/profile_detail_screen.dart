import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_project/providers/profile_provider.dart';
import 'package:app_project/models/profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';

class ProfileDetailScreen extends ConsumerStatefulWidget {
  const ProfileDetailScreen({super.key});

  @override
  ConsumerState<ProfileDetailScreen> createState() =>
      _ProfileDetailScreenState();
}

class _ProfileDetailScreenState extends ConsumerState<ProfileDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameCtrl = TextEditingController();
  final _fullNameCtrl = TextEditingController();
  final _avatarUrlCtrl = TextEditingController();

  bool _saving = false;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickAvatar() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );
      if (image == null) return;

      final client = Supabase.instance.client;
      final fileName = "avatars/${DateTime.now().millisecondsSinceEpoch}.jpg";
      await client.storage.from('images').upload(fileName, File(image.path));
      final publicUrl = client.storage.from('images').getPublicUrl(fileName);

      setState(() {
        _avatarUrlCtrl.text = publicUrl;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to pick/upload avatar: $e'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    // Ensure we fetch the latest profile when entering the screen
    // (useful if coming from a cold start or after auth events)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileProvider.notifier).fetchMyProfile();
    });
  }

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _fullNameCtrl.dispose();
    _avatarUrlCtrl.dispose();
    super.dispose();
  }

  void _fillFrom(Profile? p) {
    if (p == null) return;
    _usernameCtrl.text = p.username ?? '';
    _fullNameCtrl.text = p.fullName ?? '';
    _avatarUrlCtrl.text = p.avatarUrl ?? '';
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      await ref
          .read(profileProvider.notifier)
          .updateProfile(
            username: _usernameCtrl.text.trim().isEmpty
                ? null
                : _usernameCtrl.text.trim(),
            fullName: _fullNameCtrl.text.trim().isEmpty
                ? null
                : _fullNameCtrl.text.trim(),
            avatarUrl: _avatarUrlCtrl.text.trim().isEmpty
                ? null
                : _avatarUrlCtrl.text.trim(),
          );
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Profile updated'),
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 2),
          ),
        );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text('Update failed: $e'),
            behavior: SnackBarBehavior.floating,
          ),
        );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final asyncProfile = ref.watch(profileProvider);

    ref.listen(profileProvider, (prev, next) {
      if (next.hasValue) {
        _fillFrom(next.value);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: asyncProfile.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Failed to load profile\n$e')),
        data: (p) {
          // First fill when opened
          if (_usernameCtrl.text.isEmpty &&
              _fullNameCtrl.text.isEmpty &&
              _avatarUrlCtrl.text.isEmpty) {
            _fillFrom(p);
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  Center(
                    child: SizedBox(
                      height: 72,
                      width: 72,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(36),
                        child: Builder(
                          builder: (context) {
                            final url = _avatarUrlCtrl.text.isNotEmpty
                                ? _avatarUrlCtrl.text
                                : (p?.avatarUrl ?? '');
                            if (url.isEmpty) {
                              return Container(
                                color: Colors.grey.shade200,
                                child: const Icon(Icons.person, size: 36),
                              );
                            }
                            return Image.network(
                              url,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stack) =>
                                  Container(
                                    color: Colors.grey.shade200,
                                    child: const Icon(
                                      Icons.broken_image,
                                      size: 36,
                                    ),
                                  ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: _saving ? null : _pickAvatar,
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Choose avatar'),
                  ),
                  const SizedBox(height: 12),
                  // Read-only email from Supabase Auth
                  TextFormField(
                    initialValue:
                        Supabase.instance.client.auth.currentUser?.email ?? '',
                    decoration: const InputDecoration(labelText: 'Email'),
                    readOnly: true,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _usernameCtrl,
                    decoration: const InputDecoration(labelText: 'Username'),
                    maxLength: 50,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _fullNameCtrl,
                    decoration: const InputDecoration(labelText: 'Full name'),
                    maxLength: 100,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _avatarUrlCtrl,
                    decoration: InputDecoration(
                      labelText: 'Avatar URL',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.photo_camera_back_outlined),
                        onPressed: _saving ? null : _pickAvatar,
                        tooltip: 'Pick & upload image',
                      ),
                    ),
                    keyboardType: TextInputType.url,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
