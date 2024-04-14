import 'package:flutter/material.dart';

class TrainingsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> trainings = [
    {
      'title': 'Трицепс',
      'date': 'ПН, 31.01',
      'isSignedUp': true,
    },
    {
      'title': 'Бицепс',
      'date': 'ВТ, 10.02',
      'isSignedUp': true,
    },
    {
      'title': 'Кардио',
      'date': 'СР, 15.02',
      'isSignedUp': false,
    },
    // Добавьте больше тренировок по аналогии
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Тренировки'),
      ),
      body: ListView.builder(
        itemCount: trainings.length,
        itemBuilder: (context, index) {
          final training = trainings[index];
          return Card(
            child: ListTile(
              title: Text(training['title']),
              subtitle: Text(training['date']),
              trailing: ElevatedButton(
                onPressed: () {
                  // Здесь логика для записи или отмены тренировки
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    training['isSignedUp'] ? Colors.green : Colors.red,
                  ),
                ),
                child: Text(training['isSignedUp'] ? 'Записаться' : 'Отменить'),
              ),
            ),
          );
        },
      ),
    );
  }
}
