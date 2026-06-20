import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class CallingPage extends StatefulWidget {
  final String title; // contoh: "Police Call"
  final String connectingTo; // contoh: "Police"
  final String phoneNumber; // nomor yang akan ditelpon

  const CallingPage({
    super.key,
    required this.title,
    required this.connectingTo,
    required this.phoneNumber,
  });

  @override
  State<CallingPage> createState() => _CallingPageState();
}

class _CallingPageState extends State<CallingPage> {
  late Timer _dotTimer;
  Timer? _callTimer;
  int _dotStep = 0;
  bool _isSpeakerOn = false;

  @override
  void initState() {
    super.initState();

    /// ANIMASI DOTS
    _dotTimer = Timer.periodic(const Duration(milliseconds: 400), (_) {
      setState(() {
        _dotStep = (_dotStep + 1) % 4;
      });
    });

    /// SETELAH 2 DETIK, LAKUKAN PANGGILAN
    _callTimer = Timer(const Duration(seconds: 2), _makeCall);
  }

  /// BACKEND: PANGGIL LANGSUNG (ANDROID) ATAU FALLBACK KE DIALER (IOS)
  Future<void> _makeCall() async {
    if (Platform.isAndroid) {
      final status = await Permission.phone.request();

      if (status.isGranted) {
        await FlutterPhoneDirectCaller.callNumber(widget.phoneNumber);
        return;
      }
    }

    // iOS atau permission Android ditolak -> buka dialer biasa
    await _openDialer();
  }

  Future<void> _openDialer() async {
    final Uri telUri = Uri(scheme: 'tel', path: widget.phoneNumber);

    if (await canLaunchUrl(telUri)) {
      await launchUrl(telUri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Tidak bisa melakukan panggilan ke ${widget.phoneNumber}",
            ),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _dotTimer.cancel();
    _callTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          width: 280,
          padding: const EdgeInsets.symmetric(
            vertical: 32,
            horizontal: 24,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.red,
                ),
              ),

              const SizedBox(height: 40),

              Text(
                "Connecting you to\n${widget.connectingTo}",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 14),

              /// ANIMATED DOTS
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  return AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: _dotStep > index ? 1.0 : 0.3,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 40),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  /// SPEAKER BUTTON (toggle UI saja)
                  GestureDetector(
                    onTap: () {
                      setState(() => _isSpeakerOn = !_isSpeakerOn);
                    },
                    child: CircleAvatar(
                      radius: 26,
                      backgroundColor:
                          _isSpeakerOn ? Colors.red : Colors.grey.shade300,
                      child: Icon(
                        Icons.volume_up,
                        color:
                            _isSpeakerOn ? Colors.white : Colors.grey.shade700,
                      ),
                    ),
                  ),

                  /// HANG UP BUTTON (batalkan panggilan)
                  GestureDetector(
                    onTap: () {
                      _callTimer?.cancel();
                      Navigator.pop(context);
                    },
                    child: const CircleAvatar(
                      radius: 26,
                      backgroundColor: Colors.red,
                      child: Icon(
                        Icons.call_end,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}