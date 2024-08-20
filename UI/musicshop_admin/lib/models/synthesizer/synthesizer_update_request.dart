import 'package:json_annotation/json_annotation.dart';

part 'synthesizer_update_request.g.dart';

@JsonSerializable()
class SynthesizerUpdateRequest {
  int? id;
  int? BrandId;
  String? Model;
  double? Price;
  String? Description;
  int? KeyboardSize;
  bool? WeighedKeys;
  int? Polyphony;
  int? NumberOfPresets;
  String? image;

  SynthesizerUpdateRequest();

  factory SynthesizerUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$SynthesizerUpdateRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SynthesizerUpdateRequestToJson(this);
}
