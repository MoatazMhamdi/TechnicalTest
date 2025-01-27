import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio();

  Future<List<dynamic>> fetchLaunches() async {
    final response = await _dio.get('https://api.spacexdata.com/v3/launches');
    return response.data;
  }

  Future<List<dynamic>> fetchMissions() async {
    final response = await _dio.get('https://api.spacexdata.com/v3/missions');
    return response.data;
  }

  // Fetch launch details by ID
  Future<Map<String, dynamic>> fetchLaunchDetails(int id) async {
    final response = await _dio.get('https://api.spacexdata.com/v3/launches/$id');
    return response.data;
  }

  // Fetch mission details by ID
  Future<Map<String, dynamic>> fetchMissionDetails(int id) async {
    final response = await _dio.get('https://api.spacexdata.com/v3/missions/$id');
    return response.data;
  }
}
