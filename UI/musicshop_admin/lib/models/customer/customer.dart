import 'package:json_annotation/json_annotation.dart';

part 'customer.g.dart';

@JsonSerializable()
class Customer {
  String? firstName;
  String? lastName;
  String? username;
  String? email;

  Customer({
    this.firstName,
    this.lastName,
    this.username,
    this.email,
  });

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerToJson(this);
}
