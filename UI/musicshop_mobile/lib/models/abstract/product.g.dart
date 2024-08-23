// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product()
  ..id = (json['id'] as num?)?.toInt()
  ..productNumber = json['productNumber'] as String?
  ..productImage = json['productImage'] as String?
  ..brand = json['brand'] == null
      ? null
      : Brand.fromJson(json['brand'] as Map<String, dynamic>)
  ..model = json['model'] as String?
  ..price = (json['price'] as num?)?.toDouble()
  ..description = json['description'] as String?
  ..type = json['type'] as String?;

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'id': instance.id,
      'productNumber': instance.productNumber,
      'productImage': instance.productImage,
      'brand': instance.brand,
      'model': instance.model,
      'price': instance.price,
      'description': instance.description,
      'type': instance.type,
    };
