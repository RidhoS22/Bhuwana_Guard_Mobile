import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DetailFaunaReportPage extends StatefulWidget {
  final String reportId;

  const DetailFaunaReportPage({super.key, required this.reportId});

  @override
  State<DetailFaunaReportPage> createState() => _DetailFaunaReportPageState();
}

class _DetailFaunaReportPageState extends State<DetailFaunaReportPage> {
  final String _currentStatus = "Laporan Masuk";
  final Color primaryColor = const Color(0xFF6B1D1D);
  final Color darkBg = const Color(0xFF2E0D0D);

  // Data Default Spesifik Fauna
  final String titleHeader = "Fauna Report";
  final String teamLead = "Mr. Teguh Wijaya";
  final String teamDivision = "Lead Team";
  final String defaultImageUrl =
      'https://images.unsplash.com/photo-1546182990-dffeafbe841d';
  final String defaultLocationName = "National Park Reserve";
  final IconData progressIcon = Icons.pets_outlined;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('reports')
          .doc(widget.reportId)
          .snapshots(),
      builder: (context, reportSnapshot) {
        // Inisialisasi variabel lokal dengan nilai default (Pengaman Null)
        String currentStatusLocal = _currentStatus;
        String locationNameLocal = defaultLocationName;
        String imageUrlLocal = defaultImageUrl;
        String latitudeStr = "0.0";
        String longitudeStr = "0.0";
        String formattedDate = "March 25, 2028";
        dynamic rawCreatedAt;

        if (reportSnapshot.hasData && reportSnapshot.data!.exists) {
          final reportData =
              reportSnapshot.data!.data() as Map<String, dynamic>?;

          if (reportData != null) {
            rawCreatedAt = reportData['createdAt'];

            currentStatusLocal =
                reportData['status']?.toString() ?? _currentStatus;

            locationNameLocal =
                reportData['address']?.toString() ?? defaultLocationName;

            imageUrlLocal =
                reportData['imageUrl']?.toString() ?? defaultImageUrl;

            if (reportData['latitude'] != null) {
              latitudeStr = reportData['latitude'].toString();
            }

            if (reportData['longitude'] != null) {
              longitudeStr = reportData['longitude'].toString();
            }

            if (reportData['createdAt'] != null) {
              if (reportData['createdAt'] is Timestamp) {
                formattedDate = DateFormat(
                  'MMMM dd, yyyy',
                ).format((reportData['createdAt'] as Timestamp).toDate());
              } else {
                formattedDate = reportData['createdAt'].toString();
              }
            }
          }
        }

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            toolbarHeight: 100,
            backgroundColor: primaryColor,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 20,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              titleHeader,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Status : $currentStatusLocal",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey.shade200,
                    border: Border.all(color: primaryColor, width: 2),
                    image: DecorationImage(
                      image: NetworkImage(
                        imageUrlLocal.isNotEmpty
                            ? imageUrlLocal
                            : defaultImageUrl,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildInfoRow("Location", locationNameLocal),
                _buildInfoRow("Date", formattedDate),
                const SizedBox(height: 30),
                const Text(
                  "Detail Information",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                // PANGGIL TIMELINE 5 STEP DINAMIS DENGAN KABEL WAKTU CREATEDAT
                _buildLocalTimeline(
                  currentStatus: currentStatusLocal,
                  locationName: locationNameLocal,
                  imageUrl: imageUrlLocal,
                  latitude: latitudeStr,
                  longitude: longitudeStr,
                  createdAtData: rawCreatedAt,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // --- WIDGET TIMELINE 5 STEP ASLI BERSAMA JAM ---
  Widget _buildLocalTimeline({
    required String currentStatus,
    required String locationName,
    required String imageUrl,
    required String latitude,
    required String longitude,
    required dynamic createdAtData,
  }) {
    // 1. Ekstrak Jam & Tanggal dari createdAt Firebase
    String timeString = "--:--";
    String dateString = "Date";

    if (createdAtData != null) {
      DateTime? dateTime;
      if (createdAtData is Timestamp) {
        dateTime = createdAtData.toDate();
      } else if (createdAtData is String) {
        dateTime = DateTime.tryParse(createdAtData);
      }

      if (dateTime != null) {
        timeString = DateFormat('HH:mm').format(dateTime);
        dateString = DateFormat('MMM dd').format(dateTime);
      }
    }

    bool isStep1 = true;

    bool isStep2 =
        currentStatus == "Verifikasi" ||
        currentStatus == "Investigasi" ||
        currentStatus == "Selesai" ||
        currentStatus == "Report Closed";

    bool isStep3 =
        currentStatus == "Investigasi" ||
        currentStatus == "Selesai" ||
        currentStatus == "Report Closed";

    bool isStep4 =
        currentStatus == "Selesai" || currentStatus == "Report Closed";

    bool isStep5 = currentStatus == "Report Closed";

    return Column(
      children: [
        // STEP 1: LAPORAN DITERIMA
        IntrinsicHeight(
          child: Row(
            children: [
              SizedBox(
                width: 70,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      timeString,
                      style: TextStyle(
                        color: isStep1 ? Colors.black : Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      dateString,
                      style: const TextStyle(color: Colors.grey, fontSize: 11),
                    ),
                  ],
                ),
              ),
              _buildDotLine(0, 5, isStep1),
              const SizedBox(width: 15),
              Expanded(
                child: GestureDetector(
                  onTap: () => _showStepDialog(
                    0,
                    "Laporan Masuk",
                    imageUrl,
                    locationName,
                    latitude,
                    longitude,
                  ),
                  child: _buildStepCard("Laporan Terkirim", isStep1),
                ),
              ),
            ],
          ),
        ),

        // STEP 2: VERIFIKASI LAPORAN
        IntrinsicHeight(
          child: Row(
            children: [
              SizedBox(
                width: 70,
                child: Text(
                  isStep2 ? timeString : "--:--",
                  style: TextStyle(
                    color: isStep2 ? Colors.black : Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
              _buildDotLine(1, 5, isStep2),
              const SizedBox(width: 15),
              Expanded(
                child: GestureDetector(
                  onTap: () => isStep2
                      ? _showStepDialog(
                          1,
                          "Verifikasi Laporan",
                          imageUrl,
                          locationName,
                          latitude,
                          longitude,
                        )
                      : null,
                  child: _buildStepCard("Verifikasi Laporan", isStep2),
                ),
              ),
            ],
          ),
        ),

        // STEP 3: PROSES INVESTIGASI LAPANGAN
        IntrinsicHeight(
          child: Row(
            children: [
              SizedBox(
                width: 70,
                child: Text(
                  isStep3 ? timeString : "--:--",
                  style: TextStyle(
                    color: isStep3 ? Colors.black : Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
              _buildDotLine(2, 5, isStep3),
              const SizedBox(width: 15),
              Expanded(
                child: GestureDetector(
                  onTap: () => isStep3
                      ? _showStepDialog(
                          1,
                          "Investigasi Lapangan",
                          imageUrl,
                          locationName,
                          latitude,
                          longitude,
                        )
                      : null,
                  child: _buildStepCard("Proses Investigasi Lapangan", isStep3),
                ),
              ),
            ],
          ),
        ),

        // STEP 4: LAPORAN DITINDAKLANJUTI
        IntrinsicHeight(
          child: Row(
            children: [
              SizedBox(
                width: 70,
                child: Text(
                  isStep4 ? timeString : "--:--",
                  style: TextStyle(
                    color: isStep4 ? Colors.black : Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
              _buildDotLine(3, 5, isStep4),
              const SizedBox(width: 15),
              Expanded(
                child: GestureDetector(
                  onTap: () => isStep4
                      ? _showStepDialog(
                          2,
                          "Tindak Lanjut Kasus",
                          imageUrl,
                          locationName,
                          latitude,
                          longitude,
                        )
                      : null,
                  child: _buildStepCard("Laporan Ditindaklanjuti", isStep4),
                ),
              ),
            ],
          ),
        ),

        // STEP 5: LAPORAN SELESAI
        IntrinsicHeight(
          child: Row(
            children: [
              SizedBox(
                width: 70,
                child: Text(
                  isStep5 ? timeString : "--:--",
                  style: TextStyle(
                    color: isStep5 ? Colors.black : Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
              _buildDotLine(4, 5, isStep5),
              const SizedBox(width: 15),
              Expanded(
                child: GestureDetector(
                  onTap: () => isStep5
                      ? _showStepDialog(
                          4,
                          "Laporan Selesai Ditangani",
                          imageUrl,
                          locationName,
                          latitude,
                          longitude,
                        )
                      : null,
                  child: _buildStepCard("Laporan Selesai", isStep5),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- WIDGET POPUP DIALOG & COMPONENTS ---
  void _showStepDialog(
    int index,
    String stepTitle,
    String currentImg,
    String currentLoc,
    String lat,
    String lng,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext dContext) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: darkBg,
            borderRadius: BorderRadius.circular(15),
          ),
          child: _getDialogContent(
            index,
            stepTitle,
            currentImg,
            currentLoc,
            lat,
            lng,
            dContext,
          ),
        ),
      ),
    );
  }

  Widget _getDialogContent(
    int index,
    String stepTitle,
    String currentImg,
    String currentLoc,
    String lat,
    String lng,
    BuildContext dContext,
  ) {
    switch (index) {
      case 0:
        return _buildSentReportDialog(currentImg, currentLoc, lat, lng);
      case 1:
        return _buildDetailTeamDialog("Received by Fire Dept");
      case 2:
      case 3:
      case 4:
        return _buildSituationDialog(stepTitle, true, dContext);
      default:
        return const SizedBox();
    }
  }

  Widget _buildSentReportDialog(
    String currentImg,
    String currentLoc,
    String lat,
    String lng,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          "Report",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Container(
              width: 70,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(currentImg),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                "Dynamic Tracking\n$currentLoc...",
                style: const TextStyle(color: Colors.white70, fontSize: 11),
              ),
            ),
          ],
        ),
        const Divider(color: Colors.white24, height: 30),
        Text(
          "Coordinates : $lat° N, $lng° E",
          style: const TextStyle(color: Colors.white, fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildDetailTeamDialog(String title) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Your Report is\n$title",
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 25),
        _teamTileCenter(),
      ],
    );
  }

  Widget _buildSituationDialog(
    String title,
    bool isFinal,
    BuildContext dContext,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        const SizedBox(height: 20),
        _teamTileCenter(),
        const SizedBox(height: 20),
        const Text(
          "Progress",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        _progressRow(Icons.security_outlined, "Securing the area"),
        _progressRow(progressIcon, "Inspecting and responding"),
        if (isFinal) ...[
          const Divider(color: Colors.white24, height: 30),
          Center(
            child: InkWell(
              onTap: () async {
                Navigator.pop(dContext);
                await FirebaseFirestore.instance
                    .collection('reports')
                    .doc(widget.reportId)
                    .update({'status': 'Report Closed'});
              },
              child: const Text(
                "Report Completed",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _teamTileCenter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircleAvatar(radius: 25, child: Icon(Icons.person_outline)),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              teamLead,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              teamDivision,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDotLine(int index, int totalItems, bool isCompleted) {
    return SizedBox(
      width: 30,
      child: Column(
        children: [
          Expanded(
            child: Container(
              width: 2,
              color: index == 0
                  ? Colors.transparent
                  : (isCompleted ? primaryColor : Colors.grey.shade300),
            ),
          ),
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCompleted ? primaryColor : Colors.grey.shade300,
            ),
            child: const Icon(Icons.check, size: 14, color: Colors.white),
          ),
          Expanded(
            child: Container(
              width: 2,
              color: index == totalItems - 1
                  ? Colors.transparent
                  : (isCompleted ? primaryColor : Colors.grey.shade300),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepCard(String stepTitle, bool isCompleted) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: isCompleted ? primaryColor : Colors.grey.shade300,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            stepTitle,
            style: TextStyle(
              color: isCompleted ? primaryColor : Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
          Icon(
            Icons.chevron_right,
            size: 20,
            color: isCompleted ? primaryColor : Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget _progressRow(IconData icon, String label) => Padding(
    padding: const EdgeInsets.only(top: 12),
    child: Row(
      children: [
        Icon(icon, color: Colors.white, size: 18),
        const SizedBox(width: 12),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 13)),
      ],
    ),
  );

  Widget _buildInfoRow(String l, String v) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 90, child: Text(l)),
        const Text(": "),
        Expanded(child: Text(v, maxLines: null, softWrap: true)),
      ],
    ),
  );
}
