import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/home/home_bloc.dart';
import '../widgets/like_button.dart';
import '../widgets/dislike_button.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  Offset _offset = Offset.zero;
  double _angle = 0;

  void _handlePanStart(DragStartDetails details) {
    _offset = Offset.zero;
    _angle = 0;
  }

  void _handlePanUpdate(DragUpdateDetails details, bool isLoading) {
    if (isLoading) return;
    setState(() {
      _offset += details.delta;
      _angle = (_offset.dx / 500).clamp(-0.5, 0.5);
    });
  }

  void _handlePanEnd(
    DragEndDetails details,
    BuildContext context,
    bool isLoading,
  ) {
    if (isLoading) return;
    const double swipeThreshold = 100;
    if (_offset.dx.abs() > swipeThreshold) {
      if (_offset.dx > 0) {
        context.read<HomeBloc>().add(LikeCat());
      } else {
        context.read<HomeBloc>().add(DislikeCat());
      }
    }
    setState(() {
      _offset = Offset.zero;
      _angle = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meownder'),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () => Navigator.pushNamed(context, '/liked'),
          ),
        ],
      ),
      body: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is HomeError) {
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
                          context.read<HomeBloc>().add(FetchNewCat());
                        },
                        child: Text('Retry'),
                      ),
                    ],
                  ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is HomeLoading;
          final likeCount =
              state is HomeLoaded
                  ? state.likeCount
                  : (state is HomeLoading ? state.likeCount : 0);
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Likes: $likeCount',
                  style: TextStyle(
                    fontFamily: 'DancingScript',
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                    color: Color(0xFFFE3C72),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onPanStart: _handlePanStart,
                  onPanUpdate:
                      (details) => _handlePanUpdate(details, isLoading),
                  onPanEnd:
                      (details) => _handlePanEnd(details, context, isLoading),
                  onTap:
                      state is HomeLoaded
                          ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => DetailScreen(
                                      cat: (state as HomeLoaded).cat,
                                    ),
                              ),
                            );
                          }
                          : null,
                  child: Transform(
                    transform:
                        Matrix4.identity()
                          ..translate(_offset.dx, _offset.dy)
                          ..rotateZ(_angle),
                    alignment: Alignment.center,
                    child: Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      margin: EdgeInsets.all(16),
                      child:
                          isLoading
                              ? Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xFFFE3C72),
                                  ),
                                ),
                              )
                              : state is HomeLoaded
                              ? Column(
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(16),
                                      ),
                                      child: Image.network(
                                        (state as HomeLoaded).cat.url,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        loadingBuilder: (
                                          context,
                                          child,
                                          loadingProgress,
                                        ) {
                                          if (loadingProgress == null)
                                            return child;
                                          return Center(
                                            child: CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                    Color(0xFFFE3C72),
                                                  ),
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
                                            size: 50,
                                            color: Color(0xFFFE3C72),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Color(0xFFFE3C72),
                                          Color(0xFFFF758C),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.vertical(
                                        bottom: Radius.circular(16),
                                      ),
                                    ),
                                    child: Text(
                                      (state as HomeLoaded).cat.breedName,
                                      style: TextStyle(
                                        fontFamily: 'DancingScript',
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              )
                              : Center(child: Text('No cat available')),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DislikeButton(
                      onPressed: () {
                        if (state is HomeLoaded) {
                          context.read<HomeBloc>().add(DislikeCat());
                        }
                      },
                    ),
                    LikeButton(
                      onPressed: () {
                        if (state is HomeLoaded) {
                          context.read<HomeBloc>().add(LikeCat());
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
