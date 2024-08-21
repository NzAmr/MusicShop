import 'package:json_annotation/json_annotation.dart';

part 'gear_update_request.g.dart';

@JsonSerializable()
class GearUpdateRequest {
  int? id;
  String? description;
  String? model;
  int? brandId;
  double? price;
  String? productImage;
  int? gearCategoryId;
  GearUpdateRequest();

  factory GearUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$GearUpdateRequestFromJson(json);

  Map<String, dynamic> toJson() => _$GearUpdateRequestToJson(this);
}
