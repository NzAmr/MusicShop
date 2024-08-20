import 'package:json_annotation/json_annotation.dart';
import 'package:musicshop_admin/models/Abstract/product.dart';
import 'package:musicshop_admin/models/brand/brand.dart';
import 'package:musicshop_admin/models/guitar_type/guitar_type.dart';

part 'guitar.g.dart';

@JsonSerializable()
class Guitar {
  int? id;
  GuitarType? guitarType;
  String? pickups;
  String? pickupConfiguration;
  int? frets;
  String? productNumber;
  Brand? brand;
  String? model;
  double? price;
  String? description;
  DateTime? covariant;
  DateTime? updatedAt;
  String? image;

  Guitar();

  factory Guitar.fromJson(Map<String, dynamic> json) => _$GuitarFromJson(json);

  Map<String, dynamic> toJson() => _$GuitarToJson(this);
}
