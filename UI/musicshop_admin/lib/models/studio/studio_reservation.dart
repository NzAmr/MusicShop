import 'package:json_annotation/json_annotation.dart';
import 'package:musicshop_admin/models/customer/customer.dart';

part 'studio_reservation.g.dart';

@JsonSerializable()
class StudioReservation {
  int? id;
  DateTime? timeFrom;
  DateTime? timeTo;
  Customer? customer;
  String? status;
  StudioReservation();

  factory StudioReservation.fromJson(Map<String, dynamic> json) =>
      _$StudioReservationFromJson(json);

  Map<String, dynamic> toJson() => _$StudioReservationToJson(this);
}
