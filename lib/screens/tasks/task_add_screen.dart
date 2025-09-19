import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:app_project/models/task.dart';
import 'package:app_project/providers/task_provider.dart';
import 'package:intl/intl.dart';
// import 'package:app_project/l10n/app_localizations.dart';

class AddTaskScreen extends ConsumerStatefulWidget {
  const AddTaskScreen({super.key});

  @override
  ConsumerState<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends ConsumerState<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contextController = TextEditingController();
  final Map<int, String> _optionstatus = {
    0: "ToDo",
    1: "In Progress",
    2: "Done",
  };
  int? _status;

  String? _imageUrl;
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();
  DateTime? _dueAt;

  @override
  void dispose() {
    _titleController.dispose();
    _contextController.dispose();
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
        setState(() {
          _imageUrl = image.path;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error picking image: $e')));
      }
    }
  }

  Future<void> _saveTask() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final task = Task(
        createdAt: DateTime.now(),
        title: _titleController.text.trim(),
        context: _contextController.text.trim().isEmpty
            ? null
            : _contextController.text.trim(),
        status: _status,
        imageUrl: _imageUrl,
        dueAt: _dueAt,
      );

      await ref.read(taskProvider.notifier).addTask(task);
      // Refresh the asset list to ensure latest data
      await ref.refresh(taskProvider.future);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Task created successfully!',
              textScaler: TextScaler.linear(0.8),
            ),
            backgroundColor: Colors.green,
          ),
        );
        // Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error creating task: $e',
              textScaler: TextScaler.linear(0.8),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    //  final local = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Task'),
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
              onPressed: _saveTask,
              child: const Text(
                'Save',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
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
            // Title Field
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Task Title',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      textScaler: TextScaler.linear(0.8),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        hintText: 'Enter task title...',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a task title';
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
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Task Status',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      textScaler: TextScaler.linear(0.8),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<int>(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      value: 0,
                      items: _optionstatus.entries
                          .map(
                            (entry) => DropdownMenuItem<int>(
                              value: entry.key,
                              child: Text(entry.value),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _status = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Due Date & Time
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Due date (optional)',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      textScaler: const TextScaler.linear(0.8),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black38),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _dueAt == null
                                  ? 'No due date selected'
                                  : DateFormat('yMMMd • HH:mm').format(_dueAt!),
                              style: const TextStyle(color: Colors.black87),
                              textScaler: const TextScaler.linear(0.8),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        OutlinedButton.icon(
                          onPressed: () async {
                            final now = DateTime.now();
                            final pickedDate = await showDatePicker(
                              context: context,
                              initialDate: _dueAt ?? now,
                              firstDate: DateTime(now.year - 1),
                              lastDate: DateTime(now.year + 5),
                            );
                            if (pickedDate == null) return;
                            final pickedTime = await showTimePicker(
                              // ignore: use_build_context_synchronously
                              context: context,
                              initialTime: TimeOfDay.fromDateTime(
                                _dueAt ?? now,
                              ),
                            );
                            final time =
                                pickedTime ?? TimeOfDay(hour: 9, minute: 0);
                            final combined = DateTime(
                              pickedDate.year,
                              pickedDate.month,
                              pickedDate.day,
                              time.hour,
                              time.minute,
                            );
                            setState(() {
                              _dueAt = combined;
                            });
                          },
                          icon: const Icon(Icons.event),
                          label: const Text('Pick'),
                        ),
                        const SizedBox(width: 8),
                        if (_dueAt != null)
                          IconButton(
                            tooltip: 'Clear',
                            onPressed: () => setState(() => _dueAt = null),
                            icon: const Icon(Icons.clear),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Context Field
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Task Description',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      textScaler: TextScaler.linear(0.8),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _contextController,
                      decoration: const InputDecoration(
                        hintText: 'Enter task description (optional)...',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      maxLines: 4,
                      maxLength: 500,
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
                      'Task Image',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      textScaler: TextScaler.linear(0.8),
                    ),

                    if (_imageUrl != null) ...[
                      Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: _imageUrl!.startsWith('http')
                              ? Image.network(
                                  _imageUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey.shade200,
                                      child: const Center(
                                        child: Icon(
                                          Icons.broken_image,
                                          size: 50,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : Image.file(File(_imageUrl!), fit: BoxFit.cover),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                            onPressed: _pickImage,
                            icon: const Icon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _imageUrl = null;
                              });
                            },
                            icon: const Icon(Icons.delete),
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
