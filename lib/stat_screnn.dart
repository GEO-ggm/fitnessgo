// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StatsScreen extends StatefulWidget {
  @override
  _StatsScreenState createState() => _StatsScreenState();
 } 
 
 class _StatsScreenState extends State<StatsScreen> {
  double _latestWeight = 0; // Последнее значение веса

  // Метод для обновления веса
  void _updateLatestWeight(double weight) {
    setState(() {
      _latestWeight = weight;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ваш прогресс'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.monitor_weight, size: 35, color: Colors.green),
                  SizedBox(width: 8),
                  Text('Вес:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  SizedBox(width: 8),
                  Text('${_latestWeight.toStringAsFixed(0)} кг',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ), // Отображение веса
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom:40),
              child: 
                  LineChartSample(onWeightUpdated: _updateLatestWeight),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.local_activity, size: 35, color: Colors.green),
                  SizedBox(width: 8),
                  Text('Активность',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ],
              ),
            ),
            BarChartSample(),
            // Разместите ваш виджет с весом здесь
            
            
          ],
        ),  
      ),
    );   
  }
}
class LineChartSample extends StatefulWidget {
  final Function(double) onWeightUpdated;
  LineChartSample({required this.onWeightUpdated});

  @override
  _LineChartSampleState createState() => _LineChartSampleState();
}
class _LineChartSampleState extends State<LineChartSample> {
  final List<WeightData> weightData = [
   WeightData(date: DateTime.now(), weight: 70.0, x: 0 ),
  ]; // Список данных о весе пуст изначально

  void _addWeightData(DateTime date, double weight) {
    final double xValue = weightData.length.toDouble(); // Используем размер списка как индекс
    setState(() {
      final double xValue = weightData.length.toDouble();
      weightData.add(WeightData(date: date, weight: weight, x: xValue));
    });
  }
  
  Widget build(BuildContext context) {
    
    return Column(
      
      children: [ 
        SizedBox(height: 30),
        Container(
          height: 200.0, // Задайте фиксированную высоту
          width: 370,
          child: LineChart(
      
      LineChartData(
        
        gridData: FlGridData(show: false), // Отключить сетку
        borderData: FlBorderData(show: false), // Отключить границу
        lineBarsData: [
          LineChartBarData(
              spots: weightData.isNotEmpty
              ? weightData
              .asMap()
              .entries  
              .map((e) => FlSpot(
                e.key.toDouble(), // X - индекс в списке
                e.value.weight, // Y - вес
              ))
            .toList()
            : [FlSpot(0, 0)], // Пустая точка, если данных нет
            isCurved: true,
            color: Color.fromARGB(255, 6, 98, 77),
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(show: true), // метки (точки) 
          ),
          
        ],

        titlesData: FlTitlesData(
          
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  // Находим индекс, где значение X точки совпадает с текущим значением оси X
                  var indexOfSpot = weightData.indexWhere((spot) => spot.x == value);
                  
                  // Если точка с таким индексом существует, отображаем дату
                  if (indexOfSpot != -1) {
                    final date = weightData[indexOfSpot].date;
                    return Padding(
                      padding: const EdgeInsets.all(2),
                      child: Text(DateFormat.MMMd().format(date)), // Формат "Мар 28"
                    );
                  } else {
                    return SizedBox.shrink(); // Если точки с таким значением X нет, не показываем дату
                  }
                },
              ),
            ),
            rightTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
            ), 
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
            ), 
          ),
          ),
        ),
      ),
      
        ),
        
        Padding(
          
          padding: EdgeInsets.all(30),
          child: Row(
            children: [
              
              Expanded(
                child: TextFormField(
                  // Текстовое поле для ввода веса
                  decoration: InputDecoration(labelText: 'Ваш вес'),
                  keyboardType: TextInputType.number,
                  onFieldSubmitted: (value) {
                    final weight = double.tryParse(value);
                    
                    if (weight != null) {
                       setState(() {}); //данные в базу
                       widget.onWeightUpdated(weight);
                      _addWeightData(DateTime.now(), weight);
                     
                    }
                  },
          ),
          ),
          ],
          ),
        ),
      ],
    );
  }
}
class WeightData {
  final DateTime date;
  final double weight;
  final double x; // значение X для графика

  WeightData({required this.date, required this.weight, required this.x});
}

class BarChartSample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200.0,
    child: BarChart(
      BarChartData(
        gridData: const FlGridData(show: false), //Cетка
        alignment: BarChartAlignment.spaceAround,
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
          tooltipPadding: EdgeInsets.all(8),
          tooltipMargin: 5,
        ),
        ),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              getTitlesWidget: getTitles,
              showTitles: true,// Отключить названия
              reservedSize: 38,
            ),
           ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(
            showTitles: false,
            ),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
            ), 
          ),
         ), 
        borderData: FlBorderData(show: false, border: Border.all(color: Colors.blueGrey)), // Отключить границу
        barGroups: [
          
          BarChartGroupData(
            x: 0,
            
            //barRods: [
            //  BarChartRodData( toY: 30, color: Color.fromARGB(255, 6, 98, 77), width: 20, borderRadius: BorderRadius.all(Radius.circular(2))),
           // ],
            showingTooltipIndicators: [1],
          ),
          BarChartGroupData(
            x: 1,
            barRods: [
              BarChartRodData(toY: 440, color:  Color.fromARGB(255, 6, 98, 77), width: 20, borderRadius: BorderRadius.all(Radius.circular(2))),
            ],
            showingTooltipIndicators: [1],
          ),
          BarChartGroupData(
            x: 2,
            barRods: [
              BarChartRodData(toY: 330, color:  Color.fromARGB(255, 6, 98, 77), width: 20, borderRadius: BorderRadius.all(Radius.circular(2))),
            ],
            showingTooltipIndicators: [1],
          ),
          BarChartGroupData(
            x: 3,
            barRods: [
              BarChartRodData(toY: 213, color:  Color.fromARGB(255, 6, 98, 77), width: 20, borderRadius: BorderRadius.all(Radius.circular(2))),
            ],
            showingTooltipIndicators: [1],
          ),
          BarChartGroupData(
            x: 4,
            barRods: [
              BarChartRodData(toY: 193, color:  Color.fromARGB(255, 6, 98, 77), width: 20, borderRadius: BorderRadius.all(Radius.circular(2))),
            ],
            showingTooltipIndicators: [1],
          ),
          BarChartGroupData(
            x: 5,
            barRods: [
              BarChartRodData(toY: 10, color:  Color.fromARGB(255, 6, 98, 77), width: 20, borderRadius: BorderRadius.all(Radius.circular(2))),
            ],
            showingTooltipIndicators: [1],
          ),
          BarChartGroupData(
            x: 6,
            barRods: [
              BarChartRodData(toY: 10, color:  Color.fromARGB(255, 6, 98, 77), width: 20, borderRadius: BorderRadius.all(Radius.circular(2))),
            ],
            showingTooltipIndicators: [1],
          ),
          // Добавьте больше BarChartGroupData для других столбцов
        ],
      ),
    ),
    
    );
    
  }
  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.blue,
      fontWeight: FontWeight.w300,
      fontSize: 14,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('Пн',style: style, );
        break;
      case 1:
        text = const Text('Вт',style: style, );
        break;
      case 2:
        text = const Text('Ср',style: style, );
        break;
      case 3:
        text = const Text('Чт',style: style, );
        break;
      case 4:
        text = const Text('Пт', style: style,);
        break;
      case 5:
        text = const Text('Сб',style: style, );
        break;
      case 6:
        text = const Text('Вс', style: style, );
        break;
      default:
        text = const Text('', style: style,);
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: text,
    );
  }
  
}

