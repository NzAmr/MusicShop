import 'package:json_annotation/json_annotation.dart';
import 'package:musicshop_mobile/models/Abstract/product.dart';
import 'package:musicshop_mobile/models/brand/brand.dart';

part 'synthesizer.g.dart';

@JsonSerializable()
class Synthesizer {
  int? id;
  String? productNumber;
  String? productImage;
  Brand? brand;
  String? model;
  double? price;
  String? description;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? keyboardSize;
  bool? weighedKeys;
  int? polyphony;
  int? numberOfPresets;

  Synthesizer();

  factory Synthesizer.fromJson(Map<String, dynamic> json) =>
      _$SynthesizerFromJson(json);

  Map<String, dynamic> toJson() => _$SynthesizerToJson(this);
}
