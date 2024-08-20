// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'name_update_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NameUpdateRequest _$NameUpdateRequestFromJson(Map<String, dynamic> json) =>
    NameUpdateRequest()
      ..id = (json['id'] as num?)?.toInt()
      ..name = json['name'] as String?;

Map<String, dynamic> _$NameUpdateRequestToJson(NameUpdateRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };
