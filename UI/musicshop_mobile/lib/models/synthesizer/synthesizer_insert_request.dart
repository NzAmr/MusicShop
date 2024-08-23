import 'package:json_annotation/json_annotation.dart';

part 'synthesizer_insert_request.g.dart';

@JsonSerializable()
class SynthesizerInsertRequest {
  int? BrandId;
  String? Model;
  double? Price;
  String? Description;
  int? KeyboardSize;
  bool? WeighedKeys;
  int? Polyphony;
  int? NumberOfPresets;
  String? productImage;

  SynthesizerInsertRequest();

  factory SynthesizerInsertRequest.fromJson(Map<String, dynamic> json) =>
      _$SynthesizerInsertRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SynthesizerInsertRequestToJson(this);
}
