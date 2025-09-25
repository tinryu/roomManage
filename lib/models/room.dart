// ignore_for_file: non_constant_identifier_names
import 'dart:convert';
import 'package:flutter/foundation.dart';

class Room {
  final int? id;
  final String name;
  final bool is_occupied;
  final String? imageUrl;
  final int? tenantId;
  final List<int>? asset_ids;
  final DateTime? checkIn;
  final DateTime? checkOut;

  Room({
    this.id,
    required this.name,
    this.is_occupied = false,
    this.asset_ids,
    this.imageUrl,
    this.tenantId,
    this.checkIn,
    this.checkOut,
  });

  factory Room.fromMap(Map<String, dynamic> map) {
    // Handle different formats of asset_ids
    List<int>? parseAssetIds(dynamic ids) {
      if (ids == null) return null;

      try {
        // If it's a string that looks like a JSON array
        if (ids is String &&
            ids.trim().startsWith('[') &&
            ids.trim().endsWith(']')) {
          final parsed = jsonDecode(ids) as List;
          return parsed
              .map((e) => int.tryParse(e.toString()))
              .whereType<int>()
              .toList();
        }
        // If it's already a List
        else if (ids is List) {
          return ids
              .map((e) => int.tryParse(e.toString()))
              .whereType<int>()
              .toList();
        }
        // If it's a comma-separated string
        else if (ids is String) {
          return ids
              .split(',')
              .map((e) => int.tryParse(e.trim()))
              .whereType<int>()
              .toList();
        }
      } catch (e) {
        debugPrint('Error parsing asset_ids: $e');
      }

      return [];
    }

    return Room(
      id: map['id'],
      name: map['name'],
      is_occupied: map['is_occupied'] ?? false,
      asset_ids: parseAssetIds(map['asset_ids']),
      imageUrl: map['image_url'] ?? '',
      tenantId: map['tenant_id'] ?? 0,
      checkIn: map['check_in'] != null ? DateTime.parse(map['check_in']) : null,
      checkOut: map['check_out'] != null
          ? DateTime.parse(map['check_out'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'is_occupied': is_occupied,
      'asset_ids': asset_ids?.isNotEmpty == true ? jsonEncode(asset_ids) : null,
      'image_url': imageUrl,
      'tenant_id': tenantId,
      'check_in': checkIn,
      'check_out': checkOut,
    };
  }

  Room copyWith({
    int? id,
    String? name,
    bool? is_occupied,
    List<int>? asset_ids,
    String? imageUrl,
    int? tenantId,
    DateTime? checkIn,
    DateTime? checkOut,
  }) {
    return Room(
      id: id ?? this.id,
      name: name ?? this.name,
      is_occupied: is_occupied ?? this.is_occupied,
      asset_ids: asset_ids ?? this.asset_ids,
      imageUrl: imageUrl ?? this.imageUrl,
      tenantId: tenantId ?? this.tenantId,
      checkIn: checkIn ?? this.checkIn,
      checkOut: checkOut ?? this.checkOut,
    );
  }

  @override
  String toString() {
    return 'Room(id: $id, name: $name, is_occupied: $is_occupied, asset_ids: $asset_ids, imageUrl: $imageUrl, tenantId: $tenantId)';
  }
}
