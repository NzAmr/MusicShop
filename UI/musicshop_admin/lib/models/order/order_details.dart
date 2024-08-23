import 'package:json_annotation/json_annotation.dart';
import 'package:musicshop_admin/models/abstract/product.dart';
import 'package:musicshop_admin/models/shipping_info/shipping_info.dart';

part 'order_details.g.dart';

@JsonSerializable()
class OrderDetails {
  int? id;
  String? orderNumber;
  DateTime? orderDate;
  String? shippingStatus;
  ShippingInfo? shippingInfo;
  Product? product;

  OrderDetails();

  factory OrderDetails.fromJson(Map<String, dynamic> json) =>
      _$OrderDetailsFromJson(json);
  Map<String, dynamic> toJson() => _$OrderDetailsToJson(this);
}
