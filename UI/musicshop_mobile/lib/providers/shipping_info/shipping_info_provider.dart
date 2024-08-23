import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:musicshop_admin/models/shipping_info/shipping_info.dart';
import 'package:musicshop_admin/providers/base/base_provider.dart';

class ShippingInfoProvider extends BaseProvider<ShippingInfo> {
  ShippingInfoProvider() : super('ShippingInfo');

  @override
  ShippingInfo fromJson(data) {
    return ShippingInfo.fromJson(data);
  }

  Future<ShippingInfo?> getByCustomerId(int customerId) async {
    final url = "${baseUrl}ShippingInfo/get-by-customer-id?id=$customerId";
    final uri = Uri.parse(url);
    final headers = createHeaders();

    try {
      final response = await http.get(uri, headers: headers);

      if (isValidResponse(response)) {
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
