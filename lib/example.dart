import 'package:da_administrator/service/color.dart';
import 'package:flutter/material.dart';

class Rating extends StatefulWidget {
  const Rating({super.key});

  @override
  State<Rating> createState() => _RatingState();
}

class _RatingState extends State<Rating> {
  int rating = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Row(
            children: List.generate(
              3,
              (index) => const Icon(Icons.star, size: 100, color: Colors.grey),
            ),
          ),
          Row(
            children: List.generate(
              3,
              (index) => InkWell(
                onTap: () {
                  rating = index + 1;
                  print('ini value $rating');
                  setState(() {});
                },
                child: Icon(Icons.star, size: 100, color: (rating >= index + 1) ? secondary : Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
