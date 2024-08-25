import 'package:json_annotation/json_annotation.dart';

part 'customer_upsert_request.g.dart';

@JsonSerializable()
class CustomerUpsertRequest {
  String? firstName;
  String? lastName;
  String? username;
  String? password;
  String? passwordConfirm;
  String? email;
  String? phoneNumber;

  CustomerUpsertRequest();

  factory CustomerUpsertRequest.fromJson(Map<String, dynamic> json) =>
      _$CustomerUpsertRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerUpsertRequestToJson(this);
}
