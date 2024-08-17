// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'guitar_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GuitarType _$GuitarTypeFromJson(Map<String, dynamic> json) => GuitarType(
      name: json['name'] as String?,
    )..id = (json['id'] as num?)?.toInt();

Map<String, dynamic> _$GuitarTypeToJson(GuitarType instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };
