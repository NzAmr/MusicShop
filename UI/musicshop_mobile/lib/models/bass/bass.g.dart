// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bass.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Bass _$BassFromJson(Map<String, dynamic> json) => Bass()
  ..id = (json['id'] as num?)?.toInt()
  ..productNumber = json['productNumber'] as String?
  ..brandId = (json['brandId'] as num?)?.toInt()
  ..model = json['model'] as String?
  ..price = (json['price'] as num?)?.toDouble()
  ..description = json['description'] as String?
  ..guitarType = json['guitarType'] == null
      ? null
      : GuitarType.fromJson(json['guitarType'] as Map<String, dynamic>)
  ..pickups = json['pickups'] as String?
  ..frets = (json['frets'] as num?)?.toInt()
  ..image = json['image'] as String?;

Map<String, dynamic> _$BassToJson(Bass instance) => <String, dynamic>{
      'id': instance.id,
      'ProductNumber': instance.productNumber,
      'brandId': instance.brandId,
      'model': instance.model,
      'price': instance.price,
      'description': instance.description,
      'guitarType': instance.guitarType,
      'pickups': instance.pickups,
      'frets': instance.frets,
      'image': instance.image,
    };