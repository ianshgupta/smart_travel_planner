import 'dart:math';
import 'package:flutter/material.dart';
import 'package:smart_travel_planner/models/place_hive_model.dart';
import 'package:smart_travel_planner/models/places_model.dart';
import 'package:smart_travel_planner/models/weather_model.dart';
import 'package:smart_travel_planner/models/images_model.dart';
import 'package:smart_travel_planner/services/hive_service.dart';
import 'package:smart_travel_planner/services/weather_service.dart';
import 'package:smart_travel_planner/services/image_service.dart';

class PlaceDetailScreen extends StatefulWidget {
  final PlaceModel place;
  final String city;

  const PlaceDetailScreen({
    super.key,
    required this.place,
    required this.city,
  });

  @override
  State<PlaceDetailScreen> createState() => _PlaceDetailScreenState();
}

class _PlaceDetailScreenState extends State<PlaceDetailScreen> {
  WeatherModel? _weather;
  List<ImageModel> _images = [];
  bool _isLoading = true;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _loadDetails();
    _checkIfFavorite();
  }

  Future<void> _checkIfFavorite() async {
    final hiveService = HiveService();
    final exists = await hiveService.isFavorite(widget.place.name);
    setState(() {
      _isFavorite = exists;
    });
  }


  Future<void> _loadDetails() async {
    final weatherService = WeatherService();
    final imageService = ImageService();

    final weatherResult = await weatherService.getWeather(widget.city);
    final imageResult = await imageService.searchImages(widget.place.name);

    setState(() {
      _weather = weatherResult;
      _images = imageResult;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(color: Colors.black),
      )
          : ListView(
        padding: const EdgeInsets.only(bottom: 100),
        children: [
          _buildHeroSection(),
          const SizedBox(height: 25),
          _buildInfoCards(),
          const SizedBox(height: 25),
          _buildSectionHeader('Gallery'),
          const SizedBox(height: 15),
          _buildImageSection(),
          const SizedBox(height: 25),
          _buildSectionHeader('About'),
          const SizedBox(height: 15),
          _buildDescriptionCard(),
          const SizedBox(height: 25),
          _buildSectionHeader('Tips & Recommendations'),
          const SizedBox(height: 15),
          _buildTipsCard(),
        ],
      ),
    );
  }

  // ================= HERO =================

  Widget _buildHeroSection() {
    final String? heroImage =
    _images.isNotEmpty ? _images.first.regularImage : null;
    final hiveService = HiveService();

    return SizedBox(
      height: 380,
      child: Stack(
        children: [
          // Hero image with gradient overlay
          Positioned.fill(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              child: heroImage != null
                  ? Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    heroImage,
                    fit: BoxFit.cover,
                    opacity: const AlwaysStoppedAnimation(0.8), // slightly darker
                    loadingBuilder: (_, child, progress) {
                      if (progress == null) return child;
                      return const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      );
                    },
                    errorBuilder: (_, __, ___) => _heroFallback(),
                  ),
                  // Dark gradient overlay for better text visibility
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.5),
                          Colors.transparent,
                          Colors.black.withOpacity(0.3),
                        ],
                        stops: const [0, 0.5, 1],
                      ),
                    ),
                  ),
                ],
              )
                  : _heroFallback(),
            ),
          ),

          // Place name
          Positioned(
            left: 30,
            bottom: 30,
            right: 30,
            child: Text(
              widget.place.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 56,
                fontWeight: FontWeight.w700,
                height: 1.2,
                shadows: [
                  Shadow(
                    blurRadius: 15,
                    color: Colors.black87,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
            ),
          ),

          // Top bar
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    final place = PlaceHiveModel(
                      name: widget.place.name,
                      description: widget.place.description,
                      latitude: widget.place.latitude,
                      longitude: widget.place.longitude,
                      type: widget.place.type,
                      comments: widget.place.comments,
                    );

                    await hiveService.addToFavorites(place);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Saved to favorites')),
                    );
                  },
                  child: GestureDetector(
                    onTap: () async {
                      final hiveService = HiveService();

                      final place = PlaceHiveModel(
                        name: widget.place.name,
                        description: widget.place.description,
                        latitude: widget.place.latitude,
                        longitude: widget.place.longitude,
                        type: widget.place.type,
                        comments: widget.place.comments,
                      );

                      if (_isFavorite) {
                        await hiveService.removeFromFavorites(widget.place.name);
                      } else {
                        await hiveService.addToFavorites(place);
                      }

                      setState(() {
                        _isFavorite = !_isFavorite;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: _isFavorite ? Colors.red : Colors.white,
                        size: 28,
                      ),
                    ),
                  ),

                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

// Fallback image if network fails
  Widget _heroFallback() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue.shade400,
            Colors.purple.shade400,
          ],
        ),
      ),
      child: const Center(
        child: Icon(Icons.place, size: 80, color: Colors.white70),
      ),
    );
  }



  // ================= INFO CARDS =================

  Widget _buildInfoCards() {
    return Container(
      height: 230,
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        children: [
          // Left card: Place Type
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  )
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _getIconForType(widget.place.type),
                    size: 50,
                    color: Colors.deepPurple,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    widget.place.type,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 20),

          // Right cards: Weather + Humidity
          Expanded(
            child: Column(
              children: [
                Expanded(child: _weatherCard()),
                const SizedBox(height: 20),
                Expanded(child: _humidityCard()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _weatherCard() {
    if (_weather == null) {
      return _infoBox(
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.cloud_off, size: 40, color: Colors.grey),
            SizedBox(height: 10),
            Text('No Weather', style: TextStyle(fontSize: 14)),
          ],
        ),
      );
    }

    return _infoBox(
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(widget.city, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${_weather!.temperature.toStringAsFixed(0)}°',
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 10),
              Icon(
                _getWeatherIcon(_weather!.icon),
                size: 35,
                color: Colors.orangeAccent,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _humidityCard() {
    if (_weather == null) {
      return _infoBox(
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.water_drop_outlined, size: 40, color: Colors.blue),
            SizedBox(height: 10),
            Text('No Data', style: TextStyle(fontSize: 14)),
          ],
        ),
      );
    }

    return _infoBox(
      Row(
        children: [
          // Humidity info
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Humidity', style: TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 5),
                Text(
                  '${_weather!.humidity}%',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
              ],
            ),
          ),

          // Visual bars
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              4,
                  (index) => Container(
                margin: const EdgeInsets.symmetric(vertical: 2),
                height: 10,
                width: 8,
                decoration: BoxDecoration(
                  color: index < (_weather!.humidity ~/ 25) ? Colors.blueAccent : Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

// Helper for card styling
  Widget _infoBox(Widget child) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }

  // ================= SECTIONS =================

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        padding: const EdgeInsets.only(left: 25),
        scrollDirection: Axis.horizontal,
        itemCount: _images.length,
        itemBuilder: (_, index) {
          return Container(
            margin: const EdgeInsets.only(right: 20),
            width: 220,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: NetworkImage(_images[index].regularImage),
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDescriptionCard() {
    return _textCard(widget.place.description);
  }

  Widget _buildTipsCard() {
    return _textCard(widget.place.comments);
  }

  Widget _textCard(String text) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 15, height: 1.6, color: Colors.grey[800]),
      ),
    );
  }

  // ================= HELPERS =================

  IconData _getIconForType(String type) {
    switch (type.toLowerCase()) {
      case 'historical':
        return Icons.account_balance_rounded;
      case 'cultural':
        return Icons.theater_comedy_rounded;
      case 'food':
        return Icons.restaurant_rounded;
      case 'nature':
        return Icons.park_rounded;
      case 'religious':
        return Icons.temple_hindu_rounded;
      default:
        return Icons.place_rounded;
    }
  }

  IconData _getWeatherIcon(String desc) {
    final d = desc.toLowerCase();
    if (d.contains('rain')) return Icons.grain_rounded;
    if (d.contains('cloud')) return Icons.cloud_rounded;
    if (d.contains('sun') || d.contains('clear')) return Icons.wb_sunny_rounded;
    if (d.contains('snow')) return Icons.ac_unit_rounded;
    return Icons.wb_cloudy_rounded;
  }

}
