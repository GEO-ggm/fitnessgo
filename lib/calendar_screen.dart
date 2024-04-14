import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class ScheduleScreen extends StatefulWidget {
  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  Map<DateTime, List<dynamic>> _trainingSessions = {};

  @override
  void initState() {
    super.initState();
    // Инициализируем _trainingSessions прямо здесь, чтобы убедиться, что они не перезаписываются.
    _trainingSessions = {
      DateTime(2024, 10, 3, 0, 0 ): ['Утренняя Йога', 'Вечерний Бег'],
      DateTime(2024, 4, 2, 0, 0): ['Специальная тренировка'],
      // Добавьте больше тренировок по аналогии
    };
     _trainingSessions.forEach((key, value) {
      print('Тренировки: $_trainingSessions');
    print('Дата: ${key.toIso8601String()}, тренировки: $value');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Расписание тренировок'),
      ),
      body: Column(
        children: <Widget>[
          TableCalendar(
            firstDay: DateTime.utc(2023, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            rangeSelectionMode: RangeSelectionMode.toggledOff,
            calendarFormat: _calendarFormat,
            eventLoader: (day) {

              return _trainingSessions[DateTime(day.year, day.month, day.day, 0, 0)] ?? [];
            },
            onDaySelected: (selectedDay, focusedDay) {
              
              if (!isSameDay(_selectedDay, selectedDay)) {
                print('Выбранная дата: ${selectedDay.toIso8601String()}');
                print('Тренировки на эту дату: ${_trainingSessions[selectedDay]}');
                print('New day selected: ${selectedDay.toIso8601String()}');
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay; // Обновляем _focusedDay здесь также
                });
              }
            },
          ),
          Expanded(
            child: Text('Тренировок: ${_trainingSessions[_selectedDay]?.length ?? 0}')
          
         //   child: ListView.builder(
         //     itemCount: _trainingSessions[_selectedDay]?.length ?? 0,
         //     itemBuilder: (context, index) {
         //       var sessionTitles = _trainingSessions[_selectedDay] ?? [];
         //       return ListTile(
         //         title: Text(sessionTitles[index]),
         //        // Добавьте сюда обработчик нажатия, если он вам нужен
                
      
        
              
            ),
            ]
          ),
        
      
    );
  }
}
