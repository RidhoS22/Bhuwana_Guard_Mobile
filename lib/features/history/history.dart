import 'package:flutter/material.dart';
import 'detailreportpage.dart';

class HistoryTab extends StatefulWidget {
  const HistoryTab({super.key});

  @override
  State<HistoryTab> createState() => _HistoryTabState();
}

class _HistoryTabState extends State<HistoryTab> {
  String _currentFilter = "All Report";

  // --- DATA SUMBER (PASTIKAN TYPE SESUAI DENGAN TITLE) ---
  final List<Map<String, dynamic>> _allReports = [
    {
      "title": "Flora Report",
      "type": "Flora", // Data Flora
      "status": "In progress",
      "date": "March 25, 2028",
      "icon": Icons.park,
    },
    {
      "title": "Fauna Report",
      "type": "Fauna", // Data Fauna
      "status": "Closed",
      "date": "June 22, 2027",
      "icon": Icons.pets,
    },
    {
      "title": "Flora Report",
      "type": "Flora",
      "status": "In progress",
      "date": "March 25, 2028",
      "icon": Icons.park,
    },
    {
      "title": "Fauna Report",
      "type": "Fauna",
      "status": "Closed",
      "date": "June 22, 2027",
      "icon": Icons.pets,
    },
  ];

  // Logika Filter
  List<Map<String, dynamic>> get _filteredReports {
    if (_currentFilter == "All Report") return _allReports;
    return _allReports
        .where((r) => r['type'] == _currentFilter.split(" ")[0])
        .toList();
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
                  children: const [
                    Text(
                      "Karel Septian",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "Desa kertosono, Kecamatan kertoyani",
                      style: TextStyle(color: Colors.white70, fontSize: 12),
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

          // --- LIST HISTORY (BAGIAN YANG DIBETULKAN) ---
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _filteredReports.length,
              itemBuilder: (context, index) {
                // Ambil data item berdasarkan index hasil filter
                final item = _filteredReports[index];

                return GestureDetector(
                  onTap: () {
                    // MENGIRIM TYPE YANG SESUAI (Flora ke Flora, Fauna ke Fauna)
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailReportPage(
                          reportType: item['type'], // Ini kunci perbaikannya
                        ),
                      ),
                    );
                  },
                  child: _buildHistoryCard(
                    title: item['title'],
                    status: item['status'],
                    date: item['date'],
                    iconData: item['icon'],
                  ),
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
                Text("Date   : $date", style: const TextStyle(fontSize: 13)),
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