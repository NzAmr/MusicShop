import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:musicshop_admin/models/order/order_details.dart';
import 'package:musicshop_admin/models/shipping_info/shipping_info.dart';
import 'package:musicshop_admin/providers/base/base_provider.dart';

class OrderDetailsProvider extends BaseProvider<OrderDetails> {
  OrderDetailsProvider() : super('OrderDetails');

  @override
  OrderDetails fromJson(data) {
    return OrderDetails.fromJson(data);
  }
}
