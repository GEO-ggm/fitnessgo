
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:fitnessgo/stat_screnn.dart';
import 'package:flutter/material.dart';
import 'add_food_screen.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}
class _ProfileScreenState extends State<ProfileScreen> {
  String _photoUrl = '';
  String _fullName = '';
  @override
  void initState() {
    super.initState();
    _loadUserProfile();
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
Widget build(BuildContext context) {
    return Scaffold(
     
      body: ListView(
        children: <Widget>[
          // Ваш профиль и кнопка редактировать
          _buildProfileSection(context),
          // Сводка информации о воде, шагах и весе
          _buildSummarySection(context),
          // Раздел "Моё питание"
          
          _buildNutritionSection(context),
          // TODO: Стена с постами
         
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
      SizedBox(height: 4), // небольшое пространство между текстами
      Text(value),
    ],
  );
}


  Widget _buildSummarySection(BuildContext context) {
   return InkWell(
    onTap: (){
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_)=>StatsScreen()),
      );
    
    },
   child: Container(
      padding: const EdgeInsets.all(13.0),
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:BorderRadius.circular(12),
        border: Border.all(
          color:  Color.fromARGB(255, 6, 98, 77), // Цвет границы
          width: 2.0, // Ширина границы
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
          
          _buildSummaryCard(context, 'assets/icons/steps.svg', 'Шаги', '10000'),
          
          _buildSummaryCard(context, 'assets/icons/weightloc.svg', 'Вес', '66 кг'),
        ],
      ),
    ),
   ),
   );
}
Widget _buildSummaryCard(BuildContext context, String iconPath, String title, String value) {
    // Карточка для отображения сводной информации
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
        padding: const EdgeInsets.symmetric(horizontal: 16.0), // Горизонтальный отступ
        child: Text(
          'Ваше питание',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w300),
        ),
      ),
      SizedBox(height: 16), // Добавляем немного пространства
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildMealCard(context, 'Завтрак', '500 ккал'),
          _buildMealCard(context, 'Обед', '650 ккал'),
          _buildMealCard(context, 'Ужин', '650 ккал'),
        ],
      ),
    ],
  );
}

Widget _buildMealCard(BuildContext context, String mealName, String calories) {
  return InkWell(
    onTap: () {
      // Навигация на FoodDetailsScreen
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
          color:  Color.fromARGB(255, 6, 98, 77), // Цвет границы
          width: 2.0, // Ширина границы
        ),
        
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2), // Цвет тени
            spreadRadius: 1,
            blurRadius: 10,// Размытие тени
            
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
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0), // Паддинг внутри карточки
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(mealName, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 4), // Пространство между названием приема пищи и калориями
            Text(calories, style: TextStyle(fontSize: 16)), // Текстовая заглушка для калорий
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


class _FoodDetailsScreenState extends State<FoodDetailsScreen> {
  MealInfo breakfastInfo = MealInfo();
  MealInfo lunchInfo = MealInfo();
  MealInfo dinnerInfo = MealInfo();
  // Переменные для хранения общих значений белков, жиров, углеводов и калорий
  double totalProteins = 0;
  double totalFats = 0;
  double totalCarbs = 0;
  int totalCalories = 0;

  // Предполагаем, что каждый продукт представлен моделью с соответствующими значениями
  // Это список продуктов, который вы будете динамически обновлять
  List<FoodItem> foodItems = [];
  @override
    void initState() {
      super.initState();
    // Здесь вы можете инициализировать данные для каждого приема пищи, если нужно
    }

  // Функция для обновления общих значений
  void _updateNutritionValues() {
    totalProteins = foodItems.fold(0, (sum, item) => sum + item.proteins);
    totalFats = foodItems.fold(0, (sum, item) => sum + item.fats);
    totalCarbs = foodItems.fold(0, (sum, item) => sum + item.carbs);
    totalCalories = foodItems.fold(0, (sum, item) => sum + item.calories);
  }
  


  @override
  Widget build(BuildContext context) {
    _updateNutritionValues();
    MealInfo currentMealInfo;
    switch (widget.mealName) {
      case 'Завтрак':
        currentMealInfo = breakfastInfo;
        break;
      case 'Обед':
        currentMealInfo = lunchInfo;
        break;
      case 'Ужин':
        currentMealInfo = dinnerInfo;
        break;
      default:
        currentMealInfo = MealInfo(); // На всякий случай, если mealName не совпадает
    }
    
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
          SizedBox(height: 80), // Предоставляет пространство для FloatingActionButton
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          // Открытие экрана добавления продукта
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
            minimumSize: Size(double.infinity, 50), // Устанавливаем минимальный размер кнопки
            
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
class MealSection extends StatelessWidget {
  final String mealName;
  final Function(int) onCaloriesUpdated;

  MealSection({
    required this.mealName,
    required this.onCaloriesUpdated,
  });

  // Предположим, что эта функция добавляет продукт и возвращает итоговое количество калорий
  void addProduct() {
    // Здесь должна быть логика добавления продукта и подсчета калорий
    int newCalories = 0; // Результат добавления продукта
    onCaloriesUpdated(newCalories);
  }

  @override
  Widget build(BuildContext context) {
    // Визуальное представление секции приема пищи
    return Column(
      children: [
        Text(mealName, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        // Кнопка добавления продукта
        IconButton(
          icon: Icon(Icons.add),
          onPressed: addProduct,
        ),
        // Список продуктов и их калорийность
        // ...
      ],
    );
  }
}







