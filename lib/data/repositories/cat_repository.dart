import '../../models/liked_cat.dart';
import '../../models/cat.dart';
import '../../services/cat_api_service.dart';

class CatRepository {
  final CatApiService _apiService;
  final List<LikedCat> _likedCats = [];

  CatRepository(this._apiService);

  Future<Cat> fetchRandomCat() => _apiService.fetchRandomCat();

  void addLikedCat(Cat cat) {
    _likedCats.add(
      LikedCat(
        id: cat.id,
        url: cat.url,
        breedName: cat.breedName,
        description: cat.description,
        likedAt: DateTime.now(),
      ),
    );
  }

  void removeLikedCat(String id) {
    _likedCats.removeWhere((cat) => cat.id == id);
  }

  List<LikedCat> getLikedCats({String? breedFilter}) {
    if (breedFilter == null || breedFilter.isEmpty) return _likedCats;
    return _likedCats
        .where(
          (cat) =>
              cat.breedName.toLowerCase().contains(breedFilter.toLowerCase()),
        )
        .toList();
  }

  List<String> getBreeds() {
    return _likedCats.map((cat) => cat.breedName).toSet().toList()..sort();
  }
}
