import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';



import 'api_keys.dart';  // Импортируем файл с ключом

class TrainDetailCheck extends StatelessWidget {

  final String trainingId;
  late final List<MapObject> mapObjects = [
    startPlacemark,
    stopByPlacemark,
    endPlacemark
  ];
  final PlacemarkMapObject startPlacemark = PlacemarkMapObject(
    mapId: const MapObjectId('start_placemark'),
    point: const Point(latitude: 55.7558, longitude: 37.6173),
    icon: PlacemarkIcon.single(
      PlacemarkIconStyle(image: BitmapDescriptor.fromAssetImage('lib/assets/route_start.png'))
    ),
  );
  final PlacemarkMapObject stopByPlacemark = PlacemarkMapObject(
    mapId: const MapObjectId('stop_by_placemark'),
    point: const Point(latitude: 55.755173, longitude: 37.619097),
    icon: PlacemarkIcon.single(
      PlacemarkIconStyle(image: BitmapDescriptor.fromAssetImage('lib/assets/route_stop_by.png'))
    ),
  );
  final PlacemarkMapObject endPlacemark = PlacemarkMapObject(
    mapId: const MapObjectId('end_placemark'),
    point: const Point(latitude: 55.7558, longitude: 37.62),
    icon: PlacemarkIcon.single(
      PlacemarkIconStyle(image: BitmapDescriptor.fromAssetImage('lib/assets/route_end.png'))
    )
  );

  TrainDetailCheck({required this.trainingId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Training Details'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Trainings')
            .doc(trainingId)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('No data found for this training'));
          }

          var trainingData = snapshot.data!.data() as Map<String, dynamic>;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Title',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    trainingData['title'],
                    style: TextStyle(fontSize: 20.0),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    trainingData['description'],
                    style: TextStyle(fontSize: 16.0),
                  ),
                  SizedBox(height: 16.0),
                  Container(
                    height: 300.0, // Задаем высоту для карты
                    child: YandexMap(
                      mapType: MapType.vector,
                              onMapCreated: (YandexMapController yandexMapController) async {
                        final geometry = Geometry.fromBoundingBox(BoundingBox(
                        northEast: startPlacemark.point,
                        southWest: endPlacemark.point
                      ));
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

void main() async {
  
  
  runApp(MaterialApp(
    home: TrainDetailCheck(trainingId: 'exampleTrainingId'),
  ));
}

