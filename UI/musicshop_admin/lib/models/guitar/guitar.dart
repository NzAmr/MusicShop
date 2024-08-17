import 'package:json_annotation/json_annotation.dart';
import 'package:musicshop_admin/models/Abstract/product.dart';

part 'guitar.g.dart';

@JsonSerializable()
class Guitar {
  int? guitarTypeId;
  String? pickups;
  String? pickupConfiguration;
  int? frets;
  String? productNumber;
  int? productImageId;
  int? brandId;
  String? model;
  double? price;
  String? description;
  DateTime? covariant;
  DateTime? updatedAt;

  Guitar();

  factory Guitar.fromJson(Map<String, dynamic> json) => _$GuitarFromJson(json);

  Map<String, dynamic> toJson() => _$GuitarToJson(this);
}
