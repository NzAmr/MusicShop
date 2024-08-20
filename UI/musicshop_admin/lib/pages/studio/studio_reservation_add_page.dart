import 'package:flutter/material.dart';
import 'package:musicshop_admin/models/studio/studio_reservation_insert_request.dart';
import 'package:musicshop_admin/pages/studio/studio_calendar_popup.dart';
import 'package:musicshop_admin/providers/studio/studio_reservation_provider.dart';
import 'package:provider/provider.dart';

class StudioReservationPage extends StatefulWidget {
  @override
  _ReservationPageState createState() => _ReservationPageState();
}

class _ReservationPageState extends State<StudioReservationPage> {
  DateTime? _fromTime;
  DateTime? _toTime;
  final TextEditingController _durationController = TextEditingController();

  Future<void> _submitReservation() async {
    if (_fromTime == null || _toTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select the start time and duration.')),
      );
      return;
    }

    final request = StudioReservationInsertRequest()
      ..timeFrom = _fromTime
      ..timeTo = _toTime
      ..customerId = 2;

    try {
      await Provider.of<StudioReservationProvider>(context, listen: false)
          .insert(request.toJson());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Reservation added successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add reservation: $e')),
      );
    }
  }

  Future<void> _selectDateTime() async {
    final theme = Theme.of(context);

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: theme.copyWith(
            dialogBackgroundColor: theme.colorScheme.surface,
            primaryColor: theme.colorScheme.primary,
            hintColor: theme.colorScheme.secondary,
            textTheme: theme.textTheme.copyWith(
              bodyLarge: TextStyle(color: theme.colorScheme.onSurface),
              bodyMedium: TextStyle(color: theme.colorScheme.onSurface),
              titleMedium: TextStyle(color: theme.colorScheme.onSurface),
              titleSmall: TextStyle(color: theme.colorScheme.onSurface),
            ),
            datePickerTheme: DatePickerThemeData(
              backgroundColor: theme.colorScheme.surface,
              headerBackgroundColor: theme.colorScheme.primary,
              headerForegroundColor: theme.colorScheme.onPrimary,
              headerHeadlineStyle:
                  TextStyle(color: theme.colorScheme.onPrimary),
              headerHelpStyle: TextStyle(color: theme.colorScheme.onPrimary),
              dayStyle: TextStyle(color: theme.colorScheme.onSurface),
              dayBackgroundColor: MaterialStateProperty.resolveWith(
                  (states) => theme.colorScheme.surface),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (context, child) {
          return Theme(
            data: theme.copyWith(
              dialogBackgroundColor: theme.colorScheme.surface,
              primaryColor: theme.colorScheme.primary,
              hintColor: theme.colorScheme.secondary,
              textTheme: theme.textTheme.copyWith(
                bodyLarge: TextStyle(color: theme.colorScheme.onSurface),
                bodyMedium: TextStyle(color: theme.colorScheme.onSurface),
                titleMedium: TextStyle(color: theme.colorScheme.onSurface),
                titleSmall: TextStyle(color: theme.colorScheme.onSurface),
              ),
              timePickerTheme: TimePickerThemeData(
                  backgroundColor: theme.colorScheme.surface,
                  hourMinuteTextColor: theme.colorScheme.onSurface,
                  hourMinuteColor: theme.colorScheme.surface,
                  dialBackgroundColor: theme.colorScheme.surface,
                  dialHandColor: theme.colorScheme.primary,
                  dialTextColor: theme.colorScheme.onSurface,
                  helpTextStyle: TextStyle(color: theme.colorScheme.onSurface),
                  dayPeriodTextColor: theme.colorScheme.onSurface,
                  dayPeriodColor: theme.colorScheme.primary),
            ),
            child: child!,
          );
        },
      );

      if (pickedTime != null) {
        setState(() {
          _fromTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          _updateToTime();
        });
      }
    }
  }

  void _updateToTime() {
    if (_fromTime != null) {
      final durationHours = int.tryParse(_durationController.text) ?? 0;
      if (durationHours > 0 && durationHours <= 4) {
        setState(() {
          _toTime = _fromTime!.add(Duration(hours: durationHours));
        });
      } else {
        _toTime = null;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Reservation'),
      ),
      body: Center(
        child: Container(
          width: 300,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'From'),
                onTap: _selectDateTime,
                readOnly: true,
                controller: TextEditingController(
                  text: _fromTime != null
                      ? _fromTime!.toLocal().toString()
                      : 'Select Date and Time',
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _durationController,
                decoration: InputDecoration(
                  labelText: 'Duration (hours)',
                  hintText: 'Enter duration (max 4 hours)',
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  _updateToTime();
                },
              ),
              if (_toTime != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    'To: ${_toTime!.toLocal()}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitReservation,
                child: Text('Add Reservation'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => CalendarPopup(),
                  );
                },
                child: Text('View Calendar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
