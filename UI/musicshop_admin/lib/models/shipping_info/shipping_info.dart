import 'package:json_annotation/json_annotation.dart';
import 'package:musicshop_admin/models/customer/customer.dart';

part 'shipping_info.g.dart';

@JsonSerializable()
class ShippingInfo {
  int? id;
  String? country;
  String? stateOrProvince;
  String? city;
  String? zipCode;
  String? streetAddress;
  Customer? customer;

  ShippingInfo();

  factory ShippingInfo.fromJson(Map<String, dynamic> json) =>
      _$ShippingInfoFromJson(json);

  Map<String, dynamic> toJson() => _$ShippingInfoToJson(this);
}
