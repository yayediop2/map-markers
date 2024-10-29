// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:map/models/place.dart';

class MapScreen extends StatefulWidget {
  final List<Place> places;
  final Function(Place) onPlaceAdded;

  const MapScreen({super.key,required this.places, required this.onPlaceAdded});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _controller;
  Set<Marker> _markers = {};
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _updateMarkers();
  }

  void _updateMarkers() {
    setState(() {
      _markers = widget.places.map((place) {
        return Marker(
          markerId: MarkerId(place.id),
          position: place.location,
          infoWindow: InfoWindow(title: place.name),
          onTap: () => _showPlaceDialog(place),
        );
      }).toSet();
    });
  }

  Future<void> _getCurrentLocation() async {
    final permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) return;

    final position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = position;
      if (_controller != null) {
        _controller!.animateCamera(
          CameraUpdate.newLatLng(
            LatLng(position.latitude, position.longitude),
          ),
        );
      }
    });
  }

  void _showPlaceDialog(Place place) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(place.name),
        content: Text(place.address),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          onMapCreated: (controller) => _controller = controller,
          initialCameraPosition: const CameraPosition(
            target: LatLng(0, 0),
            zoom: 2,
          ),
          markers: _markers,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
        ),
        Positioned(
          top: 10,
          left: 10,
          right: 10,
          child: GooglePlaceAutoCompleteTextField(
            textEditingController: TextEditingController(),
            googleAPIKey: "YOUR_GOOGLE_API_KEY",
            inputDecoration: InputDecoration(
              hintText: "Search places",
              fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            debounceTime: 800,
            countries: const ["us"],
            isLatLngRequired: true,
            getPlaceDetailWithLatLng: (prediction) {
              final lat = double.parse(prediction.lat!);
              final lng = double.parse(prediction.lng!);
              _controller?.animateCamera(
                CameraUpdate.newLatLngZoom(LatLng(lat, lng), 15),
              );
            },
          ),
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            onPressed: _getCurrentLocation,
            child: const Icon(Icons.my_location),
          ),
        ),
      ],
    );
  }
}