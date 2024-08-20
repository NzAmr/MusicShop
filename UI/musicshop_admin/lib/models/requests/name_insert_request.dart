import 'package:json_annotation/json_annotation.dart';

part 'name_insert_request.g.dart';

@JsonSerializable()
class NameInsertRequest {
  String? name;

  NameInsertRequest();

  factory NameInsertRequest.fromJson(Map<String, dynamic> json) =>
      _$NameInsertRequestFromJson(json);

  Map<String, dynamic> toJson() => _$NameInsertRequestToJson(this);
}
