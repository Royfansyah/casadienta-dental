import 'package:casadienta_dental/settings/constants/warna_apps.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class TableCalendarWidget extends StatefulWidget {
  final Function(DateTime) onDateSelected;

  const TableCalendarWidget({Key? key, required this.onDateSelected})
      : super(key: key);

  @override
  State<TableCalendarWidget> createState() => _TableCalendarWidgetState();
}

class _TableCalendarWidgetState extends State<TableCalendarWidget> {
  late DateTime today;
  late DateTime firstDay;
  late DateTime lastDay;

  @override
  void initState() {
    super.initState();
    today = DateTime.now();
    firstDay = today;
    lastDay =
        today.add(Duration(days: 2)); // Mengatur lastDay dua hari ke depan
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    widget.onDateSelected(selectedDay);
    setState(() {
      today = selectedDay;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(today.toString().split(" ")[0]),
        Container(
          child: TableCalendar(
            rowHeight: 43,
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
            availableGestures: AvailableGestures.all,
            selectedDayPredicate: (day) => isSameDay(day, today),
            focusedDay: today,
            firstDay: firstDay,
            lastDay: lastDay,
            onDaySelected: _onDaySelected,
            calendarStyle: CalendarStyle(
              selectedDecoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue, // Warna background saat dipilih
              ),
              selectedTextStyle: TextStyle(
                color: Colors.white, // Warna teks saat dipilih
              ),
            ),
          ),
        ),
      ],
    );
  }
}
