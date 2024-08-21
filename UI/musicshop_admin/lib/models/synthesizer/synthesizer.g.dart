// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'synthesizer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Synthesizer _$SynthesizerFromJson(Map<String, dynamic> json) => Synthesizer()
  ..id = (json['id'] as num?)?.toInt()
  ..productNumber = json['productNumber'] as String?
  ..productImage = json['productImage'] as String?
  ..brand = json['brand'] == null
      ? null
      : Brand.fromJson(json['brand'] as Map<String, dynamic>)
  ..model = json['model'] as String?
  ..price = (json['price'] as num?)?.toDouble()
  ..description = json['description'] as String?
  ..createdAt = json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String)
  ..updatedAt = json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String)
  ..keyboardSize = (json['keyboardSize'] as num?)?.toInt()
  ..weighedKeys = json['weighedKeys'] as bool?
  ..polyphony = (json['polyphony'] as num?)?.toInt()
  ..numberOfPresets = (json['numberOfPresets'] as num?)?.toInt();

Map<String, dynamic> _$SynthesizerToJson(Synthesizer instance) =>
    <String, dynamic>{
      'id': instance.id,
      'productNumber': instance.productNumber,
      'productImage': instance.productImage,
      'brand': instance.brand,
      'model': instance.model,
      'price': instance.price,
      'description': instance.description,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'keyboardSize': instance.keyboardSize,
      'weighedKeys': instance.weighedKeys,
      'polyphony': instance.polyphony,
      'numberOfPresets': instance.numberOfPresets,
    };
