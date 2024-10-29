// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:map/models/place.dart';
import 'package:map/screens/favorites_screen.dart';
import 'package:map/screens/info_screen.dart';
import 'package:map/screens/map_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp ({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Places App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage ({super.key});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<Place> favoritePlaces = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadPlaces();
  }

  Future<void> _loadPlaces() async {
    final prefs = await SharedPreferences.getInstance();
    final placesJson = prefs.getStringList('places') ?? [];
    setState(() {
      favoritePlaces.clear();
      favoritePlaces.addAll(
        placesJson.map((json) => Place.fromJson(jsonDecode(json))).toList(),
      );
    });
  }

  Future<void> _savePlaces() async {
    final prefs = await SharedPreferences.getInstance();
    final placesJson = favoritePlaces
        .map((place) => jsonEncode(place.toJson()))
        .toList();
    await prefs.setStringList('places', placesJson);
  }

  void addPlace(Place place) {
    setState(() {
      favoritePlaces.add(place);
      _savePlaces();
    });
  }

  void removePlace(Place place) {
    setState(() {
      favoritePlaces.remove(place);
      _savePlaces();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Places App'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.map), text: 'Map'),
            Tab(icon: Icon(Icons.favorite), text: 'Favorites'),
            Tab(icon: Icon(Icons.info), text: 'Info'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          MapScreen(places: favoritePlaces, onPlaceAdded: addPlace),
          FavoritesScreen(places: favoritePlaces, onPlaceRemoved: removePlace),
          InfoScreen(),
        ],
      ),
    );
  }
}
