import 'package:json_annotation/json_annotation.dart';

part 'amplifier_insert_request.g.dart';

@JsonSerializable()
class AmplifierInsertRequest {
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

  AmplifierInsertRequest();

  factory AmplifierInsertRequest.fromJson(Map<String, dynamic> json) =>
      _$AmplifierInsertRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AmplifierInsertRequestToJson(this);
}
