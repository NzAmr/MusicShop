import 'package:flutter/material.dart';
import 'package:musicshop_admin/models/customer/customer.dart';
import 'package:musicshop_admin/pages/studio/studio_calendar_popup.dart';
import 'package:musicshop_admin/providers/customer/customer_provider.dart';
import 'package:musicshop_admin/models/studio/studio_reservation_insert_request.dart';
import 'package:musicshop_admin/providers/studio/studio_reservation_provider.dart';
import 'package:provider/provider.dart';

class StudioReservationPage extends StatefulWidget {
  @override
  _StudioReservationPageState createState() => _StudioReservationPageState();
}

class _StudioReservationPageState extends State<StudioReservationPage> {
  DateTime? _fromTime;
  DateTime? _toTime;
  final TextEditingController _durationController = TextEditingController();
  int? _selectedCustomerId;
  String? _selectedCustomerName;
  Future<List<Customer>>? _customersFuture;

  @override
  void initState() {
    super.initState();
    _customersFuture =
        Provider.of<CustomerProvider>(context, listen: false).get();
  }

  Future<void> _selectCustomer() async {
    final customers = await _customersFuture;

    if (customers == null) return;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.5,
          height: MediaQuery.of(context).size.height * 0.7,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Select Customer',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 4.0,
                    mainAxisSpacing: 4.0,
                    childAspectRatio: 2 / 1,
                  ),
                  itemCount: customers.length,
                  itemBuilder: (context, index) {
                    final customer = customers[index];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedCustomerId = customer.id;
                          _selectedCustomerName =
                              '${customer.firstName ?? 'No First Name'} ${customer.lastName ?? 'No Last Name'}';
                        });
                        Navigator.of(context).pop();
                      },
                      child: Card(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        margin: const EdgeInsets.all(8.0),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.white, width: 1.5),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                customer.username ?? 'No username',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                '${customer.firstName ?? 'No First Name'} ${customer.lastName ?? 'No Last Name'}',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitReservation() async {
    if (_fromTime == null || _toTime == null || _selectedCustomerId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Please select the start time, duration, and customer.')),
      );
      return;
    }

    final request = StudioReservationInsertRequest()
      ..timeFrom = _fromTime
      ..timeTo = _toTime
      ..customerId = _selectedCustomerId;

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
              if (_selectedCustomerName != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    'Selected User: $_selectedCustomerName',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _selectCustomer,
                child: Text('Select Customer'),
              ),
              SizedBox(height: 10),
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
