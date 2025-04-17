import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/liked_cats/liked_cats_bloc.dart';
import '../data/repositories/cat_repository.dart';
import '../di.dart';
import 'detail_screen.dart';
import 'package:intl/intl.dart';

class LikedCatsScreen extends StatelessWidget {
  const LikedCatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              LikedCatsBloc(getIt<CatRepository>())..add(LoadLikedCats()),
      child: Scaffold(
        appBar: AppBar(title: Text('Liked Cats')),
        body: BlocConsumer<LikedCatsBloc, LikedCatsState>(
          listener: (context, state) {
            if (state is LikedCatsError) {
              showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: Text('Error'),
                      content: Text(state.message),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            context.read<LikedCatsBloc>().add(LoadLikedCats());
                          },
                          child: Text('Retry'),
                        ),
                      ],
                    ),
              );
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                if (state is LikedCatsLoaded && state.breeds.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: DropdownButton<String>(
                      hint: Text('Filter by Breed'),
                      value: state.selectedBreed,
                      isExpanded: true,
                      items: [
                        DropdownMenuItem<String>(
                          value: null,
                          child: Text('All Breeds'),
                        ),
                        ...state.breeds.map(
                          (breed) => DropdownMenuItem<String>(
                            value: breed,
                            child: Text(breed),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        context.read<LikedCatsBloc>().add(
                          FilterLikedCats(value),
                        );
                      },
                    ),
                  ),
                Expanded(
                  child:
                      state is LikedCatsLoading
                          ? Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFFFE3C72),
                              ),
                            ),
                          )
                          : state is LikedCatsLoaded
                          ? state.cats.isEmpty
                              ? Center(child: Text('No liked cats yet'))
                              : ListView.builder(
                                itemCount: state.cats.length,
                                itemBuilder: (context, index) {
                                  final cat = state.cats[index];
                                  return Dismissible(
                                    key: Key(cat.id),
                                    direction: DismissDirection.endToStart,
                                    onDismissed: (direction) {
                                      context.read<LikedCatsBloc>().add(
                                        DeleteLikedCat(cat.id),
                                      );
                                    },
                                    background: Container(
                                      color: Colors.red,
                                      alignment: Alignment.centerRight,
                                      padding: EdgeInsets.only(right: 16.0),
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                      ),
                                    ),
                                    child: ListTile(
                                      leading: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          cat.url,
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.cover,
                                          loadingBuilder: (
                                            context,
                                            child,
                                            loadingProgress,
                                          ) {
                                            if (loadingProgress == null) {
                                              return child;
                                            }
                                            return CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                    Color(0xFFFE3C72),
                                                  ),
                                            );
                                          },
                                          errorBuilder: (
                                            context,
                                            error,
                                            stackTrace,
                                          ) {
                                            return Icon(
                                              Icons.error,
                                              color: Color(0xFFFE3C72),
                                            );
                                          },
                                        ),
                                      ),
                                      title: Text(cat.breedName),
                                      subtitle: Text(
                                        'Liked on ${DateFormat.yMMMd().format(cat.likedAt)}',
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) =>
                                                    DetailScreen(cat: cat),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                              )
                          : Center(child: Text('Something went wrong')),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
