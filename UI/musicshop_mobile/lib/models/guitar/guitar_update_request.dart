import 'package:json_annotation/json_annotation.dart';

part 'guitar_update_request.g.dart';

@JsonSerializable()
class GuitarUpdateRequest {
  int? id;
  int? guitarTypeId;
  int? brandId;
  String? pickups;
  String? pickupConfiguration;
  String? description;
  String? model;
  int? frets;
  double? price;
  String? productImage;

  GuitarUpdateRequest({
    this.id,
  });

  factory GuitarUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$GuitarUpdateRequestFromJson(json);

  Map<String, dynamic> toJson() => _$GuitarUpdateRequestToJson(this);
}
