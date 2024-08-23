import 'package:json_annotation/json_annotation.dart';

part 'order_details_insert_request.g.dart';

@JsonSerializable()
class OrderDetailsInsertRequest {
  int? shippingInfoId;
  int? productId;

  OrderDetailsInsertRequest();

  factory OrderDetailsInsertRequest.fromJson(Map<String, dynamic> json) =>
      _$OrderDetailsInsertRequestFromJson(json);

  Map<String, dynamic> toJson() => _$OrderDetailsInsertRequestToJson(this);
}
