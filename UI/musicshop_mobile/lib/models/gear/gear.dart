import 'package:json_annotation/json_annotation.dart';
import 'package:musicshop_mobile/models/brand/brand.dart';
import 'package:musicshop_mobile/models/gear_category/gear_category.dart';

part 'gear.g.dart';

@JsonSerializable()
class Gear {
  int? id;
  String? productNumber;
  Brand? brand;
  String? model;
  double? price;
  String? description;
  DateTime? createdAt;
  DateTime? updatedAt;
  GearCategory? gearCategory;
  String? productImage;

  Gear();

  factory Gear.fromJson(Map<String, dynamic> json) => _$GearFromJson(json);

  Map<String, dynamic> toJson() => _$GearToJson(this);
}
