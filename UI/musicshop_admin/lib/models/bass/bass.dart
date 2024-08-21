import 'package:json_annotation/json_annotation.dart';
import 'package:musicshop_admin/models/Abstract/product.dart';
import 'package:musicshop_admin/models/guitar_type/guitar_type.dart';

part 'bass.g.dart';

@JsonSerializable()
class Bass {
  int? id;
  String? ProductNumber;
  int? ProductImageId;
  int? BrandId;
  String? Model;
  double? Price;
  String? Description;
  DateTime? CreatedAt;
  DateTime? UpdatedAt;
  GuitarType? guitarType;
  String? pickups;
  int? frets;
  String? image;

  Bass();

  factory Bass.fromJson(Map<String, dynamic> json) => _$BassFromJson(json);

  Map<String, dynamic> toJson() => _$BassToJson(this);
}
