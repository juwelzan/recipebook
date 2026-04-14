import 'package:flutter/material.dart';
import 'package:recipebook/core/model/recipe_model.dart';
import 'package:recipebook/features/prodact_details_screen/widgets/watch_videos_button.dart';
import 'package:recipebook/main.dart';

class DraggableSheetWidget extends StatelessWidget {
  final DraggableScrollableController? controller;
  final RecipeModel recipe;
  const DraggableSheetWidget({
    super.key,
    this.controller,
    required this.recipe,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.6,
      maxChildSize: 0.87,
      controller: controller ?? DraggableScrollableController(),

      builder: (context, scrollController) {
        return Container(
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black38,
                blurRadius: 100,
                offset: Offset(0, -10),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      children: [
                        Container(
                          height: 8,
                          width: 50,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        SizedBox(height: 20.h),
                        /////////////////////////
                        //product name and rating
                        ////////////////////////
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                recipe.title,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: .ellipsis,
                              ),
                            ),
                            Text(
                              '⭐ 4.5',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        ///////////////////////////////
                        //time, calories, difficulty
                        //////////////////////////////
                        Row(
                          children: [
                            Icon(Icons.schedule, color: Colors.grey[600]),
                            SizedBox(width: 8),
                            Text(
                              '20 min',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              height: 20,
                              width: 2,
                              color: Colors.grey[400],
                              margin: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                            ),

                            Text(
                              '250 kcal',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.fireplace_rounded),
                            Container(
                              height: 20,
                              width: 2,
                              color: Colors.grey[400],
                              margin: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                            ),
                            Text(
                              'Easy',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.check_circle),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        ///////////////////////////////
                        ///chef name and image
                        ///////////////////////////////
                        Row(
                          children: [
                            Icon(Icons.person),
                            SizedBox(width: 8),
                            Text(
                              'Chef John Doe',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        ///////////////////////////////
                        ///ingredients
                        ///////////////////////////////
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ingredients',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Row(
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.grey[300],
                                      ),
                                      child: const Icon(Icons.local_pizza),
                                    ),
                                    Text(
                                      'Pasta',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 20.w),
                                Column(
                                  children: [
                                    Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.grey[300],
                                      ),
                                      child: const Icon(Icons.egg),
                                    ),
                                    Text(
                                      'Eggs',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 20.w),
                                Column(
                                  children: [
                                    Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.grey[300],
                                      ),
                                      child: const Icon(Icons.local_dining),
                                    ),
                                    Text(
                                      'Cheese',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 20.w),
                                Column(
                                  children: [
                                    Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.grey[300],
                                      ),
                                      child: const Icon(Icons.local_cafe),
                                    ),
                                    Text(
                                      'Milk',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        ///////////////////////////////
                        ///description
                        ///////////////////////////////
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Description:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              'This is a delicious and easy-to-make dish that everyone will love. Perfect for a quick weeknight meal or a weekend treat. Made with simple ingredients and packed with flavor, it’s sure to become a family favorite. Enjoy the rich taste of cheese and the satisfying texture of pasta in every bite. Whether you’re a seasoned chef or a beginner in the kitchen, this recipe is a great choice for a tasty and comforting meal.',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: WatchVideosButton(),
              ),
            ],
          ),
        );
      },
    );
  }
}
