import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:weather_app/data/my_data.dart';


class HomeScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  const HomeScreen({Key? key, required this.onToggleTheme}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;
  String _cityName = '';
  double? _temp;
  double? _humidity;
  double? _minTemp;
  double? _maxTemp;
  int? _sunrise;
  int? _sunset;


  void initState() {
    super.initState();
    _getLocationAndWeather();
  }

  Future<void> _getLocationAndWeather() async {
    try {
      Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> places =
          await placemarkFromCoordinates(pos.latitude, pos.longitude);
      if (places.isNotEmpty) {
        _cityName = places.first.locality ?? '';
      }

      await _fetchWeatherData(pos.latitude, pos.longitude);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  Future<void> _fetchWeatherData(double lat, double lon) async {
    try {
         final url = 'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&units=metric&appid=$API_KEY';

      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body);

      setState(() {
        _temp = data['main']['temp']?.toDouble();
        _humidity = data['main']['humidity']?.toDouble();
        _minTemp = data['main']['temp_min']?.toDouble();
        _maxTemp = data['main']['temp_max']?.toDouble();
        _sunrise = data['sys']['sunrise'];
        _sunset = data['sys']['sunset'];
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetching weather: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _getWeatherImage() => 'assets/images/1.png';
  String _formatTime(int? timestamp) =>
      timestamp != null ? DateFormat('hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(timestamp * 1000)) : '--';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dateText = DateFormat('EEEE, d MMM y').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: const Text('SkyQuest', style: TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (_) {},
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'Location',
                child: Row(
                  children: [Icon(Icons.location_on, size: 20), SizedBox(width: 8), Text('Location')],
                ),
              ),
              const PopupMenuItem(
                value: 'Forecast',
                child: Row(
                  children: [Icon(Icons.view_list, size: 20), SizedBox(width: 8), Text('Forecast')],
                ),
              ),
              const PopupMenuItem(
                value: 'Share',
                child: Row(
                  children: [Icon(Icons.share, size: 20), SizedBox(width: 8), Text('Share')],
                ),
              ),
            ],
          ),
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
              ? const Center(child: CircularProgressIndicator(color: Colors.white))
              : Column(
                  children: [
                    // Top card
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          Text(
                            dateText,
                            style: TextStyle(
                              color: isDark ? Colors.white70 : Colors.black87,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _cityName,
                            style: TextStyle(
                              color: isDark ? Colors.white : Colors.black87,
                              fontSize: 22,
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
                            ),
                          ),
                          const SizedBox(height: 8),
                          Image.asset(
                            _getWeatherImage(),
                            height: 180,
                            fit: BoxFit.contain,
                          ),
                        ],
                      ),
                    ),
                    // Bottom grid
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
                              imgPath: 'assets/images/14.png',
                              isDark: isDark,
                            ),
                            _weatherCard(
                              title: 'Max Temp',
                              value: _maxTemp != null ? '${_maxTemp!.toStringAsFixed(1)}°C' : '--',
                              imgPath: 'assets/images/13.png',
                              isDark: isDark,
                            ),
                            _weatherCard(
                              title: 'Sunrise',
                              value: _formatTime(_sunrise),
                              imgPath: 'assets/images/11.png',
                              isDark: isDark,
                            ),
                            _weatherCard(
                              title: 'Sunset',
                              value: _formatTime(_sunset),
                              imgPath: 'assets/images/12.png',
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

  Widget _weatherCard({
    required String title,
    required String value,
    required String imgPath,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imgPath, width: 36, height: 36),
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
              Text(
                value,
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
