import 'package:fitnessgo/train_detail_check.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

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
  _loadUserWorkouts();
  }
  
void _loadUserWorkouts() {
  var currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser != null) {
    FirebaseFirestore.instance
      .collection('UserTrainings')
      .where('userId', isEqualTo: currentUser.uid,)
      .snapshots()
      .listen((snapshot) {
        
        if (snapshot.docs.isEmpty) {
          print("No training sessions found for user: ${currentUser.uid}");
        } else {
          print("Found ${snapshot.docs.length} training sessions");
        }
        
        Map<DateTime, List<Map<String, dynamic>>> newTrainingSessions = {};
        List<Future> futures = [];
        for (var doc in snapshot.docs) {
          var data = doc.data() as Map<String, dynamic>;
          var workoutId = data['workoutId'] as String?;
          
       
          FirebaseFirestore.instance
              .collection('Trainings')
              .doc(workoutId)
              .get()
              .then((workoutDoc) {
                if (workoutDoc.exists) {
                  var workoutData = workoutDoc.data() as Map<String, dynamic>;
                  var date = (workoutData['date'] as Timestamp).toDate().toUtc();
                  var dateKey = DateTime.utc(date.year, date.month, date.day);
                  
                  if (!newTrainingSessions.containsKey(dateKey)) {
                    print("Creating dateKey: $dateKey");
                    newTrainingSessions[dateKey] = [];
                  }

                  newTrainingSessions[dateKey]?.add({
                    'title': workoutData['title'],
                    'description': workoutData['description'],
                    'time': DateFormat('HH:mm').format(date),
                    'date': date,
                    'workoutId': workoutId
                  });

                  print("Added workout to sessions: ${newTrainingSessions[dateKey]}");
                } else {
                  print("No workout data found for workout ID: $workoutId");
                }
                
                setState(() {
                  _trainingSessions = newTrainingSessions;
                  print("State updated with new training sessions");
                });
              });
        }
      });
  } else {
    print("No current user found");
  }
}


@override
Widget build(BuildContext context) {
  print("Building Schedule Screen with selected day: $_selectedDay");
  print("Training sessions for selected day: ${_trainingSessions[_selectedDay]}");
  return Scaffold(
    appBar: AppBar(
      title: Text('Расписание тренировок'),
    ),
    body: Column(
      children: <Widget>[
        TableCalendar(
          firstDay: DateTime.utc(2023, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _focusedDay,
          calendarFormat: _calendarFormat,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          onDaySelected: (selectedDay, focusedDay) {
            var formattedSelectedDay = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
            print("Selected day: $formattedSelectedDay");
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          },
          eventLoader: (day) => _trainingSessions[DateTime.utc(day.year, day.month, day.day)] ?? [],
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _trainingSessions[_selectedDay]?.length ?? 0,
            itemBuilder: (context, index) {
              var session = _trainingSessions[_selectedDay]![index];
              return ListTile(
                title: Text(session['title']),
                subtitle: Text("${DateFormat('dd.MM в HH:mm').format(session['date'].toLocal())} - ${session['description']}"),
                onTap: (){
                  if (session.containsKey('workoutId') && session['workoutId'] != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TrainDetailCheck(trainingId: session['workoutId']),
                    ),
                  );
                } else {
                  print("Workout ID is null or missing for this session");
                }
              },
              );
            },
          ),
        ),
      ],
    ),
  );
}
}
