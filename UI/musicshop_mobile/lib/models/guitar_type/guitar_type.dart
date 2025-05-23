import 'package:json_annotation/json_annotation.dart';

part 'guitar_type.g.dart';

@JsonSerializable()
class GuitarType {
  int? id;
  String? name;

  GuitarType({this.name});
  factory GuitarType.fromJson(Map<String, dynamic> json) =>
      _$GuitarTypeFromJson(json);

  Map<String, dynamic> toJson() => _$GuitarTypeToJson(this);
}
