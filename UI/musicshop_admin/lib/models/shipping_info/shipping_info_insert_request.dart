import 'package:json_annotation/json_annotation.dart';

part 'shipping_info_insert_request.g.dart';

@JsonSerializable()
class ShippingInfoInsertRequest {
  String? country;
  String? stateOrProvince;
  String? city;
  String? zipCode;
  String? streetAddress;
  int? customerId;

  ShippingInfoInsertRequest({
    this.country,
    this.stateOrProvince,
    this.city,
    this.zipCode,
    this.streetAddress,
    this.customerId,
  });

  factory ShippingInfoInsertRequest.fromJson(Map<String, dynamic> json) =>
      _$ShippingInfoInsertRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ShippingInfoInsertRequestToJson(this);
}
