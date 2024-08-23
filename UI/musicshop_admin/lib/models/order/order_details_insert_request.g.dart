// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_details_insert_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderDetailsInsertRequest _$OrderDetailsInsertRequestFromJson(
        Map<String, dynamic> json) =>
    OrderDetailsInsertRequest()
      ..shippingInfoId = (json['shippingInfoId'] as num?)?.toInt()
      ..productId = (json['productId'] as num?)?.toInt();

Map<String, dynamic> _$OrderDetailsInsertRequestToJson(
        OrderDetailsInsertRequest instance) =>
    <String, dynamic>{
      'shippingInfoId': instance.shippingInfoId,
      'productId': instance.productId,
    };
