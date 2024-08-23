// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'amplifier_update_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AmplifierUpdateRequest _$AmplifierUpdateRequestFromJson(
        Map<String, dynamic> json) =>
    AmplifierUpdateRequest()
      ..id = (json['id'] as num?)?.toInt()
      ..brandId = (json['brandId'] as num?)?.toInt()
      ..model = json['model'] as String?
      ..price = (json['price'] as num?)?.toDouble()
      ..description = json['description'] as String?
      ..voltage = (json['voltage'] as num?)?.toInt()
      ..powerRating = (json['powerRating'] as num?)?.toInt()
      ..headphoneJack = json['headphoneJack'] as bool?
      ..usbjack = json['usbjack'] as bool?
      ..numberOfPresets = (json['numberOfPresets'] as num?)?.toInt()
      ..productImage = json['productImage'] as String?;

Map<String, dynamic> _$AmplifierUpdateRequestToJson(
        AmplifierUpdateRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'brandId': instance.brandId,
      'model': instance.model,
      'price': instance.price,
      'description': instance.description,
      'voltage': instance.voltage,
      'powerRating': instance.powerRating,
      'headphoneJack': instance.headphoneJack,
      'usbjack': instance.usbjack,
      'numberOfPresets': instance.numberOfPresets,
      'productImage': instance.productImage,
    };
