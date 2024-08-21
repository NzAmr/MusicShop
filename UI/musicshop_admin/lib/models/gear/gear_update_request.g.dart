// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gear_update_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GearUpdateRequest _$GearUpdateRequestFromJson(Map<String, dynamic> json) =>
    GearUpdateRequest()
      ..id = (json['id'] as num?)?.toInt()
      ..description = json['description'] as String?
      ..model = json['model'] as String?
      ..brandId = (json['brandId'] as num?)?.toInt()
      ..price = (json['price'] as num?)?.toDouble()
      ..productImage = json['productImage'] as String?
      ..gearCategoryId = (json['gearCategoryId'] as num?)?.toInt();

Map<String, dynamic> _$GearUpdateRequestToJson(GearUpdateRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'model': instance.model,
      'brandId': instance.brandId,
      'price': instance.price,
      'productImage': instance.productImage,
      'gearCategoryId': instance.gearCategoryId,
    };
