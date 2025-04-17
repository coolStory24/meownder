import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/cat_repository.dart';
import '../../models/liked_cat.dart';

abstract class LikedCatsEvent {}

class LoadLikedCats extends LikedCatsEvent {}

class DeleteLikedCat extends LikedCatsEvent {
  final String catId;
  DeleteLikedCat(this.catId);
}

class FilterLikedCats extends LikedCatsEvent {
  final String? breed;
  FilterLikedCats(this.breed);
}

abstract class LikedCatsState {}

class LikedCatsLoading extends LikedCatsState {}

class LikedCatsLoaded extends LikedCatsState {
  final List<LikedCat> cats;
  final List<String> breeds;
  final String? selectedBreed;
  LikedCatsLoaded(this.cats, this.breeds, this.selectedBreed);
}

class LikedCatsError extends LikedCatsState {
  final String message;
  LikedCatsError(this.message);
}

class LikedCatsBloc extends Bloc<LikedCatsEvent, LikedCatsState> {
  final CatRepository _repository;

  LikedCatsBloc(this._repository) : super(LikedCatsLoading()) {
    on<LoadLikedCats>(_onLoadLikedCats);
    on<DeleteLikedCat>(_onDeleteLikedCat);
    on<FilterLikedCats>(_onFilterLikedCats);
  }

  Future<void> _onLoadLikedCats(
    LoadLikedCats event,
    Emitter<LikedCatsState> emit,
  ) async {
    emit(LikedCatsLoading());
    try {
      final cats = _repository.getLikedCats();
      final breeds = _repository.getBreeds();
      emit(LikedCatsLoaded(cats, breeds, null));
    } catch (e) {
      emit(LikedCatsError(e.toString()));
    }
  }

  Future<void> _onDeleteLikedCat(
    DeleteLikedCat event,
    Emitter<LikedCatsState> emit,
  ) async {
    _repository.removeLikedCat(event.catId);
    final cats = _repository.getLikedCats();
    final breeds = _repository.getBreeds();
    emit(LikedCatsLoaded(cats, breeds, null));
  }

  Future<void> _onFilterLikedCats(
    FilterLikedCats event,
    Emitter<LikedCatsState> emit,
  ) async {
    final cats = _repository.getLikedCats(breedFilter: event.breed);
    final breeds = _repository.getBreeds();
    emit(LikedCatsLoaded(cats, breeds, event.breed));
  }
}
