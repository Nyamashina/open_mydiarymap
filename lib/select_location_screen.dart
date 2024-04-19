import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'select_location_screen.dart'; // あなたのSelectLocationScreenクラスのインポート

Future<Map<String, dynamic>?> selectLocation(BuildContext context) async {
  final selectedLocation = await Navigator.of(context).push<LatLng>(
    MaterialPageRoute(
      builder: (context) => SelectLocationScreen(),
    ),
  );

  if (selectedLocation != null) {
    // 地名を取得
    List<Placemark> placemarks = await placemarkFromCoordinates(
      selectedLocation.latitude,
      selectedLocation.longitude,
    );
    String place = placemarks[0].name ?? '不明な場所';

    // 選んだ座標と地名をトーストで表示
    Fluttertoast.showToast(
      msg: "選んだ座標：${selectedLocation.latitude}, ${selectedLocation.longitude},場所：$place",
      toastLength: Toast.LENGTH_LONG,
    );

    // 緯度経度と地名をMapで返す
    return {
      "latitude": selectedLocation.latitude,
      "longitude": selectedLocation.longitude,
      "place": place,
    };
  }

  return null;
}




class SelectLocationScreen extends StatefulWidget {
  @override
  _SelectLocationScreenState createState() => _SelectLocationScreenState();
}

class _SelectLocationScreenState extends State<SelectLocationScreen> {
  LatLng? _pickedLocation;
  final Set<Marker> _markers = {};
  String _appBarTitle = '位置を選択';

  void _pickLocation(LatLng position) {
    setState(() {
      _pickedLocation = position;
      _markers.clear();
      _markers.add(
        Marker(markerId: const MarkerId('pickedLocation'), position:position)
      );
      _appBarTitle = '選択した場所：${position.latitude.toStringAsFixed(4)},${position.longitude.toStringAsFixed(4)}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_appBarTitle),
        actions: <Widget>[
          if (_pickedLocation != null)
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: () => Navigator.of(context).pop(_pickedLocation),
            ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(35.6895, 139.6917), // 初期位置を東京に設定
          zoom: 12,
        ),
        markers: _markers,
        onTap: _pickLocation,
      ),
    );
  }
}