// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:recipebook/features/prodact_details_screen/widgets/draggable_sheet_widget.dart';
import 'package:recipebook/main.dart';
import 'package:recipebook/shared/widgets/circle_blaur_button.dart';

class ProdactDetailsScreen extends StatefulWidget {
  const ProdactDetailsScreen({super.key});

  @override
  State<ProdactDetailsScreen> createState() => _ProdactDetailsScreenState();
}

class _ProdactDetailsScreenState extends State<ProdactDetailsScreen> {
  late DraggableScrollableController _controller;
  double _currentSize = 0.6;
  @override
  void initState() {
    _controller = DraggableScrollableController();
    _controller.addListener(() {
      setState(() {
        _currentSize = _controller.size;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: _currentSize.clamp(0.6, 0.8) * 650,
            width: double.infinity,
            child: Image.network(
              'https://picsum.photos/400/300',
              fit: BoxFit.cover,
            ),
          ),
          DraggableSheetWidget(controller: _controller),
          Positioned(
            left: 0,
            right: 0,
            top: 50,
            child: Row(
              children: [
                SizedBox(width: 20.w),
                CircleBlaurButton(child: const Icon(Icons.arrow_back)),
                const Spacer(),
                CircleBlaurButton(child: const Icon(Icons.bookmark)),
                SizedBox(width: 20.w),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
