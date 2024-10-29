import 'package:flutter/material.dart';
import 'package:map/models/place.dart';

class FavoritesScreen extends StatelessWidget {
  final List<Place> places;
  final Function(Place) onPlaceRemoved;

  const FavoritesScreen({super.key, required this.places, required this.onPlaceRemoved});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: places.length,
      itemBuilder: (context, index) {
        final place = places[index];
        return Dismissible(
          key: Key(place.id),
          direction: DismissDirection.endToStart,
          onDismissed: (_) => onPlaceRemoved(place),
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          child: ListTile(
            title: Text(place.name),
            subtitle: Text(place.address),
            leading: const Icon(Icons.place),
          ),
        );
      },
    );
  }
}