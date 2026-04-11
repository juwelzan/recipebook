import 'package:flutter/material.dart';
import 'package:recipebook/shared/widgets/circle_blaur_button.dart';

class ProductWidgetBox extends StatelessWidget {
  const ProductWidgetBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,

      color: Colors.transparent,
      child: Stack(
        children: [
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: 130,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Image.network(
                      'https://images.unsplash.com/photo-1504674900247-0877df9cc836?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cmVjaXBlJTIwZGF5fGVufDB8fDB8fHww&auto=format&fit=crop&w=500&q=60',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Recipe Name',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "By : Author Name",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const Positioned(
            top: 8,
            left: 10,
            right: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleBlaurButton(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Text(
                    '⭐ 4.5',
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ),
                CircleBlaurButton(child: Icon(Icons.share)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
