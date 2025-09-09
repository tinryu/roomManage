// ignore_for_file: non_constant_identifier_names
import 'dart:convert';
import 'package:flutter/foundation.dart';

class RoomFull {
  final int roomId;
  final String roomName;
  final bool isOccupied;
  final String? roomImage;
  final List<int>? assetIds;
  final int? tenantId;
  final String? tenantName;
  final String? phone;
  final String? email;
  final DateTime? checkin;
  final DateTime? checkout;

  RoomFull({
    required this.roomId,
    required this.roomName,
    required this.isOccupied,
    this.roomImage,
    this.assetIds,
    this.tenantId,
    this.tenantName,
    this.phone,
    this.email,
    this.checkin,
    this.checkout,
  });

  factory RoomFull.fromMap(Map<String, dynamic> map) {
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

    return RoomFull(
      roomId: map['room_id'],
      roomName: map['room_name'],
      isOccupied: map['is_occupied'],
      roomImage: map['room_image'],
      assetIds: parseAssetIds(map['room_asset_ids']),
      tenantId: map['tenant_id'],
      tenantName: map['tenant_name'],
      phone: map['phone'],
      email: map['email'],
      checkin: map['checkin'] != null ? DateTime.parse(map['checkin']) : null,
      checkout: map['checkout'] != null
          ? DateTime.parse(map['checkout'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'room_id': roomId,
      'room_name': roomName,
      'is_occupied': isOccupied,
      'room_image': roomImage,
      'room_asset_ids': assetIds?.isNotEmpty == true
          ? jsonEncode(assetIds)
          : null,
      'tenant_id': tenantId,
      'tenant_name': tenantName,
      'phone': phone,
      'email': email,
      'checkin': checkin?.toIso8601String(),
      'checkout': checkout?.toIso8601String(),
    };
  }

  RoomFull copyWith({
    int? roomId,
    String? roomName,
    bool? isOccupied,
    String? roomImage,
    List<int>? assetIds,
    int? tenantId,
    String? tenantName,
    String? phone,
    String? email,
    DateTime? checkin,
    DateTime? checkout,
  }) {
    return RoomFull(
      roomId: roomId ?? this.roomId,
      roomName: roomName ?? this.roomName,
      isOccupied: isOccupied ?? this.isOccupied,
      roomImage: roomImage ?? this.roomImage,
      assetIds: assetIds ?? this.assetIds,
      tenantId: tenantId ?? this.tenantId,
      tenantName: tenantName ?? this.tenantName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      checkin: checkin ?? this.checkin,
      checkout: checkout ?? this.checkout,
    );
  }

  @override
  String toString() {
    return 'RoomFull(roomId: $roomId, roomName: $roomName, isOccupied: $isOccupied, roomImage: $roomImage, assetIds: $assetIds, tenantId: $tenantId, tenantName: $tenantName, phone: $phone, email: $email, checkin: $checkin, checkout: $checkout)';
  }
}
