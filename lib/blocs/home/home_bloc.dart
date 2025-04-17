import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/cat_repository.dart';
import '../../models/cat.dart';

abstract class HomeEvent {}

class FetchNewCat extends HomeEvent {}

class LikeCat extends HomeEvent {}

class DislikeCat extends HomeEvent {}

abstract class HomeState {
  final int likeCount;
  HomeState(this.likeCount);
}

class HomeLoading extends HomeState {
  HomeLoading({required int likeCount}) : super(likeCount);
}

class HomeLoaded extends HomeState {
  final Cat cat;
  HomeLoaded(this.cat, int likeCount) : super(likeCount);
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message, {required int likeCount}) : super(likeCount);
}

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final CatRepository _repository;
  int _likeCount = 0;

  HomeBloc(this._repository) : super(HomeLoading(likeCount: 0)) {
    on<FetchNewCat>(_onFetchNewCat);
    on<LikeCat>(_onLikeCat);
    on<DislikeCat>(_onDislikeCat);
  }

  Future<void> _onFetchNewCat(
    FetchNewCat event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading(likeCount: _likeCount));
    try {
      final cat = await _repository.fetchRandomCat();
      emit(HomeLoaded(cat, _likeCount));
    } catch (e) {
      emit(HomeError(e.toString(), likeCount: _likeCount));
    }
  }

  Future<void> _onLikeCat(LikeCat event, Emitter<HomeState> emit) async {
    if (state is HomeLoaded) {
      final cat = (state as HomeLoaded).cat;
      _repository.addLikedCat(cat);
      _likeCount++;
      add(FetchNewCat());
    }
  }

  Future<void> _onDislikeCat(DislikeCat event, Emitter<HomeState> emit) async {
    add(FetchNewCat());
  }
}
