import 'package:json_annotation/json_annotation.dart';

part 'order_shipping_update_request.g.dart';

@JsonSerializable()
class OrderShippingUpdateRequest {
  String? shippingStatus;

  OrderShippingUpdateRequest({this.shippingStatus});

  factory OrderShippingUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$OrderShippingUpdateRequestFromJson(json);

  Map<String, dynamic> toJson() => _$OrderShippingUpdateRequestToJson(this);
}
