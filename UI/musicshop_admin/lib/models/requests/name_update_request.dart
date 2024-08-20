import 'package:json_annotation/json_annotation.dart';

part 'name_update_request.g.dart';

@JsonSerializable()
class NameUpdateRequest {
  int? id;
  String? name;

  NameUpdateRequest();

  factory NameUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$NameUpdateRequestFromJson(json);

  Map<String, dynamic> toJson() => _$NameUpdateRequestToJson(this);
}
