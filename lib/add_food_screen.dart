import 'package:flutter/material.dart';
import 'myprofile_screen.dart';

class AddFoodScreen extends StatefulWidget {
  final String mealType;

  AddFoodScreen({required this.mealType});

  @override
  _AddFoodScreenState createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  final _formKey = GlobalKey<FormState>();
  String foodName = '';
  double foodWeight = 0;
  int foodCalories = 0;
  double foodProteins = 0;
  double foodFats = 0;
  double foodCarbs = 0;

  void saveFoodItem() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newFoodItem = FoodItem(
      name: foodName,
      proteins: foodProteins,
      fats: foodFats,
      carbs: foodCarbs,
      servingSize: foodWeight.toInt(),
      calories: foodCalories,
    );
     Navigator.pop(context, newFoodItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Новый продукт или блюдо'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Название'),
                onSaved: (value) => foodName = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Количество/вес'),
                keyboardType: TextInputType.number,
                onSaved: (value) => foodWeight = double.parse(value!),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Калорийность'),
                keyboardType: TextInputType.number,
                onSaved: (value) => foodCalories = int.parse(value!),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Белки'),
                keyboardType: TextInputType.number,
                onSaved: (value) => foodProteins = double.parse(value!),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Жиры'),
                keyboardType: TextInputType.number,
                onSaved: (value) => foodFats = double.parse(value!),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Углеводы'),
                keyboardType: TextInputType.number,
                onSaved: (value) => foodCarbs = double.parse(value!),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('Сохранить'),
                onPressed: saveFoodItem,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // background
                  foregroundColor: Colors.white, // foreground
                ),
              ),
              ElevatedButton(
                child: Text('Удалить'),
                onPressed: () {
                  // Здесь код для удаления продукта
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // background
                  foregroundColor: Colors.white, // foreground
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
