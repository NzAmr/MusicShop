// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_upsert_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmployeeUpsertRequest _$EmployeeUpsertRequestFromJson(
        Map<String, dynamic> json) =>
    EmployeeUpsertRequest()
      ..firstName = json['firstName'] as String?
      ..lastName = json['lastName'] as String?
      ..username = json['username'] as String?
      ..password = json['password'] as String?
      ..passwordConfirm = json['passwordConfirm'] as String?
      ..email = json['email'] as String?
      ..phoneNumber = json['phoneNumber'] as String?;

Map<String, dynamic> _$EmployeeUpsertRequestToJson(
        EmployeeUpsertRequest instance) =>
    <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'username': instance.username,
      'password': instance.password,
      'passwordConfirm': instance.passwordConfirm,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
    };
