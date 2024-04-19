import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'diary_entries_provider.dart';
import 'diary_entry.dart';
import 'diary_detail_page.dart';
import 'global_events.dart';

class DiaryMap extends ConsumerStatefulWidget {
  @override
  ConsumerState<DiaryMap> createState() => _DiaryMapState();
}

class _DiaryMapState extends ConsumerState<DiaryMap> {
  Set<Marker> _markers = {};
  LatLng initialPosition = const LatLng(35.6895, 139.6917);
  BitmapDescriptor? customIcon;

  @override
  void initState() {
    super.initState();
    _loadCustomMarker();
    _loadEntries();
    GlobalEvents.notifier.addListener(_handleGlobalEvents);
  }

  Future<void> _loadCustomMarker() async {
    customIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(devicePixelRatio: 2.5),
      'assets/icon.png'
    );
  }

  void _loadEntries() async {
    await ref.read(diaryEntryListProvider.notifier).loadEntries();
    List<DiaryEntry> entries = ref.read(diaryEntryListProvider);
    _updateMarkers(entries);
  }

  void _updateMarkers(List<DiaryEntry> entries) {
    setState(() {
      _markers = entries.map((entry) {
        return Marker(
          markerId: MarkerId(entry.id.toString()),
          position: LatLng(entry.latitude, entry.longitude),
          icon: customIcon ?? BitmapDescriptor.defaultMarker,
          infoWindow: InfoWindow(
            title: entry.title,
            snippet: entry.date,
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => DiaryDetailPage(diaryEntry: entry),
              ));
            },
          ),
        );
      }).toSet();
      if (entries.isNotEmpty) {
        initialPosition = LatLng(entries.first.latitude, entries.first.longitude);
      }
    });
  }

  void _handleGlobalEvents() {
    if (GlobalEvents.notifier.value) {
      _loadEntries();
      GlobalEvents.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("日々の思い出を地図に残していきましょう"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadEntries,
          ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: initialPosition,
          zoom: 12,
        ),
        markers: _markers,
      ),
    );
  }

  @override
  void dispose() {
    GlobalEvents.notifier.removeListener(_handleGlobalEvents);
    super.dispose();
  }
}
