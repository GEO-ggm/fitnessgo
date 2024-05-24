import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'create_course_screen.dart';
import 'trainer_profile_form_screen.dart';
import 'requests_screen.dart';

class TrainerProfileScreen extends StatefulWidget {
  @override
  _TrainerProfileScreenState createState() => _TrainerProfileScreenState();
}

class _TrainerProfileScreenState extends State<TrainerProfileScreen> {
  String _photoUrl = '';
  String _fullName = '';
  int _courseCount = 0;
  double _rating = 0.0;
  int _trainingCount = 0;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    _loadTrainerData();
  }

  Future<void> _loadUserProfile() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('Users').doc(userId).get();

      if (userDoc.exists) {
        setState(() {
          _photoUrl = userDoc['photoURL'] ?? '';
          _fullName = "${userDoc['name'] ?? ''} ${userDoc['surname'] ?? ''}";
        });
      }
    } catch (e) {
      print('Error loading user profile: $e');
    }
  }

  Future<void> _loadTrainerData() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot trainerDoc = await FirebaseFirestore.instance.collection('Trainers').doc(userId).get();

      if (trainerDoc.exists) {
        setState(() {
          _courseCount = trainerDoc['courseCount'] ?? 0;
          _rating = trainerDoc['rating']?.toDouble() ?? 0.0;
          _trainingCount = trainerDoc['trainingCount'] ?? 0;
        });
      }
    } catch (e) {
      print('Error loading trainer data: $e');
    }
  }

  void _incrementTrainingCount() {
    setState(() {
      _trainingCount++;
    });

    String userId = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance.collection('Trainers').doc(userId).update({
      'trainingCount': _trainingCount,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: <Widget>[
          _buildProfileSection(),
          _buildTrainerStats(),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          CircleAvatar(
            radius: 50,
            backgroundImage: _photoUrl.isNotEmpty ? NetworkImage(_photoUrl) : null,
            child: _photoUrl.isEmpty ? Icon(Icons.camera_alt, size: 50) : null,
          ),
          SizedBox(width: 20),
          Text(
            _fullName,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildTrainerStats() {
    return Container(
      padding: EdgeInsets.all(16.0),
      margin: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Color.fromARGB(255, 6, 98, 77),
          width: 2.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          _buildStatRow('Курсы', _courseCount.toString()),
          _buildStatRow('Рейтинг', _rating.toString()),
          _buildStatRow('Тренировки', _trainingCount.toString(), isIncrementable: true),
        ],
      ),
    );
  }

  Widget _buildStatRow(String title, String value, {bool isIncrementable = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(title, style: TextStyle(fontSize: 18)),
          Row(
            children: <Widget>[
              Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              if (isIncrementable)
                IconButton(
                  icon: Icon(Icons.add_circle, color: Colors.green),
                  onPressed: _incrementTrainingCount,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TrainerProfileFormScreen()),
            );
          },
          child: Text('Анкета тренера'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CreateCourseScreen()),
            );
          },
          child: Text('Создать курс'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RequestsScreen()),
            );
          },
          child: Text('Запросы'),
        ),
      ],
    );
  }
}
