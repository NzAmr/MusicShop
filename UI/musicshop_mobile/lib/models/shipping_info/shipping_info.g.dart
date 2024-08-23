// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shipping_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShippingInfo _$ShippingInfoFromJson(Map<String, dynamic> json) => ShippingInfo()
  ..id = (json['id'] as num?)?.toInt()
  ..country = json['country'] as String?
  ..stateOrProvince = json['stateOrProvince'] as String?
  ..city = json['city'] as String?
  ..zipCode = json['zipCode'] as String?
  ..streetAddress = json['streetAddress'] as String?
  ..customer = json['customer'] == null
      ? null
      : Customer.fromJson(json['customer'] as Map<String, dynamic>);

Map<String, dynamic> _$ShippingInfoToJson(ShippingInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'country': instance.country,
      'stateOrProvince': instance.stateOrProvince,
      'city': instance.city,
      'zipCode': instance.zipCode,
      'streetAddress': instance.streetAddress,
      'customer': instance.customer,
    };
