import 'package:json_annotation/json_annotation.dart';

part 'studio_reservation_insert_request.g.dart';

@JsonSerializable()
class StudioReservationInsertRequest {
  DateTime? timeFrom;
  DateTime? timeTo;
  int? customerId;

  StudioReservationInsertRequest();

  factory StudioReservationInsertRequest.fromJson(Map<String, dynamic> json) =>
      _$StudioReservationInsertRequestFromJson(json);

  Map<String, dynamic> toJson() => _$StudioReservationInsertRequestToJson(this);
}
