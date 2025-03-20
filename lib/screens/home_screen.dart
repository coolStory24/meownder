import 'package:flutter/material.dart';
import '../services/cat_api_service.dart';
import '../widgets/like_button.dart';
import '../widgets/dislike_button.dart';
import 'detail_screen.dart';
import '../models/cat.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  Cat? currentCat;
  int likeCount = 0;
  bool isLoading = true;
  Offset _offset = Offset.zero;
  double _angle = 0;

  @override
  void initState() {
    super.initState();
    _loadNewCat();
  }

  void _loadNewCat() async {
    setState(() {
      isLoading = true;
      _offset = Offset.zero;
      _angle = 0;
    });
    try {
      final cat = await CatApiService().fetchRandomCat();
      setState(() {
        currentCat = cat;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  void _handlePanStart(DragStartDetails details) {}

  void _handlePanUpdate(DragUpdateDetails details) {
    if (isLoading) return;
    setState(() {
      _offset += details.delta;
      _angle = (_offset.dx / 500).clamp(-0.5, 0.5);
    });
  }

  void _handlePanEnd(DragEndDetails details) {
    if (isLoading) return;
    const double swipeThreshold = 100;
    if (_offset.dx.abs() > swipeThreshold) {
      if (_offset.dx > 0) {
        setState(() => likeCount++);
        _loadNewCat();
      } else {
        _loadNewCat();
      }
    } else {
      setState(() {
        _offset = Offset.zero;
        _angle = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Meownder')),
      body: Column(
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
              onPanUpdate: _handlePanUpdate,
              onPanEnd: _handlePanEnd,
              onTap:
                  isLoading || currentCat == null
                      ? null
                      : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => DetailScreen(cat: currentCat!),
                          ),
                        );
                      },
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
                      isLoading || currentCat == null
                          ? Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFFFE3C72),
                              ),
                            ),
                          )
                          : Column(
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(16),
                                  ),
                                  child: Image.network(
                                    currentCat!.url,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    loadingBuilder: (
                                      context,
                                      child,
                                      loadingProgress,
                                    ) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Color(0xFFFE3C72),
                                              ),
                                        ),
                                      );
                                    },
                                    errorBuilder: (context, error, stackTrace) {
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
                                  currentCat!.breedName,
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
                          ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LikeButton(
                  onPressed: () {
                    if (isLoading || currentCat == null) return;

                    setState(() => likeCount++);
                    _loadNewCat();
                  },
                ),
                DislikeButton(
                  onPressed: () {
                    if (isLoading || currentCat == null) return;

                    _loadNewCat();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
