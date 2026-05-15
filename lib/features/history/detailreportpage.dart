import 'package:flutter/material.dart';

class DetailReportPage extends StatefulWidget {
  // Ini kunci utamanya: menangkap tipe laporan dari HistoryTab
  final String reportType;

  const DetailReportPage({super.key, required this.reportType});

  @override
  State<DetailReportPage> createState() => _DetailReportPageState();
}

class _DetailReportPageState extends State<DetailReportPage> {
  int _activeStepIndex = 0;
  String _currentStatus = "In Progress";

  final Color primaryColor = const Color(0xFF0D2E24);
  final Color darkBg = const Color(0xFF0D241E);

  // Variabel yang akan berubah otomatis
  late String titleHeader;
  late String teamLead;
  late String teamDivision;
  late String imageUrl;
  late String locationName;
  late IconData progressIcon;

  @override
  void initState() {
    super.initState();
    // LOGIKA PEMBEDA: Flora vs Fauna
    if (widget.reportType == "Flora") {
      titleHeader = "Flora Report";
      teamLead = "Mr. Agus Sentosa"; //
      teamDivision = "Karhutla Team";
      imageUrl = 'https://images.unsplash.com/photo-1441974231531-c6227db76b6e';
      locationName = "Sari Florest";
      progressIcon = Icons.nature_outlined;
    } else {
      titleHeader = "Fauna Report";
      teamLead = "Mr. Teguh Wijaya"; //
      teamDivision = "Fauna Protection";
      imageUrl = 'https://images.unsplash.com/photo-1542601906990-b4d3fb773b09';
      locationName = "Wild Tiger Zone";
      progressIcon = Icons.pets_outlined;
    }
  }

  final List<String> _steps = [
    "Sent Report",
    "Report Received",
    "Officer Go To Location",
    "Arrived And Handling",
    "Report Completed",
  ];

  final List<String> _times = [
    "8:00 AM",
    "8:03 AM",
    "8:05 AM",
    "8:15 AM",
    "9:30 AM",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
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
              "Status : $_currentStatus",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildInfoRow("Location", locationName),
            _buildInfoRow("Date", "March 25, 2028"),
            const SizedBox(height: 30),
            const Text(
              "Detail Information",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _steps.length,
              itemBuilder: (context, index) => _buildTimelineItem(index),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET TIMELINE & DIALOG ---
  Widget _buildTimelineItem(int index) {
    bool isActivated = index <= _activeStepIndex;
    return IntrinsicHeight(
      child: Row(
        children: [
          SizedBox(
            width: 70,
            child: Text(
              _times[index],
              style: TextStyle(
                color: isActivated ? Colors.black : Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
          _buildDotLine(index, isActivated),
          const SizedBox(width: 15),
          Expanded(
            child: GestureDetector(
              onTap: () => isActivated ? _showStepDialog(index) : null,
              child: _buildStepCard(index, isActivated),
            ),
          ),
        ],
      ),
    );
  }

  void _showStepDialog(int index) {
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
          child: _getDialogContent(index, dContext),
        ),
      ),
    ).then((_) {
      if (mounted &&
          index == _activeStepIndex &&
          _activeStepIndex < _steps.length - 1) {
        setState(() {
          _activeStepIndex++;
        });
      }
    });
  }

  Widget _getDialogContent(int index, BuildContext dContext) {
    switch (index) {
      case 0:
        return _buildSentReportDialog();
      case 1:
        return _buildDetailTeamDialog("Received by $teamDivision");
      case 2:
        return _buildSituationDialog("Officer Go To Location", false, dContext);
      case 3:
        return _buildSituationDialog("Arrived and Handling", false, dContext);
      case 4:
        return _buildSituationDialog("Report Completed", true, dContext);
      default:
        return const SizedBox();
    }
  }

  Widget _buildSentReportDialog() {
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
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                "March 25, 2028\n$locationName Zone...",
                style: const TextStyle(color: Colors.white70, fontSize: 11),
              ),
            ),
          ],
        ),
        const Divider(color: Colors.white24, height: 30),
        const Text(
          "Coordinates : 1.1561° N, 113.5684° E",
          style: TextStyle(color: Colors.white, fontSize: 13),
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
              onTap: () {
                Navigator.pop(dContext);
                setState(() {
                  _currentStatus = "Report Closed";
                });
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

  // --- SUB WIDGETS ---
  Widget _buildDotLine(int index, bool isActivated) {
    return SizedBox(
      width: 30,
      child: Column(
        children: [
          Expanded(
            child: Container(
              width: 2,
              color: index == 0
                  ? Colors.transparent
                  : (isActivated ? primaryColor : Colors.grey.shade300),
            ),
          ),
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActivated ? primaryColor : Colors.grey.shade300,
            ),
            child: const Icon(Icons.check, size: 14, color: Colors.white),
          ),
          Expanded(
            child: Container(
              width: 2,
              color: index == _steps.length - 1
                  ? Colors.transparent
                  : (isActivated ? primaryColor : Colors.grey.shade300),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepCard(int index, bool isActivated) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: isActivated ? primaryColor : Colors.grey.shade300,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _steps[index],
            style: TextStyle(
              color: isActivated ? primaryColor : Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
          Icon(
            Icons.chevron_right,
            size: 20,
            color: isActivated ? primaryColor : Colors.grey,
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
      children: [
        SizedBox(
          width: 90,
          child: Text(l, style: const TextStyle(fontSize: 16)),
        ),
        Text(
          ": $v",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    ),
  );
}
