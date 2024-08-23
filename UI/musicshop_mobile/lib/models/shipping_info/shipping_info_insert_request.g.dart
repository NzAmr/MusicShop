// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shipping_info_insert_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShippingInfoInsertRequest _$ShippingInfoInsertRequestFromJson(
        Map<String, dynamic> json) =>
    ShippingInfoInsertRequest(
      country: json['country'] as String?,
      stateOrProvince: json['stateOrProvince'] as String?,
      city: json['city'] as String?,
      zipCode: json['zipCode'] as String?,
      streetAddress: json['streetAddress'] as String?,
      customerId: (json['customerId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ShippingInfoInsertRequestToJson(
        ShippingInfoInsertRequest instance) =>
    <String, dynamic>{
      'country': instance.country,
      'stateOrProvince': instance.stateOrProvince,
      'city': instance.city,
      'zipCode': instance.zipCode,
      'streetAddress': instance.streetAddress,
      'customerId': instance.customerId,
    };
