import 'package:hive/hive.dart';

part 'place_hive_model.g.dart';

@HiveType(typeId: 1)
class PlaceHiveModel extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String description;

  @HiveField(2)
  final double latitude;

  @HiveField(3)
  final double longitude;

  @HiveField(4)
  final String type;

  @HiveField(5)
  final String comments;

  PlaceHiveModel({
    required this.name,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.type,
    required this.comments,
  });
}
