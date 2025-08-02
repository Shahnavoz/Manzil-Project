import 'package:flutter_riverpod/flutter_riverpod.dart';

final favouriteProvider = StateNotifierProvider<FavouriteNotifier, List<int>>(
  (ref) => FavouriteNotifier(),
);

class FavouriteNotifier extends StateNotifier<List<int>> {
  FavouriteNotifier() : super([]);

  void addToFavourite(int id) {
    if (!state.contains(id)) {
      state = [...state, id];
    }
  }

  void removeFromFavourite(int id) {
    state = state.where((element) => element != id).toList();
  }

  void clearFavourites() {
    state = [];
  }
}
