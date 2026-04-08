import 'package:flutter/material.dart';

class CategoryBar extends StatelessWidget {
  final double shrinkOffset;
  const CategoryBar({super.key, required this.shrinkOffset});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.yellow,
      height: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(
              'Categories',
              style: TextStyle(
                fontSize: 20 * (1.0 - (shrinkOffset / 100.0).clamp(0.0, 1.0)),
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.start,
            ),
          ),
          SizedBox(height: 8 * (1.0 - (shrinkOffset / 100.0).clamp(0.0, 1.0))),
          SizedBox(
            height: 50,
            width: double.infinity,
            child: ListView.builder(
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 5.0, left: 5.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        'Category $index',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
              itemCount: 10,
              scrollDirection: .horizontal,
            ),
          ),
        ],
      ),
    );
  }
}
