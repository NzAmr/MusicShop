import 'package:json_annotation/json_annotation.dart';

part 'bass_update_request.g.dart';

@JsonSerializable()
class BassUpdateRequest {
  int? id;
  int? brandId;
  String? model;
  double? price;
  String? description;
  int? guitarTypeId;
  String? pickups;
  int? frets;
  String? image;

  BassUpdateRequest();

  factory BassUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$BassUpdateRequestFromJson(json);
  Map<String, dynamic> toJson() => _$BassUpdateRequestToJson(this);
}
