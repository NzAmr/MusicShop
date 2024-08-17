// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'guitar.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Guitar _$GuitarFromJson(Map<String, dynamic> json) => Guitar()
  ..guitarTypeId = (json['guitarTypeId'] as num?)?.toInt()
  ..pickups = json['pickups'] as String?
  ..pickupConfiguration = json['pickupConfiguration'] as String?
  ..frets = (json['frets'] as num?)?.toInt()
  ..productNumber = json['productNumber'] as String?
  ..productImageId = (json['productImageId'] as num?)?.toInt()
  ..brandId = (json['brandId'] as num?)?.toInt()
  ..model = json['model'] as String?
  ..price = (json['price'] as num?)?.toDouble()
  ..description = json['description'] as String?
  ..covariant = json['covariant'] == null
      ? null
      : DateTime.parse(json['covariant'] as String)
  ..updatedAt = json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String);

Map<String, dynamic> _$GuitarToJson(Guitar instance) => <String, dynamic>{
      'guitarTypeId': instance.guitarTypeId,
      'pickups': instance.pickups,
      'pickupConfiguration': instance.pickupConfiguration,
      'frets': instance.frets,
      'productNumber': instance.productNumber,
      'productImageId': instance.productImageId,
      'brandId': instance.brandId,
      'model': instance.model,
      'price': instance.price,
      'description': instance.description,
      'covariant': instance.covariant?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
