import 'package:flutter/material.dart';
import 'package:musicshop_mobile/models/studio/studio_reservation_insert_request.dart';
import 'package:musicshop_mobile/pages/studio_calendar_popup.dart';
import 'package:musicshop_mobile/providers/studio/studio_reservation_provider.dart';
import 'package:provider/provider.dart';

class StudioReservationPage extends StatefulWidget {
  @override
  _StudioReservationPageState createState() => _StudioReservationPageState();
}

class _StudioReservationPageState extends State<StudioReservationPage> {
  DateTime? _fromTime;
  DateTime? _toTime;
  final TextEditingController _durationController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _submitReservation() async {
    if (_fromTime == null || _toTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select the start time and duration.')),
      );
      return;
    }

    final request = StudioReservationInsertRequest()
      ..timeFrom = _fromTime
      ..timeTo = _toTime;

    try {
      await Provider.of<StudioReservationProvider>(context, listen: false)
          .createCustomerReservation(request);
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
                dayPeriodColor: theme.colorScheme.primary,
              ),
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
      if (durationHours > 0 && durationHours <= 12) {
        setState(() {
          _toTime = _fromTime!.add(Duration(hours: durationHours));
        });
      } else {
        setState(() {
          _toTime = null;
        });
      }
    }
  }

  Future<void> _showReservationsPopup() async {
    try {
      final reservations =
          await Provider.of<StudioReservationProvider>(context, listen: false)
              .getReservationsFromRequest();
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('My Reservations'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: reservations.length,
              itemBuilder: (context, index) {
                final reservation = reservations[index];
                return Container(
                  margin: EdgeInsets.only(bottom: 10.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2.0),
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.grey[200],
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(8.0),
                    title: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'From: ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          TextSpan(
                            text: '${reservation.timeFrom?.toLocal()}\n',
                            style: TextStyle(color: Colors.black87),
                          ),
                          TextSpan(
                            text: 'To: ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          TextSpan(
                            text: '${reservation.timeTo?.toLocal()}\n',
                            style: TextStyle(color: Colors.black87),
                          ),
                          TextSpan(
                            text: 'Status: ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          TextSpan(
                            text: '${reservation.status}',
                            style: TextStyle(color: Colors.black87),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load reservations: $e')),
      );
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
                  hintText: 'Enter duration (max 12 hours)',
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
                onPressed: _showReservationsPopup,
                child: Text('My Reservations'),
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
