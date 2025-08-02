import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchFilterProvider = StateNotifierProvider<SearchFilterNotifier, Map<String, dynamic>>(
  (ref) => SearchFilterNotifier(),
);

class SearchFilterNotifier extends StateNotifier<Map<String, dynamic>> {
  SearchFilterNotifier() : super({});

  void setFilter(String key, dynamic value) {
    state = {...state, key: value};
  }

  void clearFilters() {
    state = {};
  }
}
