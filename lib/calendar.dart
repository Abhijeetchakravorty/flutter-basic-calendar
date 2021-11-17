import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'event.dart';

// const _url = 'https://google.com/search?q=';

const _url = 'https://en.wikipedia.org/wiki/';
/// The app which hosts the home page which contains the calendar on it.
class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  late Map<DateTime, List<Event>> selectedEvents;
  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();
  TextEditingController _eventController = TextEditingController();
  @override
  void initState() {
    selectedEvents = {};
    super.initState();
  }

  List<Event> _getEventsfromDay(DateTime date) {
    return selectedEvents[date] ?? [];
  }

  @override
  void dispose() {
    _eventController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar Demo'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              children: [
                TableCalendar(
                  firstDay: DateTime(1990),
                  lastDay: DateTime(2050),
                  focusedDay: selectedDay,
                  calendarFormat: format,
                  onFormatChanged: (CalendarFormat _format) {
                    setState(() {
                      format = _format;
                    });
                  },
                  startingDayOfWeek: StartingDayOfWeek.sunday,
                  daysOfWeekVisible: true,
                  onDaySelected: (DateTime selectDay, DateTime focusDay) {
                    setState(() {
                      selectedDay = selectDay;
                      focusedDay = focusDay;
                    });
                    print(focusedDay);
                  },
                  // to style the calendar
                  calendarStyle: CalendarStyle(
                    isTodayHighlighted: true,
                    selectedDecoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(5.0)),
                    selectedTextStyle: TextStyle(color: Colors.white),
                    todayDecoration: BoxDecoration(
                      color: Colors.purpleAccent,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    defaultDecoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(5.0)),
                    weekendDecoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(5.0)),
                  ),
                  selectedDayPredicate: (DateTime date) {
                    return isSameDay(selectedDay, date);
                  },
                  headerStyle: HeaderStyle(
                      formatButtonVisible: true,
                      titleCentered: true,
                      formatButtonShowsNext: false,
                      formatButtonDecoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(5.0)),
                      formatButtonTextStyle: TextStyle(
                        color: Colors.white,
                      ),
                      leftChevronVisible: false,
                      rightChevronVisible: false,
                      headerPadding: EdgeInsets.symmetric(
                          horizontal: 5.0, vertical: 10.0)),
                ),
                ..._getEventsfromDay(selectedDay).map(
                  (Event event) => ListTile(
                    title: Text(event.title),
                    onTap: () => _launchURL(event.title),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showDialog(
            context: context,
            builder: (context) => AlertDialog(
                    title: Text("Add Event"),
                    content: TextFormField(
                      controller: _eventController,
                    ),
                    actions: [
                      TextButton(
                        child: Text("Cancel"),
                        onPressed: () => Navigator.pop(context),
                      ),
                      TextButton(
                        child: Text("Ok"),
                        onPressed: () {
                          if (_eventController.text.isEmpty) {
                            // Navigator.pop(context);
                            // return;
                          } else {
                            if (selectedEvents[selectedDay] != null) {
                              selectedEvents[selectedDay]!.add(
                                Event(title: _eventController.text),
                              );
                            } else {
                              selectedEvents[selectedDay] = [
                                Event(title: _eventController.text)
                              ];
                            }
                          }
                          Navigator.pop(context);
                          _eventController.clear();
                          setState(() {});
                          return;
                        },
                      ),
                    ])),
        label: Text("Add Event"),
        icon: Icon(Icons.add),
      ),
    );
  }

  void _launchURL(param) async => await canLaunch(_url + param)
      ? await launch(_url + param)
      : throw 'Could not launch $_url';
}
