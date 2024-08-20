// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'synthesizer_insert_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SynthesizerInsertRequest _$SynthesizerInsertRequestFromJson(
        Map<String, dynamic> json) =>
    SynthesizerInsertRequest()
      ..BrandId = (json['BrandId'] as num?)?.toInt()
      ..Model = json['Model'] as String?
      ..Price = (json['Price'] as num?)?.toDouble()
      ..Description = json['Description'] as String?
      ..KeyboardSize = (json['KeyboardSize'] as num?)?.toInt()
      ..WeighedKeys = json['WeighedKeys'] as bool?
      ..Polyphony = (json['Polyphony'] as num?)?.toInt()
      ..NumberOfPresets = (json['NumberOfPresets'] as num?)?.toInt()
      ..image = json['image'] as String?;

Map<String, dynamic> _$SynthesizerInsertRequestToJson(
        SynthesizerInsertRequest instance) =>
    <String, dynamic>{
      'BrandId': instance.BrandId,
      'Model': instance.Model,
      'Price': instance.Price,
      'Description': instance.Description,
      'KeyboardSize': instance.KeyboardSize,
      'WeighedKeys': instance.WeighedKeys,
      'Polyphony': instance.Polyphony,
      'NumberOfPresets': instance.NumberOfPresets,
      'image': instance.image,
    };
