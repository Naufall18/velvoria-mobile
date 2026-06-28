// @JsonKey is applied to constructor parameters (Freezed pattern); the analyzer
// flags this as invalid_annotation_target even though codegen handles it correctly.
// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/user.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// User model - Data layer
/// Handles JSON serialization/deserialization
@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String email,
    required String name,
    @JsonKey(name: 'phone_number') String? phoneNumber,
    String? avatar,
    required String role,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
  }) = _UserModel;

  const UserModel._();

  /// From JSON
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  /// Convert to domain entity
  User toEntity() {
    return User(
      id: id,
      email: email,
      name: name,
      phoneNumber: phoneNumber,
      avatar: avatar,
      role: _parseRole(role),
      createdAt: DateTime.parse(createdAt),
      updatedAt: updatedAt != null ? DateTime.parse(updatedAt!) : null,
    );
  }

  /// Parse role string to enum
  static UserRole _parseRole(String role) {
    switch (role.toLowerCase()) {
      case 'vendor':
        return UserRole.vendor;
      case 'admin':
        return UserRole.admin;
      default:
        return UserRole.buyer;
    }
  }

  /// From domain entity
  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      name: user.name,
      phoneNumber: user.phoneNumber,
      avatar: user.avatar,
      role: user.role.name,
      createdAt: user.createdAt.toIso8601String(),
      updatedAt: user.updatedAt?.toIso8601String(),
    );
  }
}
