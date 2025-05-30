import 'package:json_annotation/json_annotation.dart';
import 'package:musicshop_admin/models/brand/brand.dart';
import 'package:musicshop_admin/models/guitar_type/guitar_type.dart';

part 'bass.g.dart';

@JsonSerializable()
class Bass {
  int? id;
  String? productNumber;
  Brand? brand;
  String? model;
  double? price;
  String? description;
  GuitarType? guitarType;
  String? pickups;
  int? frets;
  String? productImage;

  Bass();

  factory Bass.fromJson(Map<String, dynamic> json) => _$BassFromJson(json);

  Map<String, dynamic> toJson() => _$BassToJson(this);
}
