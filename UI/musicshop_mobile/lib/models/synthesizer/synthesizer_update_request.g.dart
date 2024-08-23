// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'synthesizer_update_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SynthesizerUpdateRequest _$SynthesizerUpdateRequestFromJson(
        Map<String, dynamic> json) =>
    SynthesizerUpdateRequest()
      ..id = (json['id'] as num?)?.toInt()
      ..brandId = (json['brandId'] as num?)?.toInt()
      ..model = json['model'] as String?
      ..price = (json['price'] as num?)?.toDouble()
      ..description = json['description'] as String?
      ..keyboardSize = (json['keyboardSize'] as num?)?.toInt()
      ..weighedKeys = json['weighedKeys'] as bool?
      ..polyphony = (json['polyphony'] as num?)?.toInt()
      ..numberOfPresets = (json['numberOfPresets'] as num?)?.toInt()
      ..productImage = json['productImage'] as String?;

Map<String, dynamic> _$SynthesizerUpdateRequestToJson(
        SynthesizerUpdateRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'brandId': instance.brandId,
      'model': instance.model,
      'price': instance.price,
      'description': instance.description,
      'keyboardSize': instance.keyboardSize,
      'weighedKeys': instance.weighedKeys,
      'polyphony': instance.polyphony,
      'numberOfPresets': instance.numberOfPresets,
      'productImage': instance.productImage,
    };
