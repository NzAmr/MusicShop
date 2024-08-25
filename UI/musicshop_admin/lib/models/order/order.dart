import 'package:json_annotation/json_annotation.dart';
import 'package:musicshop_admin/models/abstract/product.dart';
import 'package:musicshop_admin/models/shipping_info/shipping_info.dart';

part 'order.g.dart';

@JsonSerializable()
class Order {
  int? id;
  String? orderNumber;
  DateTime? orderDate;
  String? shippingStatus;
  ShippingInfo? shippingInfo;
  Product? product;

  Order();

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
  Map<String, dynamic> toJson() => _$OrderToJson(this);
}
