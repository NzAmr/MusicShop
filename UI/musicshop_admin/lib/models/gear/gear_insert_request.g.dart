// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gear_insert_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GearInsertRequest _$GearInsertRequestFromJson(Map<String, dynamic> json) =>
    GearInsertRequest()
      ..description = json['description'] as String?
      ..model = json['model'] as String?
      ..brandId = (json['brandId'] as num?)?.toInt()
      ..price = (json['price'] as num?)?.toDouble()
      ..image = json['image'] as String?
      ..gearCategoryId = (json['gearCategoryId'] as num?)?.toInt();

Map<String, dynamic> _$GearInsertRequestToJson(GearInsertRequest instance) =>
    <String, dynamic>{
      'description': instance.description,
      'model': instance.model,
      'brandId': instance.brandId,
      'price': instance.price,
      'image': instance.image,
      'gearCategoryId': instance.gearCategoryId,
    };
