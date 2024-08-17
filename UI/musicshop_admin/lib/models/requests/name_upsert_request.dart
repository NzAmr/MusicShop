import 'package:json_annotation/json_annotation.dart';

part 'name_upsert_request.g.dart';

@JsonSerializable()
class NameUpsertRequest {
  String? name;

  NameUpsertRequest();

  factory NameUpsertRequest.fromJson(Map<String, dynamic> json) =>
      _$NameUpsertRequestFromJson(json);

  Map<String, dynamic> toJson() => _$NameUpsertRequestToJson(this);
}
