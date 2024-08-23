// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'guitar_update_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GuitarUpdateRequest _$GuitarUpdateRequestFromJson(Map<String, dynamic> json) =>
    GuitarUpdateRequest(
      id: (json['id'] as num?)?.toInt(),
    )
      ..guitarTypeId = (json['guitarTypeId'] as num?)?.toInt()
      ..brandId = (json['brandId'] as num?)?.toInt()
      ..pickups = json['pickups'] as String?
      ..pickupConfiguration = json['pickupConfiguration'] as String?
      ..description = json['description'] as String?
      ..model = json['model'] as String?
      ..frets = (json['frets'] as num?)?.toInt()
      ..price = (json['price'] as num?)?.toDouble()
      ..productImage = json['productImage'] as String?;

Map<String, dynamic> _$GuitarUpdateRequestToJson(
        GuitarUpdateRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'guitarTypeId': instance.guitarTypeId,
      'brandId': instance.brandId,
      'pickups': instance.pickups,
      'pickupConfiguration': instance.pickupConfiguration,
      'description': instance.description,
      'model': instance.model,
      'frets': instance.frets,
      'price': instance.price,
      'productImage': instance.productImage,
    };
