// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product()
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
      : DateTime.parse(json['UpdatedAt'] as String);

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'ProductNumber': instance.ProductNumber,
      'ProductImageId': instance.ProductImageId,
      'BrandId': instance.BrandId,
      'Model': instance.Model,
      'Price': instance.Price,
      'Description': instance.Description,
      'CreatedAt': instance.CreatedAt?.toIso8601String(),
      'UpdatedAt': instance.UpdatedAt?.toIso8601String(),
    };
