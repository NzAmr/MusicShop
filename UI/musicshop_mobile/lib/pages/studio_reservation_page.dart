import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd HH:mm');

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
  DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime.now(),
    lastDate: DateTime(2101),
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          dialogBackgroundColor: Color(0xFF1F1F1F),
          colorScheme: Theme.of(context).colorScheme.copyWith(
            primary: Colors.amber[700],
            onPrimary: Colors.black,
            surface: Color(0xFF1F1F1F),
            onSurface: Colors.white70,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(foregroundColor: Colors.amber[700]),
          ),
          datePickerTheme: DatePickerThemeData(
            backgroundColor: Color(0xFF1F1F1F),
            headerBackgroundColor: Colors.amber[700],
            headerForegroundColor: Colors.black,
            dayForegroundColor: MaterialStateProperty.all(Colors.white70),
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
          data: Theme.of(context).copyWith(
            dialogBackgroundColor: Color(0xFF1F1F1F),
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: Colors.amber[700],
              onPrimary: Colors.black,
              surface: Color(0xFF1F1F1F),
              onSurface: Colors.white70,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Colors.amber[700]),
            ),
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Color(0xFF1F1F1F),
              hourMinuteTextColor: Colors.white70,
              hourMinuteColor: Color(0xFF2A2A2A),
              dialBackgroundColor: Color(0xFF2A2A2A),
              dialHandColor: Colors.amber[700],
              dialTextColor: Colors.white70,
              dayPeriodTextColor: Colors.white70,
              dayPeriodColor: Colors.amber[700],
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
      });
      await _showDurationPopup();
    }
  }
}


  Future<void> _showDurationPopup() async {
    if (_fromTime == null) return;

    final latestEnd = DateTime(_fromTime!.year, _fromTime!.month, _fromTime!.day, 20, 0);
    final step = Duration(minutes: 30);
    var currentEnd = _fromTime!.add(step);
    List<Duration> options = [];
    while (currentEnd.isBefore(latestEnd) || currentEnd.isAtSameMomentAs(latestEnd)) {
      options.add(currentEnd.difference(_fromTime!));
      currentEnd = currentEnd.add(step);
    }

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF1F1F1F),
        title: Text("Select Duration", style: TextStyle(color: Colors.amber[700])),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.separated(
            shrinkWrap: true,
            separatorBuilder: (_, __) => Divider(color: Colors.deepPurple.shade700),
            itemCount: options.length,
            itemBuilder: (context, index) {
              final duration = options[index];
              final hours = duration.inHours;
              final minutes = duration.inMinutes % 60;
              String label = '';
              if (hours > 0) label += '$hours h ';
              if (minutes > 0) label += '$minutes min';
              return ListTile(
                leading: Icon(Icons.access_time, color: Colors.amber[700]),
                title: Text(label.trim(),
                    style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w600)),
                tileColor: Color(0xFF2A2A2A),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                onTap: () {
                  setState(() => _toTime = _fromTime!.add(duration));
                  Navigator.of(context).pop();
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _showReservationsPopup() async {
    try {
      final reservations = await Provider.of<StudioReservationProvider>(context, listen: false)
          .getReservationsFromRequest();
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Color(0xFF1F1F1F),
          title: Text('My Reservations', style: TextStyle(color: Colors.amber[700])),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: reservations.length,
              itemBuilder: (context, index) {
                final r = reservations[index];
                return Container(
                  margin: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.deepPurple.shade700),
                    borderRadius: BorderRadius.circular(8),
                    color: Color(0xFF2A2A2A),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(8),
                    title: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                              text: 'From: ',
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber[700])),
                          TextSpan(text: '${_dateFormat.format(r.timeFrom!.toLocal())}\n', style: TextStyle(color: Colors.white70)),
                          TextSpan(
                              text: 'To: ',
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber[700])),
                          TextSpan(text: '${_dateFormat.format(r.timeTo!.toLocal())}\n', style: TextStyle(color: Colors.white70)),
                          TextSpan(
                              text: 'Status: ',
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber[700])),
                          TextSpan(text: '${r.status}', style: TextStyle(color: Colors.white70)),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('Close', style: TextStyle(color: Colors.amber[700])))
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
      backgroundColor: Color(0xFF121212),
      appBar: AppBar(
        title: Text('Add Reservation'),
                        backgroundColor: Color(0xFF272323), 
  surfaceTintColor: Color(0xFF272323), 
  elevation: 0,
      ),
      body: Center(
        child: Container(
          width: 340,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Color(0xFF1F1F1F),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 3))],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'From',
                  labelStyle: TextStyle(color: Colors.amber[700]),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  suffixIcon: Icon(Icons.calendar_today, color: Colors.amber[700]),
                  filled: true,
                  fillColor: Color(0xFF2A2A2A),
                ),
                onTap: _selectDateTime,
                readOnly: true,
                controller: TextEditingController(
                  text: _fromTime != null ? _dateFormat.format(_fromTime!.toLocal()) : 'Select Date and Time',
                ),
              ),
              SizedBox(height: 15),
              if (_toTime != null)
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.schedule, color: Colors.amber[700]),
                      SizedBox(width: 8),
                      Text('To: ${_dateFormat.format(_toTime!.toLocal())}',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white70)),
                    ],
                  ),
                ),
              SizedBox(height: 25),
              ElevatedButton.icon(
                onPressed: _submitReservation,
                icon: Icon(Icons.add, color: Colors.black),
                label: Text('Add Reservation', style: TextStyle(color: Colors.black)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber[700],
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              SizedBox(height: 15),
              ElevatedButton.icon(
                onPressed: _showReservationsPopup,
                icon: Icon(Icons.list, color: Colors.amber[700]),
                label: Text('My Reservations', style: TextStyle(color: Colors.amber[700])),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2A2A2A),
                  foregroundColor: Colors.amber[700],
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              SizedBox(height: 15),
              ElevatedButton.icon(
                onPressed: () => showDialog(context: context, builder: (_) => CalendarPopup()),
                icon: Icon(Icons.calendar_view_week, color: Colors.black),
                label: Text('View Calendar', style: TextStyle(color: Colors.black)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber[700],
                  foregroundColor: Colors.black,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
