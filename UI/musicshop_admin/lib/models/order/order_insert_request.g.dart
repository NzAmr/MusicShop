// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_insert_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderInsertRequest _$OrderInsertRequestFromJson(Map<String, dynamic> json) =>
    OrderInsertRequest()
      ..shippingInfoId = (json['shippingInfoId'] as num?)?.toInt()
      ..productId = (json['productId'] as num?)?.toInt()
      ..employeeId = (json['employeeId'] as num?)?.toInt();

Map<String, dynamic> _$OrderInsertRequestToJson(OrderInsertRequest instance) =>
    <String, dynamic>{
      'shippingInfoId': instance.shippingInfoId,
      'productId': instance.productId,
      'employeeId': instance.employeeId,
    };
