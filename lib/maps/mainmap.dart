import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final List<MapObject> mapObjects = [];
  late YandexMapController _controller;
  String _selectedCenterName = '';
  String _selectedCenterAddress = '';
  String _selectedCenterLogo = '';
  double _selectedCenterLogoSize = 40;
  Point? _selectedLocation;

  final MapObjectId clusterizedPlacemarkCollectionId = const MapObjectId('clusterized_placemark_collection');

  @override
  void initState() {
    super.initState();
    _initializePlacemarks();
    
  }

  Future<Uint8List> _buildClusterAppearance(Cluster cluster) async {
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);
    const size = Size(200, 200);
    final fillPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final strokePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;
    const radius = 60.0;

    final textPainter = TextPainter(
      text: TextSpan(
        text: cluster.size.toString(),
        style: const TextStyle(color: Colors.black, fontSize: 50),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(minWidth: 0, maxWidth: size.width);

    final textOffset = Offset((size.width - textPainter.width) / 2, (size.height - textPainter.height) / 2);
    final circleOffset = Offset(size.height / 2, size.width / 2);

    canvas.drawCircle(circleOffset, radius, fillPaint);
    canvas.drawCircle(circleOffset, radius, strokePaint);
    textPainter.paint(canvas, textOffset);

    final image = await recorder.endRecording().toImage(size.width.toInt(), size.height.toInt());
    final pngBytes = await image.toByteData(format: ImageByteFormat.png);

    return pngBytes!.buffer.asUint8List();
  }

  void _initializePlacemarks() {
    final List<PlacemarkMapObject> placemarks = [];

    final List<Map<String, dynamic>> fitnessCenters = [
      {
        'name': 'DDX Fitness',
        'points': [
          {'point': Point(latitude: 55.755826, longitude: 37.617300), 'address': 'ул. Тверская, 1, Москва'},
          {'point': Point(latitude: 55.760186, longitude: 37.618080), 'address': 'ул. Малая Бронная, 1, Москва'},
          {'point': Point(latitude: 55.752776, longitude: 37.621588), 'address': 'ул. Арбат, 1, Москва'},
          {'point': Point(latitude: 55.758024, longitude: 37.619192), 'address': 'ул. Петровка, 1, Москва'},
          {'point': Point(latitude: 55.756268, longitude: 37.620492), 'address': 'ул. Неглинная, 1, Москва'},
          {'point': Point(latitude: 55.754861, longitude: 37.619047), 'address': 'ул. Кузнецкий Мост, 1, Москва'},
          {'point': Point(latitude: 55.757152, longitude: 37.623201), 'address': 'ул. Рождественка, 1, Москва'},
          {'point': Point(latitude: 55.759578, longitude: 37.616658), 'address': 'ул. Лубянка, 1, Москва'},
          {'point': Point(latitude: 55.751859, longitude: 37.622842), 'address': 'ул. Мясницкая, 1, Москва'},
          {'point': Point(latitude: 55.755100, longitude: 37.620010), 'address': 'ул. Варварка, 1, Москва'},
        ],
        'icon': 'assets/orange.png',
        'logo': 'assets/ddx_logo.png',
        'logoSize': 20.0
      },
      {
        'name': 'Spirit Fitness',
        'points': [
          {'point': Point(latitude: 55.762579, longitude: 37.624710), 'address': 'ул. Пятницкая, 1, Москва'},
          {'point': Point(latitude: 55.754839, longitude: 37.627418), 'address': 'ул. Большая Ордынка, 1, Москва'},
          {'point': Point(latitude: 55.757205, longitude: 37.629131), 'address': 'ул. Полянка, 1, Москва'},
          {'point': Point(latitude: 55.752320, longitude: 37.630723), 'address': 'ул. Сретенка, 1, Москва'},
          {'point': Point(latitude: 55.758795, longitude: 37.625998), 'address': 'ул. Садовая-Кудринская, 1, Москва'},
          {'point': Point(latitude: 55.753773, longitude: 37.628356), 'address': 'ул. Кузнецкий Мост, 1, Москва'},
          {'point': Point(latitude: 55.756431, longitude: 37.627065), 'address': 'ул. Никольская, 1, Москва'},
          {'point': Point(latitude: 55.759282, longitude: 37.624861), 'address': 'ул. Ильинка, 1, Москва'},
          {'point': Point(latitude: 55.755461, longitude: 37.626977), 'address': 'ул. Солянка, 1, Москва'},
          {'point': Point(latitude: 55.758514, longitude: 37.629948), 'address': 'ул. Маросейка, 1, Москва'},
        ],
        'icon': 'assets/green.png',
        'logo': 'assets/spirit_logo.png',
        'logoSize': 50.0,
      },
      {
        'name': 'World Class',
        'points': [
          {'point': Point(latitude: 55.765120, longitude: 37.630326), 'address': 'просп. Мира, 1, Москва'},
          {'point': Point(latitude: 55.753541, longitude: 37.630778), 'address': 'ул. Щепкина, 1, Москва'},
          {'point': Point(latitude: 55.756704, longitude: 37.631123), 'address': 'ул. Самотечная, 1, Москва'},
          {'point': Point(latitude: 55.758141, longitude: 37.632351), 'address': 'ул. Делегатская, 1, Москва'},
          {'point': Point(latitude: 55.755216, longitude: 37.632784), 'address': 'ул. Селезневская, 1, Москва'},
          {'point': Point(latitude: 55.757921, longitude: 37.631497), 'address': 'ул. Дурова, 1, Москва'},
          {'point': Point(latitude: 55.752763, longitude: 37.634105), 'address': 'ул. Олимпийский проспект, 1, Москва'},
          {'point': Point(latitude: 55.754292, longitude: 37.633208), 'address': 'ул. Большая Переяславская, 1, Москва'},
          {'point': Point(latitude: 55.755698, longitude: 37.633552), 'address': 'ул. Гиляровского, 1, Москва'},
          {'point': Point(latitude: 55.758680, longitude: 37.634841), 'address': 'ул. Мещанская, 1, Москва'},
        ],
        'icon': 'assets/red.png',
        'logo': 'assets/world_logo.png',
        'logoSize': 60.0,
      }
    ];

    for (var center in fitnessCenters) {
      for (var pointData in center['points']) {
        placemarks.add(
          PlacemarkMapObject(
            mapId: MapObjectId('${center['name']}_${pointData['point'].latitude}_${pointData['point'].longitude}'),
            point: pointData['point'],
            onTap: (PlacemarkMapObject self, Point point) {
              _showBottomSheet(center['name'], pointData['address'], center['logo'], center['logoSize'], point);
            },
            icon: PlacemarkIcon.single(
              PlacemarkIconStyle(
                image: BitmapDescriptor.fromAssetImage(center ['icon']),
                scale: 4.0,
              ),
            ),
          ),
        );
      }
    }

    final clusterizedPlacemarkCollection = ClusterizedPlacemarkCollection(
      mapId: clusterizedPlacemarkCollectionId,
      radius: 30,
      minZoom: 15,
      onClusterAdded: (ClusterizedPlacemarkCollection self, Cluster cluster) async {
        return cluster.copyWith(
          appearance: cluster.appearance.copyWith(
            icon: PlacemarkIcon.single(PlacemarkIconStyle(
              image: BitmapDescriptor.fromBytes(await _buildClusterAppearance(cluster)),
              scale: 1
            ))
          )
        );
      },
      onClusterTap: (ClusterizedPlacemarkCollection self, Cluster cluster) {
        print('Tapped cluster');
      },
      placemarks: placemarks,
      onTap: (ClusterizedPlacemarkCollection self, Point point) => print('Tapped me at $point'),
    );

    setState(() {
      mapObjects.add(clusterizedPlacemarkCollection);
    });
  }

void _showBottomSheet(String centerName, String address, String logo, double logoSize, Point location) {
  setState(() {
    _selectedCenterName = centerName;
    _selectedCenterAddress = address;
    _selectedCenterLogo = logo;
    _selectedCenterLogoSize = logoSize;
    _selectedLocation = location; // Save the location of the selected center
  });
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      var theme = Theme.of(context);
    var textColor = theme.brightness == Brightness.dark ? Colors.white : Colors.black;
    var backgroundColor = theme.brightness == Brightness.dark ? Colors.black : Colors.white;
      
      return Padding(
        padding: const EdgeInsets.only(bottom: 0),
        child: SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.25,
            color: backgroundColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      _selectedCenterLogo,
                      height: _selectedCenterLogoSize,
                    ),
                    SizedBox(width: 10),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  _selectedCenterName,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,color: textColor ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  _selectedCenterAddress,
                  style: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.w200, color: textColor),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, {'name': _selectedCenterName, 'address': _selectedCenterAddress, 'logo': _selectedCenterLogo, 'location': _selectedLocation});
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Клуб выбран: $_selectedCenterName'), backgroundColor: backgroundColor,),
                    );
                  },
                  child: Text('Выбрать клуб'),
                ),
              ],
            ),
          ),
        ),
      );
    },
  ).then((value) {
    if (value != null) {
      Navigator.pop(context, value); // Возвращаем данные на предыдущий экран
    }
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Выберите клуб'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            
            child: YandexMap(
              mapObjects: mapObjects,
              onMapCreated: (YandexMapController yandexMapController) async {
                _controller = yandexMapController;
                const MapAnimation(duration: 0.0);
                // Переместить камеру на Москву после инициализации карты
                 _controller.moveCamera(
                  CameraUpdate.newCameraPosition(
                    const CameraPosition(
                      target: Point(latitude: 55.751244, longitude: 37.618423),
                      zoom: 10,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
