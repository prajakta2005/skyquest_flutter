import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  const HomeScreen({Key? key, required this.onToggleTheme}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;
  String _locationText = 'Fetching location...';
  double? _temp;
  double? _humidity;
  double? _minTemp;
  double? _maxTemp;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _fetchWeatherData();
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _locationText = 'Permission denied';
          _isLoading = false;
        });
        return;
      }

      Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _locationText = 'Lat: ${pos.latitude}, Long: ${pos.longitude}';
      });

      _fetchWeatherData();
    } catch (e) {
      setState(() {
        _locationText = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  void _fetchWeatherData() {
    setState(() {
      _temp = 28.7;
      _humidity = 64.5;
      _minTemp = 21.3;
      _maxTemp = 32.8;
      _isLoading = false;
    });
  }

  String _getWeatherImage() => 'assets/images/9.png';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dateText = DateFormat('EEEE, d MMM y').format(DateTime.now());
    final cityName = 'Mumbai'; // Dummy city name — can be updated dynamically

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weatherly',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.wb_sunny : Icons.nightlight_round),
            onPressed: widget.onToggleTheme,
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [Colors.black87, Colors.deepPurpleAccent.shade700]
                : [Colors.blue.shade200, Colors.indigo.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Column(
                  children: [
                    // 📄 Top section: Date, City, Temp, Humidity
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            Text(
                              dateText,
                              style: TextStyle(
                                color: isDark ? Colors.white70 : Colors.black87,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              cityName,
                              style: TextStyle(
                                color: isDark ? Colors.white : Colors.black87,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _temp != null ? '${_temp!.toStringAsFixed(1)}°C' : '--',
                              style: TextStyle(
                                color: isDark ? Colors.white : Colors.black,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              _humidity != null ? 'Humidity: ${_humidity!.toStringAsFixed(0)}%' : '',
                              style: TextStyle(
                                color: isDark ? Colors.white70 : Colors.black87,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // 📷 Main weather image
                            Image.asset(
                              _getWeatherImage(),
                              height: 260,
                              fit: BoxFit.contain,
                            ),
                          ],
                        ),
                      ),
                    ),
                    // 📊 Bottom grid section
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: GridView.count(
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          childAspectRatio: 2,
                          children: [
                            _weatherCard(
                              title: 'Min Temp',
                              value: _minTemp != null ? '${_minTemp!.toStringAsFixed(1)}°C' : '--',
                              isDark: isDark,
                            ),
                            _weatherCard(
                              title: 'Max Temp',
                              value: _maxTemp != null ? '${_maxTemp!.toStringAsFixed(1)}°C' : '--',
                              isDark: isDark,
                            ),
                            _weatherCard(
                              title: 'Sunrise',
                              value: '06:15 AM',
                              isDark: isDark,
                            ),
                            _weatherCard(
                              title: 'Sunset',
                              value: '06:32 PM',
                              isDark: isDark,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _weatherCard({required String title, required String value, required bool isDark}) {
    String imgPath;
    switch (title) {
      case 'Min Temp':
        imgPath = 'assets/images/14.png';
        break;
      case 'Max Temp':
        imgPath = 'assets/images/13.png';
        break;
      case 'Sunrise':
        imgPath = 'assets/images/11.png';
        break;
      case 'Sunset':
        imgPath = 'assets/images/12.png';
        break;
      default:
        imgPath = 'assets/images/1.png';
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imgPath,
            width: 36,
            height: 36,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 6),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: isDark ? Colors.white70 : Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
