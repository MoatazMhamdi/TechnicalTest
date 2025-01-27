import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:technical_test_flutter/Screens/details_screen.dart';
import '../utils/launches_controller.dart';

class HomeScreen extends StatelessWidget {
  final LaunchesController controller = Get.put(LaunchesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SpaceX Launches', style: TextStyle(fontSize: 24)),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          // Search Field
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (query) {
                controller.searchQuery.value = query;
                controller.applyFilters();
              },
            ),
          ),

          // Filter Dropdowns
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Obx(() => DropdownButton<String>(
                    value: controller.selectedMission.value,
                    isExpanded: true,
                    onChanged: (value) {
                      controller.selectedMission.value = value ?? 'All';
                      controller.applyFilters();
                    },
                    items: controller.missionNames.map((name) {
                      return DropdownMenuItem(
                        value: name,
                        child: Text(name),
                      );
                    }).toList(),
                  )),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Obx(() => DropdownButton<String>(
                    value: controller.selectedStatus.value,
                    isExpanded: true,
                    onChanged: (value) {
                      controller.selectedStatus.value = value ?? 'All';
                      controller.applyFilters();
                    },
                    items: controller.statuses.map((status) {
                      return DropdownMenuItem(
                        value: status,
                        child: Text(status),
                      );
                    }).toList(),
                  )),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Obx(() => DropdownButton<String>(
                    value: controller.selectedYear.value,
                    isExpanded: true,
                    onChanged: (value) {
                      controller.selectedYear.value = value ?? 'All';
                      controller.applyFilters();
                    },
                    items: controller.years.map((year) {
                      return DropdownMenuItem(
                        value: year,
                        child: Text(year),
                      );
                    }).toList(),
                  )),
                ),
              ],
            ),
          ),

          // Launches List
          Expanded(
            child: Obx(() => controller.filteredLaunches.isEmpty
                ? Center(
              child: Text(
                'No launches found',
                style: TextStyle(fontSize: 18),
              ),
            )
                : ListView.builder(
              itemCount: controller.filteredLaunches.length,
              itemBuilder: (context, index) {
                final launch = controller.filteredLaunches[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Text(
                      launch['mission_name'] ?? 'Unknown Mission',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Text(launch['launch_date_utc'] ?? 'Unknown Date'),
                    trailing: Icon(
                      launch['launch_success'] == true
                          ? Icons.check_circle
                          : Icons.error,
                      color: launch['launch_success'] == true
                          ? Colors.green
                          : Colors.red,
                    ),
                    onTap: () {
                      Get.to(() => DetailScreen(
                        type: 'launch',
                        id: launch['flight_number'],
                      ));
                    },
                  ),
                );
              },
            )),
          ),
        ],
      ),
    );
  }
}
