import 'package:fitnessgo/createpost_screen.dart';
import 'package:fitnessgo/view_courses_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MainMenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Главная'),
        actions: [
          IconButton(
            icon: Icon(Icons.create),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreatePostScreen()),
              );
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          _buildCategoriesSection(context),
          _buildHashtagFilter(context),
          _buildPostsSection(context),
        ],
      ),
    );
  }

  Widget _buildCategoriesSection(BuildContext context) {
    return Container(
      height: 150,
      child: GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 1.0,
        physics: NeverScrollableScrollPhysics(),
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
          if (title == 'Курсы') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CoursesScreen()),
            );
          }
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

  Widget _buildHashtagFilter(BuildContext context) {
    List<String> hashtags = ['#отзыв', '#рецепт', '#занятие', '#курс'];
    return Container(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: hashtags.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: FilterChip(
              label: Text(hashtags[index]),
              onSelected: (bool selected) {
                // Фильтрация постов по выбранному хештегу
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildPostsSection(BuildContext context) {
    // TODO: Реализация списка постов
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('MainBoard').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        var posts = snapshot.data!.docs;
        return Column(
          children: List.generate(posts.length, (index) {
            var post = posts[index];
            return Card(
              child: ListTile(
                leading: Icon(Icons.person),
                title: Text(post['title']),
                subtitle: Text(post['content']),
              ),
            );
          }),
        );
      },
    );
  }
}
