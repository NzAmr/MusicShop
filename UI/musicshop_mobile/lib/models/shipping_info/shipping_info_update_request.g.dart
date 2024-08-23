// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shipping_info_update_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShippingInfoUpdateRequest _$ShippingInfoUpdateRequestFromJson(
        Map<String, dynamic> json) =>
    ShippingInfoUpdateRequest()
      ..id = (json['id'] as num?)?.toInt()
      ..country = json['country'] as String?
      ..stateOrProvince = json['stateOrProvince'] as String?
      ..city = json['city'] as String?
      ..zipCode = json['zipCode'] as String?
      ..streetAddress = json['streetAddress'] as String?
      ..customerId = (json['customerId'] as num?)?.toInt();

Map<String, dynamic> _$ShippingInfoUpdateRequestToJson(
        ShippingInfoUpdateRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'country': instance.country,
      'stateOrProvince': instance.stateOrProvince,
      'city': instance.city,
      'zipCode': instance.zipCode,
      'streetAddress': instance.streetAddress,
      'customerId': instance.customerId,
    };
