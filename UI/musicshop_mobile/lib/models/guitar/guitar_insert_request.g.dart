// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'guitar_insert_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GuitarInsertRequest _$GuitarInsertRequestFromJson(Map<String, dynamic> json) =>
    GuitarInsertRequest()
      ..guitarTypeId = (json['guitarTypeId'] as num?)?.toInt()
      ..brandId = (json['brandId'] as num?)?.toInt()
      ..pickups = json['pickups'] as String?
      ..pickupConfiguration = json['pickupConfiguration'] as String?
      ..description = json['description'] as String?
      ..model = json['model'] as String?
      ..frets = (json['frets'] as num?)?.toInt()
      ..price = (json['price'] as num?)?.toDouble()
      ..productImage = json['productImage'] as String?;

Map<String, dynamic> _$GuitarInsertRequestToJson(
        GuitarInsertRequest instance) =>
    <String, dynamic>{
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
