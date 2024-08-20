import 'package:json_annotation/json_annotation.dart';

part 'gear_category.g.dart';

@JsonSerializable()
class GearCategory {
  int? id;
  String? name;

  GearCategory();

  factory GearCategory.fromJson(Map<String, dynamic> json) =>
      _$GearCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$GearCategoryToJson(this);
}
