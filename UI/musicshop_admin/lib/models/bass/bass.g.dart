// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bass.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Bass _$BassFromJson(Map<String, dynamic> json) => Bass()
  ..id = (json['id'] as num?)?.toInt()
  ..productNumber = json['productNumber'] as String?
  ..brand = json['brand'] == null
      ? null
      : Brand.fromJson(json['brand'] as Map<String, dynamic>)
  ..model = json['model'] as String?
  ..price = (json['price'] as num?)?.toDouble()
  ..description = json['description'] as String?
  ..guitarType = json['guitarType'] == null
      ? null
      : GuitarType.fromJson(json['guitarType'] as Map<String, dynamic>)
  ..pickups = json['pickups'] as String?
  ..frets = (json['frets'] as num?)?.toInt()
  ..productImage = json['productImage'] as String?;

Map<String, dynamic> _$BassToJson(Bass instance) => <String, dynamic>{
      'id': instance.id,
      'productNumber': instance.productNumber,
      'brand': instance.brand,
      'model': instance.model,
      'price': instance.price,
      'description': instance.description,
      'guitarType': instance.guitarType,
      'pickups': instance.pickups,
      'frets': instance.frets,
      'productImage': instance.productImage,
    };
