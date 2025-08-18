import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:app_project/models/task.dart';

class TaskNotifier extends AsyncNotifier<List<Task>> {
  final supabase = Supabase.instance.client;
  final String _table = 'tasks';

  static const int _pageSize = 10;
  int _offset = 0;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  @override
  Future<List<Task>> build() async {
    _offset = 0;
    _hasMore = true;
    return await _fetchTasks(reset: true);
  }

  Future<List<Task>> _fetchTasks({bool reset = false}) async {
    if (_isLoadingMore) return state.value ?? [];

    _isLoadingMore = true;

    try {
      final res = await supabase
          .from(_table)
          .select()
          .order('created_at', ascending: false)
          .range(_offset, _offset + _pageSize - 1);
      final data = res as List;
      final fetched = data.map((e) => Task.fromMap(e)).toList();

      if (reset) {
        _offset = fetched.length;
        state = AsyncData(fetched);
      } else {
        _offset += fetched.length;
        final current = state.value ?? [];
        state = AsyncData([...current, ...fetched]);
      }

      _hasMore = fetched.length == _pageSize;
      _isLoadingMore = false;
      return state.value ?? [];
    } catch (e) {
      _isLoadingMore = false;
      state = AsyncError(e, StackTrace.current);
      rethrow;
    }
  }

  Future<void> loadMore() async {
    if (!_hasMore || _isLoadingMore) return;
    await _fetchTasks();
  }

  Future<List<Task>> getUpcomingTasks({
    int? year,
    int? month,
    int? limit,
  }) async {
    final now = DateTime.now();
    final selectedYear = year ?? now.year;
    final selectedMonth = month ?? now.month;

    // Start and end of the month
    final start = DateTime(selectedYear, selectedMonth, 1);
    final end = DateTime(
      selectedYear,
      selectedMonth + 1,
      1,
    ).subtract(Duration(seconds: 1));
    final response = await supabase
        .from(_table)
        .select()
        .gte('created_at', start.toIso8601String())
        .lte('created_at', end.toIso8601String())
        .order('created_at', ascending: true)
        .limit(limit ?? 5);

    return (response as List)
        .map((item) => Task.fromMap(item as Map<String, dynamic>))
        .toList();
  }

  Future<String?> _uploadImage(File file) async {
    try {
      final fileName = "uploads/${DateTime.now().millisecondsSinceEpoch}.jpg";
      await supabase.storage.from('images').upload(fileName, file);
      return supabase.storage.from('images').getPublicUrl(fileName);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return null;
    }
  }

  Future<void> addTask(Task task) async {
    try {
      String? imageUrl;
      if (task.imageUrl != null) {
        imageUrl = await _uploadImage(File(task.imageUrl!));
      }
      final data = {
        'title': task.title,
        'context': task.context,
        'image_url': imageUrl ?? '',
        'created_at': DateTime.now().toIso8601String(),
      };
      final res = await supabase.from(_table).insert(data).select().single();

      final newTask = Task.fromMap(res);
      final current = state.value ?? [];
      state = AsyncData([newTask, ...current]);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      rethrow;
    }
  }

  Future<void> updateTask(Task task) async {
    try {
      await supabase.from(_table).update(task.toMap()).eq('id', task.id!);

      final current = state.value ?? [];
      final index = current.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        current[index] = task;
        state = AsyncData([...current]);
      }
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      rethrow;
    }
  }

  Future<void> _deleteImage(String imageUrl) async {
    try {
      // Extract filename from the full URL
      final uri = Uri.parse(imageUrl);
      final pathSegments = uri.pathSegments;

      // Find the filename after 'images' in the path
      final imagesIndex = pathSegments.indexOf('images');
      if (imagesIndex != -1 && imagesIndex < pathSegments.length - 1) {
        final fileName = pathSegments.sublist(imagesIndex + 1).join('/');
        await supabase.storage.from('images').remove([fileName]);
      }
    } catch (e) {
      // Log error but don't throw - we still want to delete the task even if image deletion fails
      // ignore: avoid_print
      print('Failed to delete image: $e');
    }
  }

  Future<void> deleteTask(int id) async {
    try {
      // First, find the task to get its image URL
      final current = state.value ?? [];
      final taskToDelete = current.firstWhere((task) => task.id == id);

      // Delete associated image if it exists
      if (taskToDelete.imageUrl != null && taskToDelete.imageUrl!.isNotEmpty) {
        await _deleteImage(taskToDelete.imageUrl!);
      }

      // Then delete the task from database
      await supabase.from(_table).delete().eq('id', id);

      // Update local state
      final updated = current.where((task) => task.id != id).toList();
      state = AsyncData(updated);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      rethrow;
    }
  }

  Future<void> refresh() async {
    _offset = 0;
    _hasMore = true;
    await _fetchTasks(reset: true);
  }
}

final taskProvider = AsyncNotifierProvider<TaskNotifier, List<Task>>(
  () => TaskNotifier(),
);
