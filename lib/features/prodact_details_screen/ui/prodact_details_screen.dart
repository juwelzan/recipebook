import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipebook/core/model/recipe_model.dart';
import 'package:recipebook/core/service/api_service.dart';
import 'package:recipebook/features/prodact_details_screen/widgets/draggable_sheet_widget.dart';
import 'package:recipebook/shared/provider/shared_provider.dart';

class ProdactDetailsScreen extends StatefulWidget {
  final RecipeModel recipeModel;
  const ProdactDetailsScreen({super.key, required this.recipeModel});

  @override
  State<ProdactDetailsScreen> createState() => _ProdactDetailsScreenState();
}

class _ProdactDetailsScreenState extends State<ProdactDetailsScreen> {
  final DraggableScrollableController _controller =
      DraggableScrollableController();
  late RecipeModel _recipe = widget.recipeModel;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadDetails();
  }

  Future<void> _loadDetails() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      _recipe = await ApiService.getRecipeInformation(widget.recipeModel.id);
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Stack(
      children: [
        Positioned.fill(
          bottom: MediaQuery.sizeOf(context).height * .38,
          child: _recipe.image.isEmpty
              ? Container(
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.restaurant, size: 60),
                )
              : CachedNetworkImage(
                  imageUrl: _recipe.image,
                  fit: BoxFit.cover,
                  placeholder: (_, _) => Container(color: Colors.grey.shade200),
                  errorWidget: (_, _, _) => Container(
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.broken_image_outlined, size: 48),
                  ),
                ),
        ),
        DraggableSheetWidget(
          controller: _controller,
          recipe: _recipe,
          isLoading: _isLoading,
          errorMessage: _errorMessage,
          onRetry: _loadDetails,
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _roundButton(
                  context,
                  Icons.arrow_back,
                  'Back',
                  () => Navigator.maybePop(context),
                ),
                const Spacer(),
                Consumer<SharedProvider>(
                  builder: (context, saved, _) {
                    final isSaved = saved.isFavorite(widget.recipeModel.id);
                    return _roundButton(
                      context,
                      isSaved ? Icons.bookmark : Icons.bookmark_border,
                      isSaved ? 'Remove saved recipe' : 'Save recipe',
                      () => saved.toggleFavorite(_recipe),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );

  Widget _roundButton(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onPressed,
  ) => Material(
    color: Colors.white.withValues(alpha: .9),
    shape: const CircleBorder(),
    child: IconButton(tooltip: label, onPressed: onPressed, icon: Icon(icon)),
  );
}
