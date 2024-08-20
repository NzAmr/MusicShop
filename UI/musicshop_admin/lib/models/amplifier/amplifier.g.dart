// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'amplifier.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Amplifier _$AmplifierFromJson(Map<String, dynamic> json) => Amplifier()
  ..id = (json['id'] as num?)?.toInt()
  ..productNumber = json['productNumber'] as String?
  ..brand = json['brand'] == null
      ? null
      : Brand.fromJson(json['brand'] as Map<String, dynamic>)
  ..model = json['model'] as String?
  ..price = (json['price'] as num?)?.toDouble()
  ..description = json['description'] as String?
  ..voltage = (json['voltage'] as num?)?.toInt()
  ..powerRating = (json['powerRating'] as num?)?.toInt()
  ..headphoneJack = json['headphoneJack'] as bool?
  ..usbjack = json['usbjack'] as bool?
  ..numberOfPresets = (json['numberOfPresets'] as num?)?.toInt()
  ..createdAt = json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String)
  ..updatedAt = json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String);

Map<String, dynamic> _$AmplifierToJson(Amplifier instance) => <String, dynamic>{
      'id': instance.id,
      'productNumber': instance.productNumber,
      'brand': instance.brand,
      'model': instance.model,
      'price': instance.price,
      'description': instance.description,
      'voltage': instance.voltage,
      'powerRating': instance.powerRating,
      'headphoneJack': instance.headphoneJack,
      'usbjack': instance.usbjack,
      'numberOfPresets': instance.numberOfPresets,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
