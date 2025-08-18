import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:app_project/models/asset.dart';

class AssetNotifier extends AsyncNotifier<List<Asset>> {
  final supabase = Supabase.instance.client;
  final String _table = 'assets';

  static const int _pageSize = 10;
  int _offset = 0;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  @override
  Future<List<Asset>> build() async {
    _offset = 0;
    _hasMore = true;
    return await _fetchAssets(reset: true);
  }

  Future<void> updateAsset({
    required int id,
    required String name,
    required String condition,
    required String roomId,
    required int quantity,
    String? imageUrl,
  }) async {
    try {
      final data = {
        'name': name,
        'condition': condition,
        'roomid': roomId,
        'quantity': quantity,
        if (imageUrl != null) 'image_url': imageUrl,
      };
      final res = await supabase
          .from(_table)
          .update(data)
          .eq('id', id as Object)
          .select()
          .single();
      final updated = Asset.fromMap(res);
      final current = state.value ?? [];
      state = AsyncData(current.map((a) => a.id == updated.id ? updated : a).toList());
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }

  Future<void> deleteAssets(List<int> ids) async {
    if (ids.isEmpty) return;
    try {
      await supabase.from(_table).delete().inFilter('id', ids);
      final idSet = ids.toSet();
      final current = state.value ?? [];
      state = AsyncData(current.where((a) => !idSet.contains(a.id)).toList());
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }

  Future<List<Asset>> _fetchAssets({bool reset = false}) async {
    if (_isLoadingMore) return state.value ?? [];

    _isLoadingMore = true;

    try {
      final res = await supabase
          .from(_table)
          .select()
          .order('created_at', ascending: false)
          .range(_offset, _offset + _pageSize - 1);
      final data = res as List;
      final fetched = data.map((e) => Asset.fromMap(e)).toList();

      if (reset) {
        _offset = fetched.length;
        state = AsyncData(fetched);
      } else {
        _offset += fetched.length;
        final current = state.value ?? [];
        state = AsyncData([...current, ...fetched]);
      }

      if (fetched.length < _pageSize) {
        _hasMore = false;
      }

      return fetched;
    } catch (e, st) {
      if (reset) {
        state = AsyncError(e, st);
      }
      return [];
    } finally {
      _isLoadingMore = false;
    }
  }

  Future<void> fetchNextPage() async {
    if (_hasMore) {
      await _fetchAssets();
    }
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

  Future<void> addAsset({
    required String name,
    required String condition,
    required String roomId,
    required int quantity,
    File? imageFile,
  }) async {
    state = const AsyncValue.loading();

    try {
      String? imageUrl;
      if (imageFile != null) {
        imageUrl = await _uploadImage(imageFile);
      }

      final data = {
        'name': name,
        'condition': condition,
        'roomid': roomId,
        'quantity': quantity,
        'image_url': imageUrl ?? '',
        'created_at': DateTime.now().toIso8601String(),
      };

      await supabase.from('assets').insert(data);
      state = AsyncValue.data(await _fetchAssets());
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  bool get hasMore => _hasMore;
  bool get isLoadingMore => _isLoadingMore;
}

// Provider để dùng trong app
final assetProvider = AsyncNotifierProvider<AssetNotifier, List<Asset>>(
  () => AssetNotifier(),
);
