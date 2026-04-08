import 'package:flutter/material.dart';

class ProductDetailsStackPage extends StatefulWidget {
  const ProductDetailsStackPage({super.key});

  @override
  State<ProductDetailsStackPage> createState() =>
      _ProductDetailsStackPageState();
}

class _ProductDetailsStackPageState extends State<ProductDetailsStackPage> {
  ScrollController scrollController = ScrollController();
  double offset = 0;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      setState(() {
        offset = scrollController.offset;
        if (offset > 200) offset = 200; // max offset
      });
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double containerTop = 250 - offset; // scroll অনুযায়ী move হবে

    return Scaffold(
      body: Stack(
        children: [
          // Product Image
          SizedBox(
            height: 300,
            width: double.infinity,
            child: Image.network(
              'https://picsum.photos/400/300',
              fit: BoxFit.cover,
            ),
          ),

          // Scrollable Content
          SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                SizedBox(height: 250), // image height
                Container(height: 800, color: Colors.transparent),
              ],
            ),
          ),

          // Product Details Container
          Positioned(
            top: containerTop,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Product Name',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Product description goes here...',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 300), // extra space for scrolling
                ],
              ),
            ),
          ),

          // AppBar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: BackButton(),
              actions: [IconButton(onPressed: () {}, icon: Icon(Icons.save))],
            ),
          ),
        ],
      ),
    );
  }
}
