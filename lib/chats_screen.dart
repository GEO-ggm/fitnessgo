import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      
        
       
            
       
      body: Column(
        children: [
          Container(
            height: 100,
            // Этот контейнер для горизонтального списка 
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: List.generate(10, (index) => Padding(
                padding: EdgeInsets.all(8),
                child: CircleAvatar(
                  // Добавьте правильные пути к изображениям или используйте сетевые изображения
                  backgroundImage: AssetImage('assets/example/123.jpeg'),
                  radius: 30,
                ),
              )),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 20,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: CircleAvatar(
                    // Добавьте правильные пути к изображениям или используйте сетевые изображения
                    backgroundImage: AssetImage('assets/example/123.jpeg'),
                  ),
                  title: Text('Имя пользователя'),
                  subtitle: Text('Последнее сообщение'),
                  trailing: Text('12:01'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
