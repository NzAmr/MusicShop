// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Order _$OrderFromJson(Map<String, dynamic> json) => Order()
  ..id = (json['id'] as num?)?.toInt()
  ..orderNumber = json['orderNumber'] as String?
  ..orderDate = json['orderDate'] == null
      ? null
      : DateTime.parse(json['orderDate'] as String)
  ..shippingStatus = json['shippingStatus'] as String?
  ..shippingInfo = json['shippingInfo'] == null
      ? null
      : ShippingInfo.fromJson(json['shippingInfo'] as Map<String, dynamic>)
  ..product = json['product'] == null
      ? null
      : Product.fromJson(json['product'] as Map<String, dynamic>);

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
      'id': instance.id,
      'orderNumber': instance.orderNumber,
      'orderDate': instance.orderDate?.toIso8601String(),
      'shippingStatus': instance.shippingStatus,
      'shippingInfo': instance.shippingInfo,
      'product': instance.product,
    };
