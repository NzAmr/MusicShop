// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'guitar.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Guitar _$GuitarFromJson(Map<String, dynamic> json) => Guitar()
  ..id = (json['id'] as num?)?.toInt()
  ..guitarType = json['guitarType'] == null
      ? null
      : GuitarType.fromJson(json['guitarType'] as Map<String, dynamic>)
  ..pickups = json['pickups'] as String?
  ..pickupConfiguration = json['pickupConfiguration'] as String?
  ..frets = (json['frets'] as num?)?.toInt()
  ..productNumber = json['productNumber'] as String?
  ..brand = json['brand'] == null
      ? null
      : Brand.fromJson(json['brand'] as Map<String, dynamic>)
  ..model = json['model'] as String?
  ..price = (json['price'] as num?)?.toDouble()
  ..description = json['description'] as String?
  ..covariant = json['covariant'] == null
      ? null
      : DateTime.parse(json['covariant'] as String)
  ..updatedAt = json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String)
  ..productImage = json['productImage'] as String?;

Map<String, dynamic> _$GuitarToJson(Guitar instance) => <String, dynamic>{
      'id': instance.id,
      'guitarType': instance.guitarType,
      'pickups': instance.pickups,
      'pickupConfiguration': instance.pickupConfiguration,
      'frets': instance.frets,
      'productNumber': instance.productNumber,
      'brand': instance.brand,
      'model': instance.model,
      'price': instance.price,
      'description': instance.description,
      'covariant': instance.covariant?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'productImage': instance.productImage,
    };
