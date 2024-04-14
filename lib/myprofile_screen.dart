
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Профиль',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  @override
Widget build(BuildContext context) {
    return Scaffold(
     
      body: ListView(
        children: <Widget>[
          // Ваш профиль и кнопка редактировать
          _buildProfileSection(context),
          // Сводка информации о воде, шагах и весе
          _buildSummarySection(),
          // Раздел "Моё питание"
          
          _buildNutritionSection(context),
          // TODO: Стена с постами
         
        ],
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context) {
    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 50,
          backgroundImage: NetworkImage('URL изображения профиля'),
        ),
        Text('Иван Иванов', style: TextStyle(fontSize: 24)),
        Text('@ivanddx', style: TextStyle(color: Colors.grey)),
        ElevatedButton(
          child: Text('Редактировать'),
          onPressed: () {
            // Обработчик нажатия кнопки Редактировать
          },
        ),
        Divider(),
      ],
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


  Widget _buildSummarySection() {
  return Container(
    padding: const EdgeInsets.all(16.0),
    margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
    decoration: BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(10.0),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          spreadRadius: 1,
          blurRadius: 3,
          offset: Offset(0, 3),
        ),
      ],
    ),
    // Тут должен быть просто вызов Row, а не вызов _buildSummaryItem
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _buildSummaryItem('Вода', '2 л'),
        _buildSummaryItem('Шаги', '10000'),
        _buildSummaryItem('Вес', '70 кг'),
      ],
    ),
  );
}

  Widget _buildNutritionSection(BuildContext context,) {
    return Column(
      children: <Widget>[
        Text('Моё питание', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _buildMealCard(context, 'Завтрак', "assets/foods/food3.png"),
            _buildMealCard(context,'Обед', "assets/foods/food2.png"),
            _buildMealCard(context,'Ужин', "assets/foods/food1.png"),
          ],
        ),
      ],
    );
  }

  Widget _buildMealCard(BuildContext context, String mealName, AssetImage) {
    return InkWell(
      onTap: () {
        // Здесь вы добавляете логику навигации на экран, где пользователь может ввести информацию о питании
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FoodDetailsScreen(mealName: mealName)),
        );
      },
    
    child: Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              width: 80,
              height: 80,
            child: Image.asset(AssetImage), ),
            Text(mealName),
          ],
        ),
      ),
    )
    );
    
  }
    
  
}
class FoodDetailsScreen extends StatelessWidget {
  final String mealName;

  FoodDetailsScreen({required this.mealName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(mealName),
      ),
      body: Center(
        // Здесь будет форма для ввода информации о том, что пользователь съел
        child: Text('Здесь вы можете ввести информацию о вашем приеме пищи.'),
      ),
    );
  }
}
