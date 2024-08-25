import 'package:json_annotation/json_annotation.dart';
import 'package:musicshop_mobile/models/customer/customer.dart';

part 'shipping_info_update_request.g.dart';

@JsonSerializable()
class ShippingInfoUpdateRequest {
  int? id;
  String? country;
  String? stateOrProvince;
  String? city;
  String? zipCode;
  String? streetAddress;

  ShippingInfoUpdateRequest();

  factory ShippingInfoUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$ShippingInfoUpdateRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ShippingInfoUpdateRequestToJson(this);
}
