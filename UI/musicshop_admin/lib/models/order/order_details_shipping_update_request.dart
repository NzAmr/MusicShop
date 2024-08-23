import 'package:json_annotation/json_annotation.dart';

part 'order_details_shipping_update_request.g.dart';

@JsonSerializable()
class OrderDetailsShippingUpdateRequest {
  String? shippingStatus;

  OrderDetailsShippingUpdateRequest({this.shippingStatus});

  factory OrderDetailsShippingUpdateRequest.fromJson(
          Map<String, dynamic> json) =>
      _$OrderDetailsShippingUpdateRequestFromJson(json);

  Map<String, dynamic> toJson() =>
      _$OrderDetailsShippingUpdateRequestToJson(this);
}
