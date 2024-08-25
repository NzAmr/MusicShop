import 'package:json_annotation/json_annotation.dart';

part 'employee_upsert_request.g.dart';

@JsonSerializable()
class EmployeeUpsertRequest {
  String? firstName;
  String? lastName;
  String? username;
  String? password;
  String? passwordConfirm;
  String? email;
  String? phoneNumber;

  EmployeeUpsertRequest();

  factory EmployeeUpsertRequest.fromJson(Map<String, dynamic> json) =>
      _$EmployeeUpsertRequestFromJson(json);

  Map<String, dynamic> toJson() => _$EmployeeUpsertRequestToJson(this);
}
