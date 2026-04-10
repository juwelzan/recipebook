import 'package:flutter/material.dart';
import 'package:recipebook/main.dart';
import 'package:recipebook/shared/widgets/circle_blaur_button.dart';

class ProductWidgetListtile extends StatelessWidget {
  const ProductWidgetListtile({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: double.infinity,

      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              height: double.infinity,
              width: 100.w,
              color: Colors.grey[400],
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recipe Title',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    CircleBlaurButton(
                      child: Icon(Icons.favorite_border, size: 20),
                    ),
                  ],
                ),
                Text(
                  '⭐ 4.5 (200 reviews)',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                Text(
                  "By Chef's Name",
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
