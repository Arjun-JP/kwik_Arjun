import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:kwik/bloc/Search_bloc/search_event.dart';
import 'package:kwik/bloc/Search_bloc/search_state.dart';
import 'package:kwik/models/product_model.dart';
import 'package:kwik/repositories/search_repo.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchRepo repository;
  final Box box = Hive.box('search_productCache');
  final Box searchHistoryBox = Hive.box('search_history');

  SearchBloc({required this.repository}) : super(ProductInitial()) {
    on<SearchProducts>((event, emit) async {
      emit(ProductLoading());
      try {
        final products = await repository.searchProducts(
            event.query, event.userId, event.page, event.size);

        // Get previous search history from Hive
        List<String> searchHistory =
            searchHistoryBox.get('history', defaultValue: [])?.cast<String>() ??
                [];

        // Add the new search query if it's not a duplicate
        if (!searchHistory.contains(event.query)) {
          searchHistory.add(event.query);
          searchHistoryBox.put('history', searchHistory);
        }

        emit(ProductLoaded(
            products: products["products"] as List<ProductModel>,
            searchHistory: searchHistory));
      } catch (_) {
        emit(ProductError());
      }
    });

    on<LoadInitialProducts>((event, emit) async {
      emit(ProductLoading());
      try {
        List<String> searchHistory =
            searchHistoryBox.get('history', defaultValue: [])?.cast<String>() ??
                [];
        print(searchHistory);
        print("cache");
        if (box.containsKey('initialProducts')) {
          List<ProductModel> cachedProducts =
              (jsonDecode(box.get('initialProducts')) as List)
                  .map((data) => ProductModel.fromJson(data))
                  .toList();

          emit(ProductLoaded(
              products: cachedProducts, searchHistory: searchHistory));
        } else {
          final products = await repository.getInitialProducts();
          List<String> apiSearchHistory =
              List<String>.from(products["searchHistory"]);
          box.put('initialProducts',
              jsonEncode(products["products"].map((p) => p.toJson()).toList()));
          searchHistoryBox.put('history', apiSearchHistory);
          emit(ProductLoaded(
              products: products["products"], searchHistory: apiSearchHistory));
        }
      } catch (_) {
        emit(ProductError());
      }
    });

    on<ClearCachesearch>((event, emit) async {
      await box.delete('search_productCache');
      await searchHistoryBox.delete('history'); // Clear search history
      emit(ProductInitial());
    });
  }
}
