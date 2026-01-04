import 'package:flutter/material.dart';
import 'package:smart_travel_planner/models/places_model.dart';
import 'package:smart_travel_planner/screens/places/place_detail_screen.dart';
import 'package:smart_travel_planner/services/image_service.dart';
import 'package:smart_travel_planner/services/places_service.dart';

class PlacesListScreen extends StatefulWidget {
  final String city;

  const PlacesListScreen({super.key, required this.city});

  @override
  State<PlacesListScreen> createState() => _PlacesListScreenState();
}

class _PlacesListScreenState extends State<PlacesListScreen> {
  bool _isLoading = true;
  List<PlaceModel> _places = [];
  int _selectedCategoryIndex = 0;

  final Map<String, String> _placeImages = {};

  final List<Map<String, dynamic>> _categories = [
    {'name': 'All', 'icon': Icons.grid_view_rounded},
    {'name': 'Historical', 'icon': Icons.account_balance_rounded},
    {'name': 'Cultural', 'icon': Icons.theater_comedy_rounded},
    {'name': 'Food', 'icon': Icons.restaurant_rounded},
    {'name': 'Nature', 'icon': Icons.park_rounded},
  ];

  @override
  void initState() {
    super.initState();
    _fetchPlaces();
  }

  Future<void> _fetchPlaces() async {
    setState(() => _isLoading = true);

    final placesService = PlacesService();
    final imageService = ImageService();

    try {
      /// 1️⃣ Fetch real places data
      final List<PlaceModel> result = await placesService.getPlaces(
        region: widget.city,
        interests: ['historical', 'cultural', 'food'],
      );

      /// 2️⃣ Fetch images for ONLY first 5 places (rate-limit safe)
      for (final place in result.take(5)) {
        try {
          final images = await imageService.searchImages(place.name);
          if (images.isNotEmpty) {
            _placeImages[place.name] = images.first.smallImage;
          }
        } catch (e) {
          // Image API failed → ignore safely
        }
      }

      /// 3️⃣ Update UI
      setState(() {
        _places = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to load places. Please try again later.'),
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
          _cityTitle(),
          const SizedBox(height: 20),
          _categorySelector(),
          const SizedBox(height: 60),
          _isLoading
              ? const Center(
            child: Padding(
              padding: EdgeInsets.all(50),
              child: CircularProgressIndicator(color: Colors.black),
            ),
          )
              : _places.isEmpty
              ? _emptyState()
              : _placesGrid(),
        ],
      ),
    );
  }

  // -------------------- UI SECTIONS --------------------

  Widget _topBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back_rounded, size: 30),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: SizedBox(
              height: 45,
              width: 45,
              child: Image.asset(
                'assets/profile.png',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) {
                  return Container(
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.person, color: Colors.grey),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cityTitle() {
    return Padding(
      padding: const EdgeInsets.only(left: 30),
      child: Text(
        widget.city,
        style: const TextStyle(
          fontSize: 50,
          fontWeight: FontWeight.w400,
          letterSpacing: -1.2,
          height: 1.4,
        ),
      ),
    );
  }

  Widget _categorySelector() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 25),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _selectedCategoryIndex == index;

          return GestureDetector(
            onTap: () {
              setState(() => _selectedCategoryIndex = index);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding:
              const EdgeInsets.symmetric(horizontal: 22, vertical: 5),
              margin: const EdgeInsets.only(right: 13),
              decoration: BoxDecoration(
                color: isSelected ? Colors.black : Colors.transparent,
                borderRadius: BorderRadius.circular(13),
                border: Border.all(
                  color: isSelected ? Colors.black : Colors.grey[300]!,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    category['icon'],
                    size: 17,
                    color: isSelected ? Colors.white : Colors.grey,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    category['name'],
                    style: TextStyle(
                      fontSize: 17,
                      color: isSelected ? Colors.white : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _placesGrid() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 50),
      child: Wrap(
        spacing: 13,
        runSpacing: 60,
        children: List.generate(_places.length, (index) {
          final place = _places[index];

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PlaceDetailScreen(
                    place: place,
                    city: widget.city

                  ),
                ),
              );
            },
            child: SizedBox(
              height: 300,
              width: MediaQuery.of(context).size.width / 2 - 17,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _placeImage(place),
                  _placeName(place),
                  _placeCategory(place),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _placeImage(PlaceModel place) {
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
              child: _placeImages.containsKey(place.name)
                  ? Image.network(
                _placeImages[place.name]!,
                fit: BoxFit.cover,
                loadingBuilder: (_, child, progress) {
                  if (progress == null) return child;
                  return const Center(
                    child:
                    CircularProgressIndicator(strokeWidth: 2),
                  );
                },
                errorBuilder: (_, __, ___) {
                  return _fallbackImage(place.type);
                },
              )
                  : _fallbackImage(place.type),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                _getIconForType(place.type),
                size: 18,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeName(PlaceModel place) {
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

  Widget _placeCategory(PlaceModel place) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.category_rounded, size: 15, color: Colors.grey[700]),
        const SizedBox(width: 8),
        Text(
          place.type,
          style: TextStyle(fontSize: 11, color: Colors.grey[700]),
        ),
      ],
    );
  }

  Widget _emptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(50),
        child: Text(
          'No places found',
          style: TextStyle(fontSize: 18, color: Colors.grey[600]),
        ),
      ),
    );
  }

  Widget _fallbackImage(String type) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue.shade300, Colors.purple.shade300],
        ),
      ),
      child: Center(
        child: Icon(
          _getIconForType(type),
          size: 60,
          color: Colors.white,
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
