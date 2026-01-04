class PlaceModel {

  final String name;
  final String description;
  final double latitude;
  final double longitude;
  final String type;
  final String comments;

  PlaceModel({
    required this.name,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.type,
    required this.comments

});

  factory PlaceModel.fromJson(Map<String, dynamic> json) {
    double parseDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is num) return value.toDouble();
      if (value is String) {
        return double.tryParse(value) ?? 0.0;
      }
      return 0.0;
    }

    final coordinates = json['coordinates'] ?? {};

    return PlaceModel(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      latitude: parseDouble(coordinates['latitude']),
      longitude: parseDouble(coordinates['longitude']),
      type: json['type'] ?? '',
      comments: json['comments'] ?? '',
    );
  }


}
