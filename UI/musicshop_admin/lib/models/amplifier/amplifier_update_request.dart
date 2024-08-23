import 'package:json_annotation/json_annotation.dart';

part 'amplifier_update_request.g.dart';

@JsonSerializable()
class AmplifierUpdateRequest {
  int? id;
  int? brandId;
  String? model;
  double? price;
  String? description;
  int? voltage;
  int? powerRating;
  bool? headphoneJack;
  bool? usbjack;
  int? numberOfPresets;
  String? productImage;

  AmplifierUpdateRequest();

  factory AmplifierUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$AmplifierUpdateRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AmplifierUpdateRequestToJson(this);
}
