import 'dart:convert';
import 'dart:io';
import 'package:http/io_client.dart';
import 'package:musicshop_mobile/models/shipping_info/shipping_info.dart';
import 'package:musicshop_mobile/providers/base/base_provider.dart';

class ShippingInfoProvider extends BaseProvider<ShippingInfo> {
  late HttpClient _client;
  late IOClient _http;

  ShippingInfoProvider() : super('ShippingInfo') {
    _client = HttpClient();
    _client.badCertificateCallback = (cert, host, port) => true;
    _http = IOClient(_client);
  }

  @override
  ShippingInfo fromJson(data) {
    return ShippingInfo.fromJson(data);
  }

  @override
  Future<ShippingInfo?> getByCustomerId() async {
    final url = "${baseUrl}ShippingInfo/get-by-customer-id-from-request";
    final uri = Uri.parse(url);
    final headers = createHeaders();

    try {
      final response = await _http.get(uri, headers: headers);

      if (isValidResponseCode(response)) {
        final data = jsonDecode(response.body);
        print('Response data: $data');
        return fromJson(data);
      } else {
        throw Exception("Unknown error: ${response.statusCode}");
      }
    } catch (e) {
      print('Error during HTTP request: $e');
      throw Exception('Failed to load shipping info');
    }
  }
}
