import 'package:json_annotation/json_annotation.dart';

part 'bass_insert_request.g.dart';

@JsonSerializable()
class BassInsertRequest {
  int? brandId;
  String? model;
  double? price;
  String? description;
  int? guitarTypeId;
  String? pickups;
  int? frets;
  String? image;

  BassInsertRequest();

  factory BassInsertRequest.fromJson(Map<String, dynamic> json) =>
      _$BassInsertRequestFromJson(json);
  Map<String, dynamic> toJson() => _$BassInsertRequestToJson(this);
}
