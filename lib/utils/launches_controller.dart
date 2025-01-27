import 'package:get/get.dart';
import '../services/api_service.dart';

class LaunchesController extends GetxController {
  var launches = <dynamic>[].obs;
  var filteredLaunches = <dynamic>[].obs;
  var searchQuery = ''.obs;
  var selectedMission = 'All'.obs;
  var selectedStatus = 'All'.obs;
  var selectedYear = 'All'.obs;

  List<String> get missionNames => ['All'] +
      launches.map((e) => e['mission_name']?.toString() ?? '').toSet().toList();

  List<String> get statuses => ['All', 'Success', 'Failure'];
  List<String> get years => ['All'] +
      launches.map((e) => e['launch_year']?.toString() ?? '').toSet().toList();

  @override
  void onInit() {
    super.onInit();
    fetchLaunches();
  }

  void fetchLaunches() async {
    try {
      final result = await ApiService().fetchLaunches();
      launches.value = result;
      filteredLaunches.value = result;
    } catch (e) {
      print('Error fetching launches: $e');
    }
  }

  void applyFilters() {
    filteredLaunches.value = launches.where((launch) {
      // Matches search query
      final matchesQuery = searchQuery.value.isEmpty ||
          (launch['mission_name']?.toString().toLowerCase().contains(searchQuery.value.toLowerCase()) ?? false);

      // Matches mission name
      final matchesMission = selectedMission.value == 'All' ||
          (launch['mission_name']?.toString() == selectedMission.value);

      // Matches status
      final matchesStatus = selectedStatus.value == 'All' ||
          (selectedStatus.value == 'Success' && launch['launch_success'] == true) ||
          (selectedStatus.value == 'Failure' && launch['launch_success'] == false);

      // Matches year
      final matchesYear = selectedYear.value == 'All' ||
          (launch['launch_year']?.toString() == selectedYear.value);

      return matchesQuery && matchesMission && matchesStatus && matchesYear;
    }).toList();
  }
}
