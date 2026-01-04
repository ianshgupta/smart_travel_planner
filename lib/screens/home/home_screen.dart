import 'package:flutter/material.dart';
import 'package:smart_travel_planner/screens/favorite/favorite_screen.dart';
import 'package:smart_travel_planner/screens/home/background_image_widget.dart';
import 'package:smart_travel_planner/screens/home/destination_page_view_widget.dart';
import 'package:smart_travel_planner/screens/home/title_text_widget.dart';
import 'package:smart_travel_planner/screens/home/search_bar_widget.dart';
import 'package:smart_travel_planner/screens/home/top_bar_widget.dart';
import 'package:smart_travel_planner/screens/Places/places_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final TextEditingController _cityController = TextEditingController();
  late PageController _pageViewController;
  late TabController _tabController;
  int _currentPage = 0;

  final List<Map<String, dynamic>> _popularDestinations = [
    {'name': 'Mumbai', 'subtitle': 'City of Dreams'},
    {'name': 'Delhi', 'subtitle': 'Historical Capital'},
    {'name': 'Bangalore', 'subtitle': 'Garden City'},
    {'name': 'Jaipur', 'subtitle': 'Pink City'},
    {'name': 'Goa', 'subtitle': 'Beach Paradise'},
  ];

  @override
  void initState() {
    super.initState();
    _pageViewController = PageController(viewportFraction: 0.5);
    _tabController = TabController(length: _popularDestinations.length, vsync: this);
  }

  @override
  void dispose() {
    _cityController.dispose();
    _pageViewController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _handlePageViewChanged(int index) {
    if (!mounted) return;
    setState(() {
      _currentPage = index;
      _tabController.index = index;
    });
  }

  void _navigateToCity(String city) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PlacesListScreen(city: city)),
    );
  }

  void _navigateToFavorites() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const FavoritesScreen()),
    );
  }

  void _onSearchPressed() {
    final city = _cityController.text.trim();
    if (city.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a city name')),
      );
      return;
    }
    _cityController.clear();
    _navigateToCity(city);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const BackgroundImage(),
          Positioned(
            top: 70,
            left: 31,
            right: 31,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TopBar(
                  onFavoritesPressed: _navigateToFavorites,
                ),
                const SizedBox(height: 40),
                const TitleText(),
                const SizedBox(height: 40),
                SearchBarWidget(
                  controller: _cityController,
                  onSearchPressed: _onSearchPressed,
                ),
              ],
            ),
          ),
          Positioned(
            height: 250,
            bottom: 20,
            left: 0,
            right: 0,
            child: DestinationPageView(
              destinations: _popularDestinations,
              currentPage: _currentPage,
              onPageChanged: _handlePageViewChanged,
              onCityTap: _navigateToCity,
            ),
          ),
        ],
      ),
    );
  }
}

