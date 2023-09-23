import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:phone_corrector/domain/api/abstract_api_client.dart';

class VoxlinkApiClient implements AbstractApiClient {
  const VoxlinkApiClient({required this.dio});

  static const _apiBaseUrl = "https://num.voxlink.ru/get/?num=";
  static const _regionParam = "&field=region";

  final Dio dio;

  @override
  Future<bool> checkRegion(String phone, String region) async {
    try {
      final response = await dio.get("$_apiBaseUrl$phone$_regionParam");
      if (response.data
          .toString()
          .toLowerCase()
          .contains(region.trim().toLowerCase())) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log(e.toString());
      return false;
    }
  }
}
