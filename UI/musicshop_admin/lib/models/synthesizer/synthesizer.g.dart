// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'synthesizer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Synthesizer _$SynthesizerFromJson(Map<String, dynamic> json) => Synthesizer()
  ..id = (json['id'] as num?)?.toInt()
  ..ProductNumber = json['ProductNumber'] as String?
  ..ProductImageId = (json['ProductImageId'] as num?)?.toInt()
  ..BrandId = (json['BrandId'] as num?)?.toInt()
  ..Model = json['Model'] as String?
  ..Price = (json['Price'] as num?)?.toDouble()
  ..Description = json['Description'] as String?
  ..CreatedAt = json['CreatedAt'] == null
      ? null
      : DateTime.parse(json['CreatedAt'] as String)
  ..UpdatedAt = json['UpdatedAt'] == null
      ? null
      : DateTime.parse(json['UpdatedAt'] as String)
  ..KeyboardSize = (json['KeyboardSize'] as num?)?.toInt()
  ..WeighedKeys = json['WeighedKeys'] as bool?
  ..Polyphony = (json['Polyphony'] as num?)?.toInt()
  ..NumberOfPresets = (json['NumberOfPresets'] as num?)?.toInt();

Map<String, dynamic> _$SynthesizerToJson(Synthesizer instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ProductNumber': instance.ProductNumber,
      'ProductImageId': instance.ProductImageId,
      'BrandId': instance.BrandId,
      'Model': instance.Model,
      'Price': instance.Price,
      'Description': instance.Description,
      'CreatedAt': instance.CreatedAt?.toIso8601String(),
      'UpdatedAt': instance.UpdatedAt?.toIso8601String(),
      'KeyboardSize': instance.KeyboardSize,
      'WeighedKeys': instance.WeighedKeys,
      'Polyphony': instance.Polyphony,
      'NumberOfPresets': instance.NumberOfPresets,
    };
