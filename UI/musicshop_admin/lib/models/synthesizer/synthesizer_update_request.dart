import 'package:json_annotation/json_annotation.dart';

part 'synthesizer_update_request.g.dart';

@JsonSerializable()
class SynthesizerUpdateRequest {
  int? id;
  int? brandId;
  String? model;
  double? price;
  String? description;
  int? keyboardSize;
  bool? weighedKeys;
  int? polyphony;
  int? numberOfPresets;
  String? image;

  SynthesizerUpdateRequest();

  factory SynthesizerUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$SynthesizerUpdateRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SynthesizerUpdateRequestToJson(this);
}
