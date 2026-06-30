import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../../../core/utils/logger.dart';

/// A shipping address as stored on the backend.
class AddressModel {
  final int id;
  final String label;
  final String recipientName;
  final String phone;
  final String address;
  final String city;
  final String province;
  final String postalCode;
  final bool isDefault;

  const AddressModel({
    required this.id,
    required this.label,
    required this.recipientName,
    required this.phone,
    required this.address,
    required this.city,
    required this.province,
    required this.postalCode,
    required this.isDefault,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'] is num
          ? (json['id'] as num).toInt()
          : int.tryParse('${json['id']}') ?? 0,
      label: (json['label'] ?? 'Alamat').toString(),
      recipientName: (json['recipient_name'] ?? '').toString(),
      phone: (json['phone'] ?? '').toString(),
      address: (json['address'] ?? '').toString(),
      city: (json['city'] ?? '').toString(),
      province: (json['province'] ?? '').toString(),
      postalCode: (json['postal_code'] ?? '').toString(),
      isDefault: json['is_default'] == true || json['is_default'] == 1,
    );
  }
}

final addressRepositoryProvider = Provider<AddressRepository>((ref) {
  return AddressRepository(ref.watch(apiClientProvider));
});

class AddressRepository {
  final ApiClient _api;
  AddressRepository(this._api);

  Future<List<AddressModel>> fetch() async {
    try {
      final res = await _api.get('/addresses');
      final list = (res.data['data']?['addresses'] as List?) ?? const [];
      return list
          .whereType<Map<String, dynamic>>()
          .map(AddressModel.fromJson)
          .toList();
    } on DioException catch (e) {
      Logger.error('fetch addresses failed', tag: 'AddressRepo', error: e);
      rethrow;
    }
  }

  Future<void> create(Map<String, dynamic> payload) async {
    await _api.post('/addresses', data: payload);
  }

  Future<void> update(int id, Map<String, dynamic> payload) async {
    await _api.put('/addresses/$id', data: payload);
  }

  Future<void> remove(int id) async {
    await _api.delete('/addresses/$id');
  }
}

/// The signed-in user's saved addresses.
final addressesProvider = FutureProvider<List<AddressModel>>((ref) async {
  return ref.watch(addressRepositoryProvider).fetch();
});
