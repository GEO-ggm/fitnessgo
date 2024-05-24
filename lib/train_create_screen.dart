import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'add_training_screen.dart';

class TrainerWorkoutScreen extends StatefulWidget {
  @override
  _TrainerWorkoutScreenState createState() => _TrainerWorkoutScreenState();
}
class _TrainerWorkoutScreenState extends State<TrainerWorkoutScreen> {
  final currentUser = FirebaseAuth.instance.currentUser;
  Future<void> _refreshList() async {
    setState(() {
      // Просто вызываем setState чтобы виджет StreamBuilder перерисовался
      // Фактический запрос к Firestore произойдет автоматически
    });
  }
  Stream<List<QueryDocumentSnapshot>> _getTrainerWorkouts() {
    return FirebaseFirestore.instance
        .collection('Trainings')
        .where('coachId', isEqualTo: currentUser?.uid)
        .snapshots()
        .map((snapshot) => snapshot.docs);
  }

  void _deleteWorkout(String docId) {
    FirebaseFirestore.instance.collection('Trainings').doc(docId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Тренировки"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Переход к экрану добавления тренировки
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddTrainingScreen()),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
      onRefresh: _refreshList,
      child: StreamBuilder<List<QueryDocumentSnapshot>>(
        stream: _getTrainerWorkouts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("Список ваших тренировок будет здесь"));
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var doc = snapshot.data![index];
              var data = doc.data() as Map<String, dynamic>;
              return Dismissible(
                key: Key(doc.id),
                background: Container(color: Colors.red, child: Icon(Icons.delete, color: Colors.white), alignment: Alignment.centerRight, padding: EdgeInsets.only(right: 20)),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Подтверждение"),
                        content: Text("Вы точно хотите отменить тренировку?"),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Закрыть диалог
                            },
                            child: Text("Нет"),
                          ),
                          TextButton(
                            onPressed: () {
                              _deleteWorkout(doc.id);
                              Navigator.of(context). pop(); // Закрыть диалог и обновить UI
                            },
                            child: Text("Да"),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  
                  child: ListTile(
                    title: Text(data['title']),
                    subtitle: Text("${DateFormat('dd.MM.yyyy HH:mm').format(data['date'].toDate())} - Вместимость: ${data['capacity']}"),
                  ),
               
                ),
              );
            },
          );
        },
      ),
      ),
    );
  }
}
