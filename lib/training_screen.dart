import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';


class UserWorkoutScreen extends StatefulWidget {
  @override
  _UserWorkoutScreenState createState() => _UserWorkoutScreenState();
}

class _UserWorkoutScreenState extends State<UserWorkoutScreen> {
  Stream<List<QueryDocumentSnapshot>> _getWorkouts() {
    return FirebaseFirestore.instance
        .collection('Trainings')
        .snapshots()
        .map((snapshot) => snapshot.docs);
  }
void registerForWorkout(String workoutId, DateTime workoutDate) {
  var currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser != null) {
    FirebaseFirestore.instance.collection('UserTrainings').add({
      'userId': currentUser.uid,
      'workoutId': workoutId,
      'date': Timestamp.fromDate(workoutDate),
    }).then((value) => print("User registered for workout"))
      .catchError((error) => print("Failed to register user: $error"));
  }
}


  void _showWorkoutDetails(String workoutId, Map<String, dynamic> workoutData) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(workoutData['title'], style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text(workoutData['description']),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Логика для записи на тренировку
                    registerForWorkout(workoutId, (workoutData['date'] as Timestamp).toDate().toUtc());
                    Navigator.pop(context);
                  },
                  child: Text('Записаться'),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Доступные тренировки"),
      ),
      body: StreamBuilder<List<QueryDocumentSnapshot>>(
        stream: _getWorkouts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("Нет доступных тренировок"));
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var doc = snapshot.data![index];
              var data = doc.data() as Map<String, dynamic>;
              return ListTile(
                title: Text(data['title']),
                subtitle: Text("${DateFormat('dd.MM.yyyy HH:mm').format(data['date'].toDate())} - Вместимость: ${data['capacity']}"),
                trailing: IconButton(
                  icon: Icon(Icons.info_outline),
                  onPressed: () => _showWorkoutDetails(doc.id, data),
                ),
                onTap: () => _showWorkoutDetails(doc.id, data),
              );
            },
          );
        },
      ),
    );
  }
}
