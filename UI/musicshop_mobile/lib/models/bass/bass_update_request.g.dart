// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bass_update_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BassUpdateRequest _$BassUpdateRequestFromJson(Map<String, dynamic> json) =>
    BassUpdateRequest()
      ..id = (json['id'] as num?)?.toInt()
      ..brandId = (json['brandId'] as num?)?.toInt()
      ..model = json['model'] as String?
      ..price = (json['price'] as num?)?.toDouble()
      ..description = json['description'] as String?
      ..guitarTypeId = (json['guitarTypeId'] as num?)?.toInt()
      ..pickups = json['pickups'] as String?
      ..frets = (json['frets'] as num?)?.toInt()
      ..image = json['image'] as String?;

Map<String, dynamic> _$BassUpdateRequestToJson(BassUpdateRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'brandId': instance.brandId,
      'model': instance.model,
      'price': instance.price,
      'description': instance.description,
      'guitarTypeId': instance.guitarTypeId,
      'pickups': instance.pickups,
      'frets': instance.frets,
      'image': instance.image,
    };
