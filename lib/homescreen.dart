import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  Map<DateTime, List<String>> _events = {};

  void _onFormatChanged(CalendarFormat format) {
    setState(() {
      _calendarFormat = format;
    });
  }

  TextEditingController _eventController = TextEditingController();

  bool isSameDay(DateTime? selectedDay, DateTime day) {
    return selectedDay?.year == day.year &&
        selectedDay?.month == day.month &&
        selectedDay?.day == day.day;
  }

  void _showTaskCountDialog() {
    final int taskCount = _events[_selectedDay]?.length ?? 0;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Task Count'),
          content: Text('You have $taskCount tasks on this day.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _clearSelection() {
    setState(() {
      _selectedDay = null;
    });
  }

  void _removeTask(int index) {
    setState(() {
      final selectedDay = _selectedDay ?? DateTime.now();
      _events[selectedDay]?.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          "Todo Application",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),

        ),
        centerTitle: true,
        toolbarHeight: 75,
        elevation: 0,
      ),
      body: Column(
        children: [
          TableCalendar(
            calendarFormat: _calendarFormat,
            focusedDay: _focusedDay,
            firstDay: DateTime.utc(2023, 1, 1),
            lastDay: DateTime.utc(2024, 12, 31),
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
              _showTaskCountDialog();
            },
            onPageChanged: (focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
                _clearSelection();
              });
            },
            onFormatChanged: _onFormatChanged,
            availableCalendarFormats: const {
              CalendarFormat.month: 'Month',
              CalendarFormat.twoWeeks: '2 weeks',
            },
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: _events[_selectedDay]?.length ?? 0,
              itemBuilder: (context, index) {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  color: Colors.blue[900],
                  child: ListTile(
                    title: Text(
                      _events[_selectedDay]![index],
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      color: Colors.red,
                      highlightColor: Colors.red.withOpacity(0.5),
                      onPressed: () {
                        _removeTask(index);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  flex: 70,
                  child: Container(
                    height: 40,
                    child: TextFormField(
                      controller: _eventController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        fillColor: Colors.blue[300],
                        filled: true,
                        labelText: 'Write a Task: ',
                        labelStyle: TextStyle(
                          color: Colors.indigo[900],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 5),
                Expanded(
                  flex: 27,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        final selectedDay = _selectedDay ?? DateTime.now();
                        _events[selectedDay] = List.from(_events[selectedDay] ?? []);
                        _events[selectedDay]!.add(_eventController.text);
                        _eventController.clear();
                      });
                    },
                    child: Container(
                      height: 15,
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: Text("Add the Task"),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
