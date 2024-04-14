import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainMenuScreen(),
    );
  }
}

class MainMenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: ListView(
        children: [
          _buildCategoriesSection(context),
          _buildPostsSection(context),
          
        ],
      ),
    );
  }

  Widget _buildCategoriesSection(BuildContext context) {
    // TODO: Реализация сетки с категориями
    
    return Container(
      height: 150,

      child: GridView.count(
      crossAxisCount: 3,
      childAspectRatio: 1.0,
      physics: NeverScrollableScrollPhysics(), // Отключаем прокрутку внутри GridView
      shrinkWrap: true, 
      children: <Widget>[
        _buildCategoryItem(context, 'Найти партнера', Icons.favorite),
        _buildCategoryItem(context, 'Найти тренера', Icons.search),
        _buildCategoryItem(context, 'Курсы', Icons.book),
        
      ],
      ),
    );
  }

  Widget _buildCategoryItem(BuildContext context, String title, IconData icon) {
    return Card(
      child: InkWell(
        onTap: () {
          // Действие при нажатии на категорию
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, size: 50),
            Text(title),
          ],
        ),
      ),
    );
  }

  Widget _buildPostsSection(BuildContext context) {
    // TODO: Реализация списка постов
    return Column(
      children: List.generate(10, (index) {
        return Card(
          child: ListTile(
            leading: Icon(Icons.person),
            title: Text('Пост #$index'),
            subtitle: Text('Описание поста...'),
          ),
        );
      
      }),
      
    );
  }
}
