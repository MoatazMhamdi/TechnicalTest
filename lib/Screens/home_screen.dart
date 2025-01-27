import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../Services/api_service.dart';
import '../Services/cache_service.dart';
import 'details_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> _launches = [];
  List<dynamic> _filteredLaunches = [];
  List<String> _missionNames = ['All'];
  List<String> _statuses = ['All', 'Success', 'Failure'];
  List<String> _years = ['All'];
  String? _selectedMission;
  String? _selectedStatus;
  String? _selectedYear;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchLaunches();
    NetworkService.checkConnectivity();  // Check connectivity on startup
  }

  Future<void> _fetchLaunches() async {
    try {
      final launches = await ApiService().fetchLaunches();
      setState(() {
        _launches = launches;
        _filteredLaunches = launches;
        _missionNames.addAll(
          launches.map<String>((launch) => launch['mission_name']).toSet(),
        );
        Set<String> yearsSet = launches.map<String>((launch) {
          final date = launch['launch_date_utc'];
          return date != null && date.isNotEmpty
              ? date.split('-')[0]
              : 'Unknown';
        }).toSet();
        _years = ['All', ...yearsSet.toList()];
      });
    } catch (e) {
      print('Error fetching launches: $e');
    }
  }

  void _applyFilters() {
    setState(() {
      _filteredLaunches = _launches.where((launch) {
        final missionFilter = _selectedMission == null ||
            _selectedMission == 'All' ||
            launch['mission_name'] == _selectedMission;
        final statusFilter = _selectedStatus == null ||
            _selectedStatus == 'All' ||
            (_selectedStatus == 'Success' && launch['launch_success'] == true) ||
            (_selectedStatus == 'Failure' && launch['launch_success'] == false);
        final yearFilter = _selectedYear == null ||
            _selectedYear == 'All' ||
            launch['launch_date_utc'].split('-')[0] == _selectedYear;
        final searchFilter = _searchQuery.isEmpty ||
            launch['mission_name']
                .toLowerCase()
                .contains(_searchQuery.toLowerCase());
        return missionFilter && statusFilter && yearFilter && searchFilter;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SpaceX Launches', style: TextStyle(fontSize: 24)),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
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
                setState(() {
                  _searchQuery = query;
                  _applyFilters();
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    hint: Text('Filter by Mission'),
                    value: _selectedMission,
                    isExpanded: true,
                    onChanged: (value) {
                      setState(() {
                        _selectedMission = value;
                        _applyFilters();
                      });
                    },
                    items: _missionNames.map<DropdownMenuItem<String>>((name) {
                      return DropdownMenuItem(
                        value: name,
                        child: Text(name),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: DropdownButton<String>(
                    hint: Text('Filter by Status'),
                    value: _selectedStatus,
                    isExpanded: true,
                    onChanged: (value) {
                      setState(() {
                        _selectedStatus = value;
                        _applyFilters();
                      });
                    },
                    items: _statuses.map<DropdownMenuItem<String>>((status) {
                      return DropdownMenuItem(
                        value: status,
                        child: Text(status),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: DropdownButton<String>(
                    hint: Text('Filter by Year'),
                    value: _selectedYear,
                    isExpanded: true,
                    onChanged: (value) {
                      setState(() {
                        _selectedYear = value;
                        _applyFilters();
                      });
                    },
                    items: _years.map<DropdownMenuItem<String>>((year) {
                      return DropdownMenuItem(
                        value: year,
                        child: Text(year),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _filteredLaunches.isEmpty
                ? Center(
              child: Text(
                'No launches found',
                style: TextStyle(fontSize: 18),
              ),
            )
                : ListView.builder(
              itemCount: _filteredLaunches.length,
              itemBuilder: (context, index) {
                final launch = _filteredLaunches[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Text(
                      launch['mission_name'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Text(launch['launch_date_utc']),
                    trailing: Icon(
                      launch['launch_success'] == true
                          ? Icons.check_circle
                          : Icons.error,
                      color: launch['launch_success'] == true
                          ? Colors.green
                          : Colors.red,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(
                            type: 'launch',
                            id: launch['flight_number'],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class NetworkService {
  static Future<void> checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.none) {
      // Show toast message when offline
      Fluttertoast.showToast(
        msg: "You are offline",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }
}
