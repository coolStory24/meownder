import 'cat.dart';

class LikedCat extends Cat {
  final DateTime likedAt;

  LikedCat({
    required super.id,
    required super.url,
    required super.breedName,
    required super.description,
    required this.likedAt,
  });
}
