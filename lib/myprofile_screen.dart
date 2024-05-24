// ignore_for_file: unused_import

import 'package:fitnessgo/stat_screnn.dart';
import 'package:flutter/material.dart';
import 'add_food_screen.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'meal_service.dart';
import 'meal.dart';

// Определим класс MealInfo
class MealInfo {
  double proteins;
  double fats;
  double carbs;
  int calories;

  MealInfo({
    this.proteins = 0.0,
    this.fats = 0.0,
    this.carbs = 0.0,
    this.calories = 0,
  });

  void addFoodItem(FoodItem item) {
    proteins += item.proteins;
    fats += item.fats;
    carbs += item.carbs;
    calories += item.calories;
  }

  void reset() {
    proteins = 0.0;
    fats = 0.0;
    carbs = 0.0;
    calories = 0;
  }
}

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _photoUrl = '';
  String _fullName = '';
  late Stream<StepCount> _stepCountStream;
  String _steps = '0';
  Timer? _timer;
  int totalCalories = 0;
  int breakfastCalories = 0;
  int lunchCalories = 0;
  int dinnerCalories = 0;

  final MealService mealService = MealService();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    initPlatformState();
    requestActivityRecognitionPermission();
    mealService.deleteOldMeals();
    mealService.getMeals().listen((meals) {
      setState(() {
        totalCalories = 0;
        breakfastCalories = 0;
        lunchCalories = 0;
        dinnerCalories = 0;

        for (Meal meal in meals) {
          if (meal.timestamp.toDate().day == DateTime.now().day) {
            totalCalories += meal.calories;
            if (meal.type == "breakfast") {
              breakfastCalories += meal.calories;
            } else if (meal.type == "lunch") {
              lunchCalories += meal.calories;
            } else if (meal.type == "dinner") {
              dinnerCalories += meal.calories;
            }
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Отменяем таймер при уничтожении виджета
    super.dispose();
  }

  Future<void> requestActivityRecognitionPermission() async {
    if (await Permission.activityRecognition.request().isGranted) {
      initPlatformState();
    } else {
      print("Permission denied");
    }
  }

  Future<void> _loadUserProfile() async {
    try {
      // Предположим, что пользователь уже аутентифицирован
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Получение документа пользователя из Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('Users').doc(userId).get();

      if (userDoc.exists) {
        setState(() {
          // Используйте название полей как в вашей базе данных
          _photoUrl = userDoc['photoURL'] ?? '';
          _fullName = "${userDoc['name'] ?? ''} ${userDoc['surname'] ?? ''}";
        });
      }
    } catch (e) {
      print('Error loading user profile: $e');
      // Отобразить сообщение об ошибке, если требуется
    }
  }

  void onStepCount(StepCount event) {
    setState(() {
      _steps = event.steps.toString();
    });
  }

  void onStepCountError(error) {
    print('Step Count Error: $error');
  }

  void initPlatformState() {
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          _buildProfileSection(context),
          _buildSummarySection(context),
          _buildNutritionSection(context),
        ],
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 38, bottom: 24, left: 16, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CircleAvatar(
            radius: 35,
            backgroundImage: _photoUrl.isNotEmpty ? NetworkImage(_photoUrl) : null,
            child: _photoUrl.isEmpty ? Icon(Icons.camera_alt, size: 50) : null,
          ),
          Text(_fullName, style: TextStyle(fontSize: 24)),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String title, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 4),
        Text(value),
      ],
    );
  }

  Widget _buildSummarySection(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => StatsScreen()),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(13.0),
        margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
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
        child: IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              _buildSummaryCard(context, 'assets/icons/water.svg', 'Вода', '2 L'),
              _buildSummaryCard(context, 'assets/icons/steps.svg', 'Шаги', _steps),
              _buildSummaryCard(context, 'assets/icons/weightloc.svg', 'Вес', '66 кг'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context, String iconPath, String title, String value) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SvgPicture.asset(iconPath, width: 30, height: 30),
          SizedBox(height: 8),
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          Text(value, style: Theme.of(context).textTheme.titleSmall),
        ],
      ),
    );
  }

  Widget _buildNutritionSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Ваше питание',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w300),
          ),
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildMealCard(context, 'Завтрак', '$breakfastCalories ккал'),
            _buildMealCard(context, 'Обед', '$lunchCalories ккал'),
            _buildMealCard(context, 'Ужин', '$dinnerCalories ккал'),
          ],
        ),
      ],
    );
  }

  Widget _buildMealCard(BuildContext context, String mealName, String calories) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FoodDetailsScreen(mealName: mealName)),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(2.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: Color.fromARGB(255, 6, 98, 77),
            width: 2.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 10,
            ),
          ],
        ),
        child: Card(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(mealName, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text(calories, style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FoodDetailsScreen extends StatefulWidget {
  final String mealName;

  FoodDetailsScreen({required this.mealName});

  @override
  _FoodDetailsScreenState createState() => _FoodDetailsScreenState();
}

class _FoodDetailsScreenState extends State<FoodDetailsScreen> {
  MealInfo currentMealInfo = MealInfo();
  final MealService mealService = MealService();
  double totalProteins = 0;
  double totalFats = 0;
  double totalCarbs = 0;
  int totalCalories = 0;
  List<FoodItem> foodItems = [];

  @override
  void initState() {
    super.initState();
    mealService.getMeals().listen((meals) {
      setState(() {
        // Преобразуем объекты Meal в объекты FoodItem
        
        _updateNutritionValues();
      });
    });
  }

  void _updateNutritionValues() {
    totalProteins = foodItems.fold(0, (sum, item) => sum + item.proteins);
    totalFats = foodItems.fold(0, (sum, item) => sum + item.fats);
    totalCarbs = foodItems.fold(0, (sum, item) => sum + item.carbs);
    totalCalories = foodItems.fold(0, (sum, item) => sum + item.calories);
  }

  @override
  Widget build(BuildContext context) {
    _updateNutritionValues();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.mealName),
      ),
      body: Column(
        children: <Widget>[
          _buildNutritionInfoRow(currentMealInfo),
          Expanded(
            child: ListView.builder(
              itemCount: foodItems.length,
              itemBuilder: (context, index) {
                return _buildNutritionItemCard(
                  foodItems[index].name,
                  '${foodItems[index].proteins.toStringAsFixed(1)}г',
                  '${foodItems[index].fats.toStringAsFixed(1)}г',
                  '${foodItems[index].carbs.toStringAsFixed(1)}г',
                  '${foodItems[index].servingSize}г',
                  '${foodItems[index].calories} ккал',
                );
              },
            ),
          ),
          SizedBox(height: 80),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddFoodScreen(mealType: widget.mealName),
            ),
          );
          if (result != null && result is FoodItem) {
            setState(() {
              foodItems.add(result);
              currentMealInfo.addFoodItem(result);
              _updateNutritionValues();

              // Добавляем новый прием пищи в базу данных
              
            });
          }
        },
        label: Text('Добавить продукт'),
        icon: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: BottomAppBar(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: Size(double.infinity, 50),
          ),
          onPressed: () {
            // TODO: Добавить логику сохранения питания
          },
          child: Text('Сохранить', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  Widget _buildNutritionInfoRow(MealInfo mealInfo) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildNutrientColumn('Белки', '${mealInfo.proteins.toStringAsFixed(1)}г'),
          _buildNutrientColumn('Жиры', '${mealInfo.fats.toStringAsFixed(1)}г'),
          _buildNutrientColumn('Углеводы', '${mealInfo.carbs.toStringAsFixed(1)}г'),
          _buildNutrientColumn('Ккал', '${mealInfo.calories}'),
        ],
      ),
    );
  }

  Widget _buildNutrientColumn(String nutrient, String value) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(nutrient, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }

  Card _buildNutritionInfoCard(String nutrient, String value) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ListTile(
        title: Text(nutrient),
        trailing: Text(value),
      ),
    );
  }

  Card _buildNutritionItemCard(String name, String proteins, String fats, String carbs, String serving, String calories) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(name),
            Text(proteins),
            Text(fats),
            Text(carbs),
            Text(serving),
            Text(calories),
          ],
        ),
      ),
    );
  }
}

class FoodItem {
  String name;
  double proteins;
  double fats;
  double carbs;
  int servingSize;
  int calories;

  FoodItem({
    required this.name,
    required this.proteins,
    required this.fats,
    required this.carbs,
    required this.servingSize,
    required this.calories,
  });
}
