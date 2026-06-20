import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'detail_flora_report_page.dart';
import 'detail_fauna_report_page.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class HistoryTab extends StatefulWidget {
  const HistoryTab({super.key});

  @override
  State<HistoryTab> createState() => _HistoryTabState();
}

class _HistoryTabState extends State<HistoryTab> {
  String _currentFilter = "All Report";
  String userName = "Loading...";
  String userLocation = "Loading...";

  @override
  void initState() {
    super.initState();
    _loadUserData(); // nama dari Firebase
    _getCurrentLocation(); // lokasi dari GPS
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      setState(() {
        userLocation = "GPS tidak aktif";
      });
      return;
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      setState(() {
        userLocation = "Izin lokasi ditolak";
      });
      return;
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        userLocation = "Izin lokasi permanen ditolak";
      });
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (placemarks.isNotEmpty) {
      final place = placemarks.first;

      setState(() {
        userLocation =
            "${place.subAdministrativeArea ?? ''}, ${place.administrativeArea ?? ''}";
      });
    }
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (mounted && userDoc.exists) {
      final data = userDoc.data()!;
      setState(() {
        userName = data['name'] ?? 'User';
      });
    }
  }

  // Filter Reports - Rebuild saat filter berubah
  Stream<List<Map<String, dynamic>>> get _getReportsStream {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      debugPrint('ERROR: User not logged in');
      return Stream.value([]);
    }

    debugPrint('Loading reports for user: ${user.uid}');
    debugPrint('Current filter: $_currentFilter');

    // Query hanya menggunakan where, sorting dilakukan di client-side
    return FirebaseFirestore.instance
        .collection('reports')
        .where('userId', isEqualTo: user.uid)
        .snapshots()
        .map((snapshot) {
          debugPrint('Got ${snapshot.docs.length} reports from Firestore');

          // Convert dan sort di client-side
          final allReports = snapshot.docs.map((doc) {
            final data = doc.data();
            debugPrint('Report data: ${data['type']}, ${data['status']}');

            return {
              'id': doc.id,
              'title': '${data['type'] ?? 'Unknown'} Report',
              'type': data['type'] ?? 'Unknown',
              'status': data['status'] ?? 'Pending',
              'date': _formatDate(data['createdAt']),
              'address': data['address'] ?? 'Alamat tidak tersedia',
              'imageUrl': data['imageUrl'] ?? '',
              'latitude': data['latitude'] ?? 0.0,
              'longitude': data['longitude'] ?? 0.0,
              'reporterName': data['reporterName'] ?? 'Unknown',
              'reporterEmail': data['reporterEmail'] ?? '',
              'updatedAt': data['updatedAt'],
              'createdAtTimestamp': data['createdAt'] ?? Timestamp.now(),
              'icon': data['type'].toString().toLowerCase().contains('flora')
                  ? Icons.park
                  : Icons.pets,
            };
          }).toList();

          // Sort by createdAt (terbaru di atas) di client-side
          allReports.sort((a, b) {
            final aTime = a['createdAtTimestamp'] as Timestamp;
            final bTime = b['createdAtTimestamp'] as Timestamp;
            return bTime.compareTo(aTime);
          });

          // Apply filter
          if (_currentFilter == "All Report") {
            debugPrint('Showing all ${allReports.length} reports');
            return allReports;
          }

          final filterType = _currentFilter.split(" ")[0].toLowerCase();
          final filtered = allReports
              .where(
                (r) => r['type'].toString().toLowerCase().contains(filterType),
              )
              .toList();
          debugPrint('Filtered to $filterType: ${filtered.length} reports');
          return filtered;
        });
  }

  String _formatDate(dynamic timestamp) {
    if (timestamp == null) return 'Date not available';
    try {
      final date = (timestamp as Timestamp).toDate();
      return '${date.day} ${_monthName(date.month)} ${date.year} at ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return 'Date not available';
    }
  }

  String _monthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0D3B2E);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // --- HEADER PROFIL ---
          Container(
            padding: const EdgeInsets.fromLTRB(25, 60, 25, 20),
            color: primaryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      userName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      userLocation,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),

                const SizedBox(width: 15),

                const CircleAvatar(
                  radius: 25,
                  backgroundColor: Color(0xFF7E9790),
                  child: Icon(Icons.person, color: Colors.white),
                ),
              ],
            ),
          ),

          // --- TOMBOL FILTER ---
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: PopupMenuButton<String>(
                color: primaryColor,
                onSelected: (val) => setState(() => _currentFilter = val),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _currentFilter,
                        style: const TextStyle(color: Colors.white),
                      ),
                      const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
                itemBuilder: (ctx) =>
                    ["All Report", "Flora Report", "Fauna Report"]
                        .map(
                          (e) => PopupMenuItem(
                            value: e,
                            child: Text(
                              e,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        )
                        .toList(),
              ),
            ),
          ),

          // --- LIST HISTORY REAL-TIME DARI FIREBASE ---
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              key: ValueKey(
                _currentFilter,
              ), // Rebuild stream saat filter berubah
              stream: _getReportsStream,
              builder: (context, snapshot) {
                debugPrint('StreamBuilder state: ${snapshot.connectionState}');

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Loading reports...'),
                      ],
                    ),
                  );
                }

                if (snapshot.hasError) {
                  debugPrint('StreamBuilder error: ${snapshot.error}');
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error: ${snapshot.error}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.red.shade600,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => setState(() {}),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                final reports = snapshot.data ?? [];
                debugPrint('Displaying ${reports.length} reports');

                if (reports.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox,
                          size: 80,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Belum ada laporan',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Buat laporan baru untuk memulai',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  itemCount: reports.length,
                  itemBuilder: (context, index) {
                    final item = reports[index];

                    return GestureDetector(
                      onTap: () {
                        String titleLaporan = (item['title'] ?? '')
                            .toString()
                            .toLowerCase();

                        String currentReportId =
                            (item['id'] ?? item['title'] ?? '').toString();

                        if (titleLaporan.contains('fauna')) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailFaunaReportPage(
                                reportId: currentReportId,
                              ),
                            ),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetailFloraReportPage(
                                reportId: currentReportId,
                              ),
                            ),
                          );
                        }
                      },
                      child: _buildHistoryCard(
                        title: item['title'],
                        status: item['status'],
                        date: item['date'],
                        iconData: item['icon'],
                        address: item['address'],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Widget Card Tampilan
  Widget _buildHistoryCard({
    required String title,
    required String status,
    required String date,
    required IconData iconData,
    required String address,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.shade100,
            ),
            child: Icon(iconData, color: const Color(0xFF0D3B2E), size: 35),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0D3B2E),
                  ),
                ),
                const SizedBox(height: 5),
                Text("Status : $status", style: const TextStyle(fontSize: 13)),
                Text("Date : $date", style: const TextStyle(fontSize: 13)),
                const SizedBox(height: 3),
                Text(
                  address,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Color(0xFF0D3B2E),
          ),
        ],
      ),
    );
  }
}
