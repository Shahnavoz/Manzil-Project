import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intetership_project/feature/home/data/models/building_model.dart';

final favouriteBuildingsProvider =
    StateNotifierProvider<FavouriteBuildingsNotifier, List<BuildingModel>>(
      (ref) => FavouriteBuildingsNotifier(),
    );

class FavouriteBuildingsNotifier extends StateNotifier<List<BuildingModel>> {
  FavouriteBuildingsNotifier() : super([]);

  void toggleFavourite(BuildingModel building) {
    if (state.any((b) => b.id == building.id)) {
      state = state.where((b) => b.id != building.id).toList();
    } else {
      state = [...state, building];
    }
  }

  bool isFavourite(BuildingModel building) {
    return state.any((b) => b.id == building.id);
  }

  void clearFavourites() {
    state = [];
  }
}
