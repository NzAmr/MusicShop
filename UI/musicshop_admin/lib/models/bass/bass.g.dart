// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bass.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Bass _$BassFromJson(Map<String, dynamic> json) => Bass()
  ..id = (json['id'] as num?)?.toInt()
  ..ProductNumber = json['ProductNumber'] as String?
  ..ProductImageId = (json['ProductImageId'] as num?)?.toInt()
  ..BrandId = (json['BrandId'] as num?)?.toInt()
  ..Model = json['Model'] as String?
  ..Price = (json['Price'] as num?)?.toDouble()
  ..Description = json['Description'] as String?
  ..CreatedAt = json['CreatedAt'] == null
      ? null
      : DateTime.parse(json['CreatedAt'] as String)
  ..UpdatedAt = json['UpdatedAt'] == null
      ? null
      : DateTime.parse(json['UpdatedAt'] as String)
  ..guitarType = json['guitarType'] == null
      ? null
      : GuitarType.fromJson(json['guitarType'] as Map<String, dynamic>)
  ..pickups = json['pickups'] as String?
  ..frets = (json['frets'] as num?)?.toInt()
  ..image = json['image'] as String?;

Map<String, dynamic> _$BassToJson(Bass instance) => <String, dynamic>{
      'id': instance.id,
      'ProductNumber': instance.ProductNumber,
      'ProductImageId': instance.ProductImageId,
      'BrandId': instance.BrandId,
      'Model': instance.Model,
      'Price': instance.Price,
      'Description': instance.Description,
      'CreatedAt': instance.CreatedAt?.toIso8601String(),
      'UpdatedAt': instance.UpdatedAt?.toIso8601String(),
      'guitarType': instance.guitarType,
      'pickups': instance.pickups,
      'frets': instance.frets,
      'image': instance.image,
    };
