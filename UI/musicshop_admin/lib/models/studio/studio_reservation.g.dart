// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'studio_reservation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudioReservation _$StudioReservationFromJson(Map<String, dynamic> json) =>
    StudioReservation()
      ..id = (json['id'] as num?)?.toInt()
      ..timeFrom = json['timeFrom'] == null
          ? null
          : DateTime.parse(json['timeFrom'] as String)
      ..timeTo = json['timeTo'] == null
          ? null
          : DateTime.parse(json['timeTo'] as String)
      ..customer = json['customer'] == null
          ? null
          : Customer.fromJson(json['customer'] as Map<String, dynamic>)
      ..status = json['status'] as String?;

Map<String, dynamic> _$StudioReservationToJson(StudioReservation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'timeFrom': instance.timeFrom?.toIso8601String(),
      'timeTo': instance.timeTo?.toIso8601String(),
      'customer': instance.customer,
      'status': instance.status,
    };
