import 'package:flutter/material.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Places App',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          const Text('Developers:'),
          const ListTile(
            leading: Icon(Icons.person),
            title: Text('John Doe'),
            subtitle: Text('john.doe@example.com'),
          ),
          const ListTile(
            leading: Icon(Icons.person),
            title: Text('Jane Smith'),
            subtitle: Text('jane.smith@example.com'),
          ),
          const SizedBox(height: 16),
          const Text('Year of Development: 2024'),
          const SizedBox(height: 16),
          const Text(
            'This app allows users to save and manage their favorite places on a map. '
            'Users can search for places, mark them as favorites, and easily access '
            'them later.',
          ),
        ],
      ),
    );
  }
}
