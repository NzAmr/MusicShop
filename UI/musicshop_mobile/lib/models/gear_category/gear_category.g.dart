// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gear_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GearCategory _$GearCategoryFromJson(Map<String, dynamic> json) => GearCategory()
  ..id = (json['id'] as num?)?.toInt()
  ..name = json['name'] as String?;

Map<String, dynamic> _$GearCategoryToJson(GearCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };
