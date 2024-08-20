import 'package:json_annotation/json_annotation.dart';

part 'gear_insert_request.g.dart';

@JsonSerializable()
class GearInsertRequest {
  String? description;
  String? model;
  int? brandId;
  double? price;
  String? image;
  int? gearCategoryId;
  GearInsertRequest();

  factory GearInsertRequest.fromJson(Map<String, dynamic> json) =>
      _$GearInsertRequestFromJson(json);

  Map<String, dynamic> toJson() => _$GearInsertRequestToJson(this);
}
