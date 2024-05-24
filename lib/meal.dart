import 'package:cloud_firestore/cloud_firestore.dart';

class Meal {
  final String type;
  final int calories;
  final Timestamp timestamp;

  Meal({required this.type, required this.calories, required this.timestamp});

  // Метод для преобразования Meal в FoodItem
  FoodItem toFoodItem() {
    return FoodItem(
      name: type,
      proteins: 0, // Замените на реальные данные, если они у вас есть
      fats: 0, // Замените на реальные данные, если они у вас есть
      carbs: 0, // Замените на реальные данные, если они у вас есть
      servingSize: 0, // Замените на реальные данные, если они у вас есть
      calories: calories,
    );
  }

  // Метод для создания объекта Meal из документа Firestore
  factory Meal.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Meal(
      type: data['type'] ?? '',
      calories: data['calories'] ?? 0,
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'calories': calories,
      'timestamp': timestamp,
    };
  }
}

class FoodItem {
  final String name;
  final double proteins;
  final double fats;
  final double carbs;
  final int servingSize;
  final int calories;

  FoodItem({
    required this.name,
    required this.proteins,
    required this.fats,
    required this.carbs,
    required this.servingSize,
    required this.calories,
  });
}
