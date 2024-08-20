import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:musicshop_admin/models/studio/studio_reservation.dart';
import 'package:musicshop_admin/providers/studio/studio_reservation_provider.dart';

class CalendarPopup extends StatefulWidget {
  @override
  _CalendarPopupState createState() => _CalendarPopupState();
}

class _CalendarPopupState extends State<CalendarPopup> {
  List<StudioReservation> _reservations = [];
  DateTime _focusedDay = DateTime.now();
  DateTime _startOfWeek =
      DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));
  final DateTime _endOfWeek =
      DateTime.now().add(Duration(days: 7 - DateTime.now().weekday));

  @override
  void initState() {
    super.initState();
    _fetchReservations();
  }

  Future<void> _fetchReservations() async {
    try {
      final provider =
          Provider.of<StudioReservationProvider>(context, listen: false);
      final reservationsData = await provider.get();
      setState(() {
        _reservations = reservationsData;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch reservations: $e')),
      );
    }
  }

  Color _getRandomColor() {
    final random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }

  List<Appointment> _getAppointments() {
    final appointments = <Appointment>[];
    for (var reservation in _reservations) {
      final from = reservation.timeFrom?.toLocal();
      final to = reservation.timeTo?.toLocal();

      if (from != null && to != null) {
        appointments.add(Appointment(
          startTime: from,
          endTime: to,
          subject: (reservation.customer?.firstName ?? '') +
              ' ' +
              (reservation.customer?.lastName ?? ''),
          color: _getRandomColor(),
        ));
      }
    }
    return appointments;
  }

  @override
  Widget build(BuildContext context) {
    final appointments = _getAppointments();

    return Dialog(
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
          maxWidth: MediaQuery.of(context).size.width * 0.9,
        ),
        child: SfCalendar(
          view: CalendarView.week,
          dataSource: _AppointmentDataSource(appointments),
          timeSlotViewSettings: TimeSlotViewSettings(
            startHour: 7,
            endHour: 21,
            timeInterval: Duration(minutes: 60),
            timeIntervalHeight: 50,
          ),
          headerStyle: CalendarHeaderStyle(
            textStyle: TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }
}

class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}
