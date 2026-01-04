import 'package:flutter/material.dart';
import 'package:smart_travel_planner/services/hive_service.dart';
import 'package:smart_travel_planner/models/place_hive_model.dart';
import 'package:smart_travel_planner/screens/Places/place_detail_screen.dart';
import 'package:smart_travel_planner/models/places_model.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final HiveService _hiveService = HiveService();
  List<PlaceHiveModel> _favorites = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final result = await _hiveService.getFavorites();
    setState(() {
      _favorites = result;
      _isLoading = false;
    });
  }

  Future<void> _removeFavorite(String placeName) async {
    await _hiveService.removeFromFavorites(placeName);
    _loadFavorites();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Removed from favorites'),
          backgroundColor: Colors.black87,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: ListView(
        children: [
          _topBar(),
          const SizedBox(height: 20),
          _isLoading
              ? const Center(
            child: Padding(
              padding: EdgeInsets.all(50),
              child: CircularProgressIndicator(color: Colors.black),
            ),
          )
              : _favorites.isEmpty
              ? _emptyState()
              : _favoritesGrid(),
        ],
      ),
    );
  }

  // ================= TOP BAR =================
  Widget _topBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back_rounded, size: 30),
          ),
          const SizedBox(width: 20),
          const Text(
            'My Favorites',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }

  // ================= FAVORITES GRID =================
  Widget _favoritesGrid() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 50),
      child: Wrap(
        spacing: 13,
        runSpacing: 60,
        children: List.generate(_favorites.length, (index) {
          final place = _favorites[index];
          return SizedBox(
            height: 300,
            width: MediaQuery.of(context).size.width / 2 - 17,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _placeImage(place, index),
                _placeName(place),
                _placeActions(place),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _placeImage(PlaceHiveModel place, int index) {
    return SizedBox(
      height: 220,
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(100),
                topRight: Radius.circular(100),
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
              child: Image.asset(
                'assets/destinations/destination_${index % 6}.png',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) {
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.blue.shade300,
                          Colors.purple.shade300,
                        ],
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        _getIconForType(place.type),
                        size: 60,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white,
                  width: 1.9,
                ),
              ),
              child: const Icon(
                Icons.favorite_rounded,
                size: 18,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeName(PlaceHiveModel place) {
    return Text(
      place.name,
      textAlign: TextAlign.center,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w400,
        height: 1.4,
      ),
    );
  }

  Widget _placeActions(PlaceHiveModel place) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.category_rounded, size: 15, color: Colors.grey[700]),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    place.type,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 11, color: Colors.grey[700]),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _removeFavorite(place.name),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.delete_outline_rounded,
                size: 16,
                color: Colors.red.shade400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(50),
        child: Column(
          children: [
            Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(60),
              ),
              child: Icon(
                Icons.favorite_rounded,
                size: 60,
                color: Colors.red.shade300,
              ),
            ),
            const SizedBox(height: 30),
            Text(
              'No favorites yet',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Start exploring and save your favorite places',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

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
      default:
        return Icons.place_rounded;
    }
  }
}
