// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'studio_reservation_insert_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudioReservationInsertRequest _$StudioReservationInsertRequestFromJson(
        Map<String, dynamic> json) =>
    StudioReservationInsertRequest()
      ..timeFrom = json['timeFrom'] == null
          ? null
          : DateTime.parse(json['timeFrom'] as String)
      ..timeTo = json['timeTo'] == null
          ? null
          : DateTime.parse(json['timeTo'] as String);

Map<String, dynamic> _$StudioReservationInsertRequestToJson(
        StudioReservationInsertRequest instance) =>
    <String, dynamic>{
      'timeFrom': instance.timeFrom?.toIso8601String(),
      'timeTo': instance.timeTo?.toIso8601String(),
    };
