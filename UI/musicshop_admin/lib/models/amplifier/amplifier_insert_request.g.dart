// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'amplifier_insert_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AmplifierInsertRequest _$AmplifierInsertRequestFromJson(
        Map<String, dynamic> json) =>
    AmplifierInsertRequest()
      ..brandId = (json['brandId'] as num?)?.toInt()
      ..model = json['model'] as String?
      ..price = (json['price'] as num?)?.toDouble()
      ..description = json['description'] as String?
      ..voltage = (json['voltage'] as num?)?.toInt()
      ..powerRating = (json['powerRating'] as num?)?.toInt()
      ..headphoneJack = json['headphoneJack'] as bool?
      ..usbjack = json['usbjack'] as bool?
      ..numberOfPresets = (json['numberOfPresets'] as num?)?.toInt()
      ..image = json['image'] as String?;

Map<String, dynamic> _$AmplifierInsertRequestToJson(
        AmplifierInsertRequest instance) =>
    <String, dynamic>{
      'brandId': instance.brandId,
      'model': instance.model,
      'price': instance.price,
      'description': instance.description,
      'voltage': instance.voltage,
      'powerRating': instance.powerRating,
      'headphoneJack': instance.headphoneJack,
      'usbjack': instance.usbjack,
      'numberOfPresets': instance.numberOfPresets,
      'image': instance.image,
    };
