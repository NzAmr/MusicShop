import 'package:json_annotation/json_annotation.dart';
import 'package:musicshop_admin/models/Abstract/product.dart';

part 'synthesizer.g.dart';

@JsonSerializable()
class Synthesizer {
  int? id;
  String? ProductNumber;
  int? ProductImageId;
  int? BrandId;
  String? Model;
  double? Price;
  String? Description;
  DateTime? CreatedAt;
  DateTime? UpdatedAt;
  int? KeyboardSize;
  bool? WeighedKeys;
  int? Polyphony;
  int? NumberOfPresets;

  Synthesizer();

  factory Synthesizer.fromJson(Map<String, dynamic> json) =>
      _$SynthesizerFromJson(json);

  Map<String, dynamic> toJson() => _$SynthesizerToJson(this);
}
