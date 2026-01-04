import 'package:hive/hive.dart';
import '../models/place_hive_model.dart';

class HiveService {
  static const String favoritesBox = 'favorites';

  Future<Box<PlaceHiveModel>> _openBox() async {
    return await Hive.openBox<PlaceHiveModel>(favoritesBox);
  }

  Future<void> addToFavorites(PlaceHiveModel place) async {
    final box = await _openBox();
    await box.put(place.name, place);
  }

  Future<void> removeFromFavorites(String name) async {
    final box = await _openBox();
    await box.delete(name);
  }

  Future<bool> isFavorite(String name) async {
    final box = await _openBox();
    return box.containsKey(name);
  }

  Future<List<PlaceHiveModel>> getFavorites() async {
    final box = await _openBox();
    return box.values.toList();
  }
}
