import 'package:json_annotation/json_annotation.dart';

part 'order_insert_request.g.dart';

@JsonSerializable()
class OrderInsertRequest {
  int? shippingInfoId;
  int? productId;
  String? paymentId;

  OrderInsertRequest();

  factory OrderInsertRequest.fromJson(Map<String, dynamic> json) =>
      _$OrderInsertRequestFromJson(json);

  Map<String, dynamic> toJson() => _$OrderInsertRequestToJson(this);
}
