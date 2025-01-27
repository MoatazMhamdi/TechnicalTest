import 'package:flutter/material.dart';
import '../Services/api_service.dart';

class DetailScreen extends StatelessWidget {
  final String type;
  final int id;

  DetailScreen({required this.type, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
        backgroundColor: Colors.deepPurple,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: type == 'launch'
            ? ApiService().fetchLaunchDetails(id)
            : ApiService().fetchMissionDetails(id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final data = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  type == 'launch'
                      ? 'Mission: ${data['mission_name']}'
                      : 'Mission: ${data['name']}',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Text('Details: ${data['details'] ?? 'No details available'}'),
                // Add more details as needed
              ],
            ),
          );
        },
      ),
    );
  }
}
