import 'dart:convert';
import 'dart:io';
import 'package:musicshop_mobile/models/order/order.dart';

import 'package:musicshop_mobile/providers/base/base_provider.dart';

class OrderProvider extends BaseProvider<Order> {
  OrderProvider() : super('Order') {
    client.badCertificateCallback = (cert, host, port) => true;
  }

  @override
  Order fromJson(data) {
    return Order.fromJson(data);
  }

  Future<List<Order>> getCustomerOrders() async {
    var url = "${baseUrl}Order/get-by-customer";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    try {
      var response = await http!.get(uri, headers: headers);

      if (isValidResponseCode(response)) {
        List<dynamic> dataList = jsonDecode(response.body);

        List<Order> orders = dataList
            .map((json) => Order.fromJson(json as Map<String, dynamic>))
            .toList();

        return orders;
      } else {
        throw Exception("Failed to fetch orders: ${response.statusCode}");
      }
    } on SocketException catch (e) {
      throw Exception("Network error: ${e.message}");
    } on HandshakeException catch (e) {
      throw Exception("Handshake error: ${e.message}");
    } catch (e) {
      throw Exception("Unexpected error: ${e.toString()}");
    }
  }
}
