import 'package:json_annotation/json_annotation.dart';
import 'package:musicshop_admin/models/Abstract/product.dart';
import 'package:musicshop_admin/models/brand/brand.dart';

part 'amplifier.g.dart';

@JsonSerializable()
class Amplifier {
  int? id;
  String? productNumber;
  Brand? brand;
  String? model;
  double? price;
  String? description;
  int? voltage;
  int? powerRating;
  bool? headphoneJack;
  bool? usbjack;
  int? numberOfPresets;
  DateTime? createdAt;
  DateTime? updatedAt;

  Amplifier();

  factory Amplifier.fromJson(Map<String, dynamic> json) =>
      _$AmplifierFromJson(json);

  Map<String, dynamic> toJson() => _$AmplifierToJson(this);
}
