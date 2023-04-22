import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:icalendar_parser/icalendar_parser.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late Future<List<ICalendar>> _iCalendarFutures;

  Future<ICalendar> _loadLocalICalendarFile(String fileName) async {
    final icsString = await rootBundle.loadString(fileName);
    return ICalendar.fromString(icsString);
  }

  Future<int> _loadSelectedCalendarIndex() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('selectedCalendarIndex') ?? 0;
  }

  void _saveSelectedCalendarIndex(int index) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('selectedCalendarIndex', index);
  }

  @override
  void initState() {
    super.initState();
    _iCalendarFutures = Future.wait([
      _loadLocalICalendarFile('assets/files/2023_ous_schedule.ics'),
      _loadLocalICalendarFile('assets/files/2023_ous_schedule_imabari.ics'),
    ]);
    _loadSelectedCalendarIndex().then((value) {
      setState(() {
        _selectedCalendarIndex = value;
      });
    });
  }

  List<Appointment> _getAppointments(ICalendar? iCalendar) {
    if (iCalendar == null) {
      return [];
    }

    return iCalendar.data.map((event) {
      DateTime? start = event['dtstart'] is IcsDateTime ? event['dtstart']
          .toDateTime() : DateTime.tryParse(event['dtstart']);
      DateTime? end = event['dtend'] is IcsDateTime ? event['dtend']
          .toDateTime() : DateTime.tryParse(event['dtend']);

      if (start == null) {
        start = DateTime.now();
      }

      if (end == null) {
        end = start.add(Duration(hours: 1));
      }

      return Appointment(
        startTime: start,
        endTime: end,
        subject: event['summary'] ?? 'Untitled',
        color: Colors.blue,
      );
    }).toList();
  }

  bool _isScheduleView = true;
  int _selectedCalendarIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('行事予定'),
        actions: [
        DropdownButton<int>(
        value: _selectedCalendarIndex,
        onChanged: (int? newValue) {
          if (newValue != null) {
            setState(() {
              _selectedCalendarIndex = newValue;
            });
            _saveSelectedCalendarIndex(newValue);
          }
        },
        items: [
          DropdownMenuItem(
            child: Text('岡山'),
            value: 0,
          ),
          DropdownMenuItem(
            child: Text('今治'),
            value: 1,
          ),
        ],
      ),
    ]),
    body: FutureBuilder<List<ICalendar>>(
    future: _iCalendarFutures,
    builder: (BuildContext context, AsyncSnapshot<List<ICalendar>> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
    return const Center(child: CircularProgressIndicator());
    } else if (snapshot.hasError) {
    return Text('Error: ${snapshot.error}');
    } else {
    final selectedCalendar = snapshot.data?[_selectedCalendarIndex];
    return SfCalendar(
    scheduleViewSettings: ScheduleViewSettings(
    appointmentItemHeight: 70,
    hideEmptyScheduleWeek: true,
    monthHeaderSettings: MonthHeaderSettings(
    backgroundColor: Theme.of(context).colorScheme.primary,
    ),
    ),
    view: CalendarView.schedule,
    cellBorderColor: Theme.of(context).colorScheme.primary,
    dataSource: AppointmentDataSource(_getAppointments(selectedCalendar)),
    );
    }
    },
    ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.calendar_month_outlined),
          onPressed: () {
            String url;
            if (_selectedCalendarIndex == 0) {
              url = 'https://www.ous.ac.jp/common/files//285/202303131022360193654.pdf';
            } else {
              url = 'https://www.ous.ac.jp/common/files//285/202304181332270709155.pdf'; // 今治カレンダーのURLを指定してください
            }
            launch(url);
          },
        ),

    );
  }
}

class AppointmentDataSource extends CalendarDataSource {
  AppointmentDataSource(List<Appointment> appointments) {
    this.appointments = appointments;
  }
}