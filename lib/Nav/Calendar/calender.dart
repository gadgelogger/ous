import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:icalendar_parser/icalendar_parser.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:url_launcher/url_launcher.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late Future<ICalendar> _iCalendarFuture;

  Future<ICalendar> _loadLocalICalendarFile(String fileName) async {
    final icsString = await rootBundle.loadString('assets/files/2023_ous_schedule.ics');
    return ICalendar.fromString(icsString);
  }

  @override
  void initState() {
    super.initState();
    _iCalendarFuture = _loadLocalICalendarFile('assets/files/2023_ous_schedule.ics');
  }

  List<Appointment> _getAppointments(ICalendar? iCalendar) {
    if (iCalendar == null) {
      return [];
    }

    return iCalendar.data.map((event) {
      DateTime? start = event['dtstart'] is IcsDateTime ? event['dtstart'].toDateTime() : DateTime.tryParse(event['dtstart']);
      DateTime? end = event['dtend'] is IcsDateTime ? event['dtend'].toDateTime() : DateTime.tryParse(event['dtend']);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('行事予定'),
      ),
      body: FutureBuilder<ICalendar>(
        future: _iCalendarFuture,
        builder: (BuildContext context, AsyncSnapshot<ICalendar> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return SfCalendar(
              view: CalendarView.schedule,
              dataSource: AppointmentDataSource(_getAppointments(snapshot.data)),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.calendar_month_outlined),
        onPressed: (){
          launch('https://www.ous.ac.jp/common/files//285/202303131022360193654.pdf');
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
