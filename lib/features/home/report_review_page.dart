import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../services/cloudinary_service.dart';

class ReportReviewPage extends StatefulWidget {
  final String imagePath;
  final double latitude;
  final double longitude;

  const ReportReviewPage({
    super.key,
    required this.imagePath,
    required this.latitude,
    required this.longitude,
  });

  @override
  State<ReportReviewPage> createState() => _ReportReviewPageState();
}

class _ReportReviewPageState extends State<ReportReviewPage> {
  String address = "Mencari lokasi...";
  bool isLoading = false;

  String selectedReportType = 'flora';

  final List<Map<String, dynamic>> reportTypes = [
    {
      'value': 'flora',
      'label': 'Flora',
      'description': 'Laporan terkait tumbuhan, pohon, atau tanaman.',
      'icon': Icons.local_florist_rounded,
    },
    {
      'value': 'fauna',
      'label': 'Fauna',
      'description': 'Laporan terkait hewan atau satwa.',
      'icon': Icons.pets_rounded,
    },
  ];

  @override
  void initState() {
    super.initState();
    getAddress();
  }

  Future<void> getAddress() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        widget.latitude,
        widget.longitude,
      );

      if (placemarks.isEmpty) {
        setState(() {
          address = "Lokasi tidak ditemukan";
        });
        return;
      }

      Placemark place = placemarks[0];

      setState(() {
        address =
            "${place.street ?? ''}, "
            "${place.locality ?? ''}, "
            "${place.administrativeArea ?? ''}";
      });
    } catch (e) {
      setState(() {
        address = "Lokasi tidak ditemukan";
      });
    }
  }

  Future<void> submitReport() async {
    setState(() {
      isLoading = true;
    });

    try {
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        throw Exception(
          'User belum login. Firestore reports membutuhkan authentication.',
        );
      }

      debugPrint('CURRENT USER UID: ${currentUser.uid}');
      debugPrint('SELECTED REPORT TYPE: $selectedReportType');

      File imageFile = File(widget.imagePath);

      String? imageUrl = await CloudinaryService.uploadImage(imageFile);

      if (imageUrl == null) {
        throw Exception('Upload gambar ke Cloudinary gagal');
      }

      debugPrint('CLOUDINARY IMAGE URL: $imageUrl');

      final reportData = {
        'imageUrl': imageUrl,
        'latitude': widget.latitude,
        'longitude': widget.longitude,
        'address': address,
        'status': 'Submitted',
        'type': selectedReportType,

        // tambahan agar report punya pemilik/user
        'userId': currentUser.uid,
        'reporterEmail': currentUser.email ?? '',
        'reporterName': currentUser.displayName ?? '',

        // lebih aman pakai server timestamp
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      debugPrint("STATUS DARI FIRESTORE = ${reportData['status']}");

      final docRef = await FirebaseFirestore.instance
          .collection('reports')
          .add(reportData);

      debugPrint('REPORT SUCCESS SAVED. DOC ID: ${docRef.id}');

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Laporan berhasil dikirim')));

      Navigator.pop(context);
    } on FirebaseException catch (e) {
      debugPrint('FIREBASE ERROR CODE: ${e.code}');
      debugPrint('FIREBASE ERROR MESSAGE: ${e.message}');
      debugPrint('FIREBASE ERROR PLUGIN: ${e.plugin}');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Firebase Error: ${e.code} - ${e.message}')),
      );
    } catch (e) {
      debugPrint('GENERAL ERROR SUBMIT REPORT: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Map<String, dynamic> getSelectedTypeData() {
    return reportTypes.firstWhere(
      (item) => item['value'] == selectedReportType,
      orElse: () => reportTypes.first,
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedTypeData = getSelectedTypeData();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),

                const Text(
                  "Emergency Report",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),

                const SizedBox(height: 6),

                const Text(
                  "Review your report before submit",
                  style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
                ),

                const SizedBox(height: 28),

                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: Image.file(
                            File(widget.imagePath),
                            height: 340,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),

                        const SizedBox(height: 22),

                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F3EE),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.location_on,
                                color: Color(0xFF145A3A),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  address,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF145A3A),
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 22),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF4F6F8),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Jenis Laporan",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF111827),
                                ),
                              ),

                              const SizedBox(height: 12),

                              DropdownButtonFormField<String>(
                                value: selectedReportType,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 14,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide.none,
                                  ),
                                  prefixIcon: Icon(
                                    selectedTypeData['icon'],
                                    color: const Color(0xFF145A3A),
                                  ),
                                ),
                                items: reportTypes.map((item) {
                                  return DropdownMenuItem<String>(
                                    value: item['value'],
                                    child: Text(
                                      item['label'],
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: isLoading
                                    ? null
                                    : (value) {
                                        if (value == null) return;

                                        setState(() {
                                          selectedReportType = value;
                                        });
                                      },
                              ),

                              const SizedBox(height: 10),

                              Text(
                                selectedTypeData['description'],
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF6B7280),
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 22),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF4F6F8),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Coordinates",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF111827),
                                ),
                              ),

                              const SizedBox(height: 12),

                              Row(
                                children: [
                                  const Icon(
                                    Icons.my_location,
                                    size: 18,
                                    color: Color(0xFF145A3A),
                                  ),

                                  const SizedBox(width: 8),

                                  Expanded(
                                    child: Text(
                                      "${widget.latitude.toStringAsFixed(6)}° N, "
                                      "${widget.longitude.toStringAsFixed(6)}° E",
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: Color(0xFF4B5563),
                                        height: 1.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF145A3A),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    onPressed: isLoading ? null : submitReport,
                    child: isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            "Submit Report",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
