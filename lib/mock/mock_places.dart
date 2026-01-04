import 'package:smart_travel_planner/models/places_model.dart';

class MockDelhiPlaces {
  static List<PlaceModel> places = [
    PlaceModel(
      name: 'India Gate',
      description:
      'A war memorial built in honor of Indian soldiers who died during World War I.',
      latitude: 28.6129,
      longitude: 77.2295,
      type: 'historical',
      comments: 'Visit in the evening for lighting and street food.',
    ),
    PlaceModel(
      name: 'Red Fort',
      description:
      'A UNESCO World Heritage Site and former residence of Mughal emperors.',
      latitude: 28.6562,
      longitude: 77.2410,
      type: 'historical',
      comments: 'Arrive early to avoid crowds.',
    ),
    PlaceModel(
      name: 'Lotus Temple',
      description:
      'A Baháʼí House of Worship known for its lotus-shaped architecture.',
      latitude: 28.5535,
      longitude: 77.2588,
      type: 'cultural',
      comments: 'Maintain silence inside the temple.',
    ),
    PlaceModel(
      name: 'Chandni Chowk',
      description:
      'One of the oldest markets in Delhi, famous for street food.',
      latitude: 28.6506,
      longitude: 77.2303,
      type: 'food',
      comments: 'Try parathas, jalebi, and chaat.',
    ),
    PlaceModel(
      name: 'Lodhi Garden',
      description:
      'A peaceful garden with historical tombs and lush greenery.',
      latitude: 28.5931,
      longitude: 77.2197,
      type: 'nature',
      comments: 'Perfect for morning walks.',
    ),
  ];
}
