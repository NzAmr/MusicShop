import 'package:json_annotation/json_annotation.dart';

part 'brand.g.dart';

@JsonSerializable()
class Brand {
  int? id;
  String? name;

  Brand({int? id});

  factory Brand.fromJson(Map<String, dynamic> json) => _$BrandFromJson(json);

  Map<String, dynamic> toJson() => _$BrandToJson(this);
}
