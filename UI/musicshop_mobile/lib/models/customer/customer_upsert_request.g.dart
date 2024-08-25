// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_upsert_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomerUpsertRequest _$CustomerUpsertRequestFromJson(
        Map<String, dynamic> json) =>
    CustomerUpsertRequest()
      ..firstName = json['firstName'] as String?
      ..lastName = json['lastName'] as String?
      ..username = json['username'] as String?
      ..password = json['password'] as String?
      ..passwordConfirm = json['passwordConfirm'] as String?
      ..email = json['email'] as String?
      ..phoneNumber = json['phoneNumber'] as String?;

Map<String, dynamic> _$CustomerUpsertRequestToJson(
        CustomerUpsertRequest instance) =>
    <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'username': instance.username,
      'password': instance.password,
      'passwordConfirm': instance.passwordConfirm,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
    };
