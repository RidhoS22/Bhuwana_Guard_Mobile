import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:weather_icons/weather_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../history/history.dart';
import 'profile_page.dart';
import 'report_review_page.dart';
import '../safety_guide/safety_guide_page.dart';
import '../emergency_contact/emergency_contact_page.dart';

void main() {
  runApp(const EmergencyApp());
}

class EmergencyApp extends StatefulWidget {
  const EmergencyApp({super.key});

  @override
  State<EmergencyApp> createState() => _EmergencyAppState();
}

class _EmergencyAppState extends State<EmergencyApp>
    with SingleTickerProviderStateMixin {
  bool isDarkMode = false;
  int _selectedIndex = 0;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  void _onNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = isDarkMode ? ThemeData.dark() : ThemeData.light();
    final primaryColor = const Color(0xFF154E39);
    final accentColor = const Color(0xFF2FA07C);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme.copyWith(
        colorScheme: theme.colorScheme.copyWith(
          primary: primaryColor,
          secondary: accentColor,
        ),
        scaffoldBackgroundColor: isDarkMode
            ? const Color(0xFF121212)
            : const Color(0xFFF2F5EF),
      ),
      home: Scaffold(
        body: SafeArea(
          child: IndexedStack(
            index: _selectedIndex,
            children: [
              HomePage(
                isDarkMode: isDarkMode,
                onToggleTheme: _toggleTheme,
                pulseAnimation: _pulseAnimation,
              ),
              const HistoryTab(),
              const ProfilePage(),
            ],
          ),
        ),
        bottomNavigationBar: _buildBottomNavigationBar(primaryColor),
      ),
    );
  }

  Widget _buildBottomNavigationBar(Color primaryColor) {
    return Container(
      decoration: BoxDecoration(
        color: primaryColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 14,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: BottomNavigationBar(
          backgroundColor: primaryColor,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          currentIndex: _selectedIndex,
          onTap: _onNavTap,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              activeIcon: Icon(Icons.home_rounded, size: 28),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history_rounded),
              activeIcon: Icon(Icons.history_rounded, size: 28),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              activeIcon: Icon(Icons.person_rounded, size: 28),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;
  final Animation<double> pulseAnimation;

  const HomePage({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
    required this.pulseAnimation,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = true;

  String userName = "Loading...";
  String userLocation = "Loading...";
  String weatherMain = "Loading...";
  String cityName = "Loading...";

  double temperature = 0;
  double feelsLike = 0;

  IconData weatherIcon = Icons.wb_sunny_rounded;

  List<dynamic> weeklyForecast = [];

  @override
  void initState() {
    super.initState();
    getUserData();
    fetchWeather();
  }

  Future<void> getUserData() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        if (!mounted) return;
        setState(() {
          userName = 'User';
        });
        return;
      }

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!mounted) return;

      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>;

        setState(() {
          userName = data['name'] ?? user.displayName ?? 'User';
        });
      } else {
        setState(() {
          userName = user.displayName ?? 'User';
        });
      }
    } catch (e) {
      debugPrint('Error get user data: $e');

      if (!mounted) return;

      setState(() {
        userName = 'User';
      });
    }
  }

  Future<Position?> _getCurrentLocationForWeather() async {
    final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return null;
    }

    try {
      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 25),
      );

      debugPrint(
        'GPS WEATHER => LAT: ${position.latitude}, '
        'LON: ${position.longitude}, '
        'ACCURACY: ${position.accuracy} meter',
      );

      return position;
    } catch (e) {
      debugPrint('Error get current GPS location: $e');

      final Position? lastPosition = await Geolocator.getLastKnownPosition();

      if (lastPosition != null) {
        debugPrint(
          'LAST KNOWN GPS => LAT: ${lastPosition.latitude}, '
          'LON: ${lastPosition.longitude}, '
          'ACCURACY: ${lastPosition.accuracy} meter',
        );
      }

      return lastPosition;
    }
  }

  Future<String> _getReadableLocationName(Position position) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isEmpty) {
        return 'Lokasi saat ini';
      }

      final place = placemarks.first;

      final street = place.street ?? '';
      final subLocality = place.subLocality ?? '';
      final locality = place.locality ?? '';
      final subAdministrativeArea = place.subAdministrativeArea ?? '';
      final administrativeArea = place.administrativeArea ?? '';

      debugPrint(
        'REVERSE GEOCODING => '
        'street: $street, '
        'subLocality: $subLocality, '
        'locality: $locality, '
        'subAdmin: $subAdministrativeArea, '
        'admin: $administrativeArea',
      );

      if (subLocality.isNotEmpty) {
        return subLocality;
      }

      if (locality.isNotEmpty) {
        return locality;
      }

      if (subAdministrativeArea.isNotEmpty) {
        return subAdministrativeArea;
      }

      if (administrativeArea.isNotEmpty) {
        return administrativeArea;
      }

      return 'Lokasi saat ini';
    } catch (e) {
      debugPrint('Error reverse geocoding: $e');
      return 'Lokasi saat ini';
    }
  }

  Future<void> fetchWeather() async {
    try {
      if (mounted) {
        setState(() {
          _isLoading = true;
        });
      }

      const apiKey = '779081f8cca6b4666f100c7b01715cd2';

      final position = await _getCurrentLocationForWeather();

      if (position == null) {
        if (!mounted) return;

        setState(() {
          userLocation = 'Lokasi tidak aktif';
          cityName = 'GPS mati';
          weatherMain = 'Aktifkan lokasi';
          temperature = 0;
          feelsLike = 0;
          weeklyForecast = [];
          weatherIcon = Icons.location_off_rounded;
          _isLoading = false;
        });

        return;
      }

      final latitude = position.latitude;
      final longitude = position.longitude;

      final readableLocationName = await _getReadableLocationName(position);

      final currentUrl =
          'https://api.openweathermap.org/data/2.5/weather'
          '?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric';

      final forecastUrl =
          'https://api.openweathermap.org/data/2.5/forecast'
          '?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric';

      final currentResponse = await http
          .get(Uri.parse(currentUrl))
          .timeout(const Duration(seconds: 15));

      final forecastResponse = await http
          .get(Uri.parse(forecastUrl))
          .timeout(const Duration(seconds: 15));

      if (currentResponse.statusCode == 200 &&
          forecastResponse.statusCode == 200) {
        final data = jsonDecode(currentResponse.body);
        final forecastData = jsonDecode(forecastResponse.body);

        final String weatherCondition =
            data['weather']?[0]?['main']?.toString() ?? 'Clear';

        if (!mounted) return;

        setState(() {
          weeklyForecast = forecastData['list'] ?? [];

          cityName = readableLocationName;
          userLocation = readableLocationName;

          temperature = ((data['main']?['temp'] ?? 0) as num).toDouble();

          feelsLike = ((data['main']?['feels_like'] ?? temperature) as num)
              .toDouble();

          weatherMain = weatherCondition;
          weatherIcon = getWeatherIcon(weatherCondition);

          _isLoading = false;
        });
      } else {
        throw Exception(
          'Gagal mengambil data cuaca. '
          'Current: ${currentResponse.statusCode}, '
          'Forecast: ${forecastResponse.statusCode}',
        );
      }
    } catch (e) {
      debugPrint('Error fetch weather: $e');

      if (!mounted) return;

      setState(() {
        userLocation = 'Lokasi tidak tersedia';
        cityName = 'Gagal memuat';
        weatherMain = 'Tidak tersedia';
        temperature = 0;
        feelsLike = 0;
        weeklyForecast = [];
        weatherIcon = Icons.cloud_off_rounded;
        _isLoading = false;
      });
    }
  }

  IconData getWeatherIcon(String condition) {
    switch (condition.toLowerCase()) {
      case 'clouds':
        return WeatherIcons.cloudy;

      case 'rain':
        return WeatherIcons.rain;

      case 'drizzle':
        return WeatherIcons.sprinkle;

      case 'thunderstorm':
        return WeatherIcons.thunderstorm;

      case 'clear':
        return WeatherIcons.day_sunny;

      case 'snow':
        return WeatherIcons.snow;

      case 'mist':
      case 'fog':
      case 'haze':
      case 'smoke':
      case 'dust':
      case 'sand':
      case 'ash':
        return WeatherIcons.fog;

      default:
        return WeatherIcons.day_cloudy;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = widget.isDarkMode;
    final primaryColor = const Color(0xFF154E39);
    final accentColor = const Color(0xFF2FA07C);

    final textColor = isDarkMode ? Colors.white : const Color(0xFF1A1A2E);

    final subTextColor = isDarkMode ? Colors.white70 : const Color(0xFF606B5D);

    final pulseAnimation = widget.pulseAnimation;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildGradientHeader(
            primaryColor,
            accentColor,
            textColor,
            subTextColor,
          ),
          const SizedBox(height: 20),
          _buildMapSection(primaryColor, textColor),
          const SizedBox(height: 24),
          _buildEmergencyAssistantSection(primaryColor, accentColor, textColor),
          const SizedBox(height: 16),
          _buildFeatureCards(context, isDarkMode),
          const SizedBox(height: 30),
          _buildSOSButton(context, pulseAnimation),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildGradientHeader(
    Color primaryColor,
    Color accentColor,
    Color textColor,
    Color subTextColor,
  ) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: widget.isDarkMode
              ? [const Color(0xFF0B3222), const Color(0xFF143C2C)]
              : [const Color(0xFF154E39), const Color(0xFF2FA07C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
      child: Column(
        children: [
          Row(
            children: [
              _buildProfileAvatar(),
              const SizedBox(width: 14),
              _buildProfileInfo(textColor, subTextColor),
              _buildThemeToggleButton(),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildProfileAvatar() {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: CircleAvatar(
        radius: 28,
        backgroundColor: Colors.white.withOpacity(0.2),
        child: const Icon(Icons.person, size: 32, color: Colors.white),
      ),
    );
  }

  Widget _buildProfileInfo(Color textColor, Color subTextColor) {
    return Expanded(
      child: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          // Data default kalau database masih loading pas pertama dibuka
          String namaTampil = userName;
          String lokasiTampil = userLocation;

          // Kalau data dari Firebase udah masuk, kita timpa isinya pakai data paling baru
          if (snapshot.hasData && snapshot.data!.exists) {
            var userData = snapshot.data!.data() as Map<String, dynamic>;
            namaTampil = userData['name'] ?? userName;
            lokasiTampil =
                userData['location'] ??
                userLocation; // Sesuaikan key location lo jika ada
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                namaTampil, // 🔴 SEKARANG OTOMATIS BERUBAH REAL-TIME JADI "ks"
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    color: Colors.white70,
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      lokasiTampil, // 🔴 Lokasi juga ikut otomatis update kalau ada
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildThemeToggleButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        icon: Icon(
          widget.isDarkMode
              ? Icons.light_mode_rounded
              : Icons.dark_mode_rounded,
          color: Colors.white,
        ),
        onPressed: widget.onToggleTheme,
      ),
    );
  }

  Widget _buildMapSection(Color primaryColor, Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
        decoration: BoxDecoration(
          color: widget.isDarkMode
              ? const Color(0xFF1E2A38)
              : const Color(0xFF1B3A5C),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_isLoading)
              const SizedBox(
                height: 80,
                child: Center(
                  child: CircularProgressIndicator(color: Colors.white54),
                ),
              )
            else ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Saat ini',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.3,
                    ),
                  ),
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.location_on_rounded,
                            color: Colors.white70,
                            size: 12,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              cityName,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${temperature.round()}°',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 64,
                          fontWeight: FontWeight.w200,
                          height: 1.0,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Terasa seperti ${feelsLike.round()}°',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.55),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Icon(weatherIcon, color: Colors.white, size: 44),
                      const SizedBox(height: 6),
                      Text(
                        weatherMain,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
            const SizedBox(height: 20),
            Divider(
              color: Colors.white.withOpacity(0.15),
              thickness: 0.5,
              height: 0,
            ),
            const SizedBox(height: 16),
            Builder(
              builder: (context) {
                final forecastList = weeklyForecast.length >= 33
                    ? [
                        weeklyForecast[0],
                        weeklyForecast[8],
                        weeklyForecast[16],
                        weeklyForecast[24],
                        weeklyForecast[32],
                      ]
                    : [];

                if (forecastList.isEmpty) {
                  return const SizedBox();
                }

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(forecastList.length, (index) {
                    final item = forecastList[index];

                    final temp = ((item['main']?['temp'] ?? 0) as num).round();

                    final condition =
                        item['weather']?[0]?['main']?.toString() ?? 'Clear';

                    final date = DateTime.parse(item['dt_txt']);

                    final day = [
                      'MIN',
                      'SEN',
                      'SEL',
                      'RAB',
                      'KAM',
                      'JUM',
                      'SAB',
                    ][date.weekday % 7];

                    return _ForecastItem(
                      day: index == 0 ? 'Hari ini' : day,
                      temp: '$temp°',
                      icon: getWeatherIcon(condition),
                      isToday: index == 0,
                    );
                  }),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyAssistantSection(
    Color primaryColor,
    Color accentColor,
    Color textColor,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Layanan Darurat',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 4,
            width: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [primaryColor, accentColor]),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCards(BuildContext context, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: FeatureCard(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SafetyGuidePage(),
                      ),
                    );
                  },
                  icon: Icons.medical_services_rounded,
                  title: 'Panduan\nKeamanan',
                  subtitle: 'Antisipasi\nberbahaya',
                  color: const Color(0xFF1C6E4A),
                  isDark: isDarkMode,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FeatureCard(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const EmergencyContactPage(fromPage: 'home'),
                      ),
                    );
                  },
                  icon: Icons.phone_in_talk_rounded,
                  title: 'Kontak\nDarurat',
                  subtitle: 'Pusat\ninformasi',
                  color: const Color(0xFF397158),
                  isDark: isDarkMode,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSOSButton(
    BuildContext context,
    Animation<double> pulseAnimation,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: AnimatedBuilder(
          animation: pulseAnimation,
          builder: (context, child) {
            return Transform.scale(scale: pulseAnimation.value, child: child);
          },
          child: GestureDetector(
            onTap: () async {
              final ImagePicker picker = ImagePicker();

              final XFile? image = await picker.pickImage(
                source: ImageSource.camera,
              );

              if (image == null) return;

              final bool serviceEnabled =
                  await Geolocator.isLocationServiceEnabled();

              if (!serviceEnabled) {
                if (!context.mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('GPS belum aktif')),
                );

                return;
              }

              LocationPermission permission =
                  await Geolocator.checkPermission();

              if (permission == LocationPermission.denied) {
                permission = await Geolocator.requestPermission();
              }

              if (permission == LocationPermission.denied ||
                  permission == LocationPermission.deniedForever) {
                if (!context.mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Izin lokasi ditolak')),
                );

                return;
              }

              final Position position = await Geolocator.getCurrentPosition(
                desiredAccuracy: LocationAccuracy.high,
              );

              debugPrint(
                'SOS GPS => LAT: ${position.latitude}, '
                'LON: ${position.longitude}, '
                'ACCURACY: ${position.accuracy} meter',
              );

              if (!context.mounted) return;

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ReportReviewPage(
                    imagePath: image.path,
                    latitude: position.latitude,
                    longitude: position.longitude,
                  ),
                ),
              );
            },
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFFE53935), Color(0xFFFF1744)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.4),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Colors.red.shade700, Colors.red.shade900],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'SOS',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 32,
                          letterSpacing: 3,
                        ),
                      ),
                      Text(
                        'DARURAT',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 9,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FeatureCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final bool isDark;
  final VoidCallback? onTap;

  const FeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.isDark,
    this.onTap,
  });

  @override
  State<FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<FeatureCard> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          isHover = true;
        });
      },
      onExit: (_) {
        setState(() {
          isHover = false;
        });
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          transform: Matrix4.identity()..scale(isHover ? 1.03 : 1.0),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: widget.isDark ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: widget.isDark
                  ? Colors.white10
                  : widget.color.withOpacity(0.18),
            ),
            boxShadow: [
              BoxShadow(
                color: widget.isDark
                    ? Colors.black26
                    : Colors.black.withOpacity(isHover ? 0.12 : 0.05),
                blurRadius: isHover ? 24 : 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: widget.color.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(widget.icon, color: widget.color, size: 28),
              ),
              const SizedBox(height: 14),
              Text(
                widget.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: widget.isDark ? Colors.white : const Color(0xFF1A1A2E),
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                widget.subtitle,
                style: TextStyle(
                  fontSize: 11,
                  color: widget.isDark
                      ? Colors.white54
                      : const Color(0xFF616A60),
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ForecastItem extends StatelessWidget {
  final String day;
  final String temp;
  final IconData icon;
  final bool isToday;

  const _ForecastItem({
    required this.day,
    required this.temp,
    required this.icon,
    this.isToday = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          day,
          style: TextStyle(
            color: isToday ? Colors.white : Colors.white.withOpacity(0.55),
            fontSize: 11,
            fontWeight: isToday ? FontWeight.w600 : FontWeight.w400,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 8),
        Icon(icon, color: Colors.white.withOpacity(0.9), size: 22),
        const SizedBox(height: 8),
        Text(
          temp,
          style: TextStyle(
            color: isToday ? Colors.white : Colors.white.withOpacity(0.8),
            fontWeight: isToday ? FontWeight.w600 : FontWeight.w400,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
