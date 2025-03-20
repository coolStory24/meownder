import 'package:flutter/material.dart';
import '../models/cat.dart';

class DetailScreen extends StatelessWidget {
  final Cat cat;

  const DetailScreen({super.key, required this.cat});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(cat.breedName)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              cat.url,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 300,
              errorBuilder:
                  (context, error, stackTrace) =>
                      Icon(Icons.error, size: 50, color: Color(0xFFFE3C72)),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cat.breedName,
                    style: TextStyle(
                      fontFamily: 'DancingScript',
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFFE3C72),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    cat.description,
                    style: TextStyle(
                      fontFamily: 'Arimo',
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
