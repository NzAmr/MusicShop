import 'package:json_annotation/json_annotation.dart';
import 'package:musicshop_admin/models/Abstract/base_model.dart';

part 'brand.g.dart';

@JsonSerializable()
class Brand {
  int? id;
  String? name;

  Brand();

  factory Brand.fromJson(Map<String, dynamic> json) => _$BrandFromJson(json);

  Map<String, dynamic> toJson() => _$BrandToJson(this);
}
