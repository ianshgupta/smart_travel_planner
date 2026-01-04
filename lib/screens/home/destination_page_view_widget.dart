import 'package:flutter/material.dart';

class DestinationPageView extends StatelessWidget {
  final List<Map<String, dynamic>> destinations;
  final int currentPage;
  final ValueChanged<int> onPageChanged;
  final ValueChanged<String> onCityTap;

  const DestinationPageView({
    super.key,
    required this.destinations,
    required this.currentPage,
    required this.onPageChanged,
    required this.onCityTap,
  });

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: PageController(viewportFraction: 0.5),
      padEnds: false,
      onPageChanged: onPageChanged,
      itemCount: destinations.length + 1,
      itemBuilder: (context, index) {
        if (index == destinations.length) {
          return const SizedBox(width: 20);
        }

        final destination = destinations[index];
        final isSelected = currentPage == index;

        return GestureDetector(
          onTap: () => onCityTap(destination['name']),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: EdgeInsets.only(
              left: 5,
              right: 5,
              top: isSelected ? 0 : 55,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.white
                  : Colors.black.withOpacity(0.85),
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// City name
                Text(
                  destination['name'],
                  style: TextStyle(
                    fontSize: 21 + (isSelected ? 8 : 0),
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.black : Colors.white,
                  ),
                ),

                /// Arrow indicator
                if (isSelected)
                  const Icon(
                    Icons.arrow_downward_rounded,
                    color: Colors.black,
                  ),

                /// Stacked icons (FIXED)
                _buildIconStack(isSelected),
              ],
            ),
          ),
        );
      },
    );
  }

  // ================= ICON STACK =================

  Widget _buildIconStack(bool isSelected) {
    final borderColor = isSelected ? Colors.white : Colors.black;

    return SizedBox(
      height: 35,
      child: Stack(
        children: [
          for (int i = 0; i < 3; i++)
            Positioned(
              left: i * 27,
              child: _iconCircle(
                icon: _getIconForIndex(i),
                borderColor: borderColor,
              ),
            ),
          Positioned(
            left: 81,
            child: Container(
              height: 35,
              width: 50,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: borderColor, width: 1.9),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconCircle({
    required IconData icon,
    required Color borderColor,
  }) {
    return Container(
      height: 35,
      width: 35,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 1.9),
      ),
      child: Icon(icon, size: 18, color: Colors.grey.shade700),
    );
  }

  IconData _getIconForIndex(int index) {
    final icons = [
      Icons.place_rounded,
      Icons.restaurant_rounded,
      Icons.temple_hindu_rounded,
    ];
    return icons[index % icons.length];
  }
}
