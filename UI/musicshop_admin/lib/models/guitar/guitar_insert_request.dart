import 'package:json_annotation/json_annotation.dart';

part 'guitar_insert_request.g.dart';

@JsonSerializable()
class GuitarInsertRequest {
  int? guitarTypeId;
  int? brandId;
  String? pickups;
  String? pickupConfiguration;
  String? description;
  String? model;
  int? frets;
  double? price;
  String? image;

  GuitarInsertRequest();

  factory GuitarInsertRequest.fromJson(Map<String, dynamic> json) =>
      _$GuitarInsertRequestFromJson(json);

  Map<String, dynamic> toJson() => _$GuitarInsertRequestToJson(this);
}
