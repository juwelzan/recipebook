import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipebook/features/add_my_recipe_screen/model/local_recipe.dart';
import 'package:recipebook/features/user_profile_screen/provider/user_content_provider.dart';

class RecipeFormScreen extends StatefulWidget {
  final LocalRecipe? recipe;
  const RecipeFormScreen({super.key, this.recipe});

  @override
  State<RecipeFormScreen> createState() => _RecipeFormScreenState();
}

class _RecipeFormScreenState extends State<RecipeFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _description = TextEditingController();
  final _imageUrl = TextEditingController();
  final _cuisine = TextEditingController();
  final _mealType = TextEditingController();
  final _category = TextEditingController();
  final _preparation = TextEditingController();
  final _cooking = TextEditingController();
  final _servings = TextEditingController(text: '2');
  final _tags = TextEditingController();
  final _nutrition = TextEditingController();
  final _notes = TextEditingController();
  final List<_IngredientInput> _ingredients = [];
  final List<TextEditingController> _instructions = [];
  Timer? _draftTimer;
  bool _hydrated = false;
  bool _isSaving = false;
  bool _showDraftNotice = false;
  String _difficulty = 'Easy';
  String? _formError;

  @override
  void initState() {
    super.initState();
    for (final controller in _allControllers) {
      controller.addListener(_scheduleDraftSave);
    }
    if (widget.recipe != null) _populateRecipe(widget.recipe!);
  }

  List<TextEditingController> get _allControllers => [
    _name,
    _description,
    _imageUrl,
    _cuisine,
    _mealType,
    _category,
    _preparation,
    _cooking,
    _servings,
    _tags,
    _nutrition,
    _notes,
    ..._ingredients.expand((item) => [item.name, item.quantity, item.unit]),
    ..._instructions,
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_hydrated || widget.recipe != null) return;
    final state = context.read<UserContentProvider>();
    if (state.isLoading) return;
    _hydrated = true;
    final draft = state.draft;
    if (draft != null) {
      _populateDraft(draft);
      _showDraftNotice = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _showDraftNotice) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Your saved draft was restored.')),
          );
          setState(() => _showDraftNotice = false);
        }
      });
    } else {
      _addIngredient();
      _addInstruction();
    }
  }

  void _populateRecipe(LocalRecipe recipe) {
    _name.text = recipe.name;
    _description.text = recipe.description;
    _imageUrl.text = recipe.imageUrl;
    _cuisine.text = recipe.cuisine;
    _mealType.text = recipe.mealType;
    _category.text = recipe.category;
    _preparation.text = recipe.preparationMinutes == 0
        ? ''
        : '${recipe.preparationMinutes}';
    _cooking.text = recipe.cookingMinutes == 0
        ? ''
        : '${recipe.cookingMinutes}';
    _servings.text = '${recipe.servings}';
    _difficulty = recipe.difficulty;
    _tags.text = recipe.tags.join(', ');
    _nutrition.text = recipe.nutrition;
    _notes.text = recipe.notes;
    for (final ingredient in recipe.ingredients) {
      _ingredients.add(
        _IngredientInput.fromIngredient(ingredient, _scheduleDraftSave),
      );
    }
    for (final step in recipe.instructions) {
      final controller = TextEditingController(text: step)
        ..addListener(_scheduleDraftSave);
      _instructions.add(controller);
    }
    if (_ingredients.isEmpty) _addIngredient();
    if (_instructions.isEmpty) _addInstruction();
  }

  void _populateDraft(Map<String, dynamic> draft) {
    _name.text = draft['name'] as String? ?? '';
    _description.text = draft['description'] as String? ?? '';
    _imageUrl.text = draft['imageUrl'] as String? ?? '';
    _cuisine.text = draft['cuisine'] as String? ?? '';
    _mealType.text = draft['mealType'] as String? ?? '';
    _category.text = draft['category'] as String? ?? '';
    _preparation.text = draft['preparation'] as String? ?? '';
    _cooking.text = draft['cooking'] as String? ?? '';
    _servings.text = draft['servings'] as String? ?? '2';
    _difficulty = draft['difficulty'] as String? ?? 'Easy';
    _tags.text = draft['tags'] as String? ?? '';
    _nutrition.text = draft['nutrition'] as String? ?? '';
    _notes.text = draft['notes'] as String? ?? '';
    for (final raw in (draft['ingredients'] as List? ?? const [])) {
      if (raw is Map) {
        _ingredients.add(
          _IngredientInput(
            nameText: raw['name'] as String? ?? '',
            quantityText: raw['quantity'] as String? ?? '',
            unitText: raw['unit'] as String? ?? '',
            onChanged: _scheduleDraftSave,
          ),
        );
      }
    }
    for (final raw in (draft['instructions'] as List? ?? const [])) {
      final controller = TextEditingController(text: raw is String ? raw : '')
        ..addListener(_scheduleDraftSave);
      _instructions.add(controller);
    }
    if (_ingredients.isEmpty) _addIngredient();
    if (_instructions.isEmpty) _addInstruction();
  }

  void _scheduleDraftSave() {
    if (!_hydrated || widget.recipe != null) return;
    _draftTimer?.cancel();
    _draftTimer = Timer(const Duration(milliseconds: 600), () async {
      try {
        await context.read<UserContentProvider>().saveDraft(_draftMap());
      } catch (_) {
        // Keep the editor usable; the entered values remain in the form.
      }
    });
  }

  Map<String, dynamic> _draftMap() => {
    'name': _name.text,
    'description': _description.text,
    'imageUrl': _imageUrl.text,
    'cuisine': _cuisine.text,
    'mealType': _mealType.text,
    'category': _category.text,
    'preparation': _preparation.text,
    'cooking': _cooking.text,
    'servings': _servings.text,
    'difficulty': _difficulty,
    'tags': _tags.text,
    'nutrition': _nutrition.text,
    'notes': _notes.text,
    'ingredients': _ingredients
        .map(
          (item) => {
            'name': item.name.text,
            'quantity': item.quantity.text,
            'unit': item.unit.text,
          },
        )
        .toList(),
    'instructions': _instructions.map((item) => item.text).toList(),
  };

  void _addIngredient() => setState(() {
    _ingredients.add(_IngredientInput(onChanged: _scheduleDraftSave));
    _scheduleDraftSave();
  });

  void _addInstruction() => setState(() {
    final controller = TextEditingController()..addListener(_scheduleDraftSave);
    _instructions.add(controller);
    _scheduleDraftSave();
  });

  @override
  void dispose() {
    _draftTimer?.cancel();
    for (final controller in [
      _name,
      _description,
      _imageUrl,
      _cuisine,
      _mealType,
      _category,
      _preparation,
      _cooking,
      _servings,
      _tags,
      _nutrition,
      _notes,
    ]) {
      controller.dispose();
    }
    for (final item in _ingredients) {
      item.dispose();
    }
    for (final item in _instructions) {
      item.dispose();
    }
    super.dispose();
  }

  String? _required(String? value, String label) =>
      value == null || value.trim().isEmpty ? '$label is required.' : null;

  String? _optionalUrl(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final uri = Uri.tryParse(value.trim());
    if (uri == null ||
        !uri.hasAuthority ||
        !['http', 'https'].contains(uri.scheme)) {
      return 'Enter a valid http or https image URL.';
    }
    return null;
  }

  String? _positiveInt(
    String? value,
    String label, {
    bool required = false,
    int max = 1440,
  }) {
    if ((value == null || value.trim().isEmpty) && !required) return null;
    final number = int.tryParse(value ?? '');
    if (number == null || number < 1 || number > max) {
      return '$label must be between 1 and $max.';
    }
    return null;
  }

  void _move<T>(List<T> items, int from, int to) => setState(() {
    final item = items.removeAt(from);
    items.insert(to, item);
    _scheduleDraftSave();
  });

  Future<void> _save() async {
    FocusScope.of(context).unfocus();
    setState(() => _formError = null);
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final names = _ingredients
        .map((item) => item.name.text.trim().toLowerCase())
        .toList();
    if (names.isEmpty || names.any((name) => name.isEmpty)) {
      setState(() => _formError = 'Add a name for each ingredient.');
      return;
    }
    if (names.toSet().length != names.length) {
      setState(
        () => _formError = 'Remove duplicate ingredients before saving.',
      );
      return;
    }
    if (_instructions.isEmpty ||
        _instructions.any((step) => step.text.trim().isEmpty)) {
      setState(() => _formError = 'Add text to every instruction step.');
      return;
    }
    _draftTimer?.cancel();
    setState(() => _isSaving = true);
    try {
      final recipe = LocalRecipe(
        id:
            widget.recipe?.id ??
            'local-${DateTime.now().microsecondsSinceEpoch}',
        name: _name.text.trim(),
        description: _description.text.trim(),
        imageUrl: _imageUrl.text.trim(),
        cuisine: _cuisine.text.trim(),
        mealType: _mealType.text.trim(),
        category: _category.text.trim(),
        preparationMinutes: int.tryParse(_preparation.text) ?? 0,
        cookingMinutes: int.tryParse(_cooking.text) ?? 0,
        servings: int.parse(_servings.text),
        difficulty: _difficulty,
        ingredients: _ingredients
            .map(
              (item) => RecipeIngredient(
                name: item.name.text.trim(),
                quantity: item.quantity.text.trim(),
                unit: item.unit.text.trim(),
              ),
            )
            .toList(),
        instructions: _instructions.map((step) => step.text.trim()).toList(),
        tags: _tags.text
            .split(',')
            .map((tag) => tag.trim())
            .where((tag) => tag.isNotEmpty)
            .toSet()
            .toList(),
        nutrition: _nutrition.text.trim(),
        notes: _notes.text.trim(),
        updatedAt: DateTime.now(),
      );
      await context.read<UserContentProvider>().saveRecipe(recipe);
      if (!mounted) return;
      final messenger = ScaffoldMessenger.of(context);
      Navigator.pop(context);
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            widget.recipe == null
                ? 'Recipe saved to My Recipes.'
                : 'Recipe updated.',
          ),
        ),
      );
    } catch (_) {
      if (mounted) {
        setState(
          () => _formError =
              'Could not save your recipe. Your entries are still here; please retry.',
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final content = context.watch<UserContentProvider>();
    if (content.isLoading && widget.recipe == null && !_hydrated) {
      return Scaffold(
        appBar: AppBar(title: const Text('Create Recipe')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    final title = widget.recipe == null ? 'Create Recipe' : 'Edit Recipe';
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: FilledButton.icon(
            onPressed: _isSaving ? null : _save,
            icon: _isSaving
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.save_outlined),
            label: Text(
              _isSaving
                  ? 'Saving…'
                  : widget.recipe == null
                  ? 'Save Recipe'
                  : 'Save Changes',
            ),
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
            ),
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          children: [
            _section('Recipe basics'),
            TextFormField(
              controller: _name,
              maxLength: 90,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Recipe name *',
                border: OutlineInputBorder(),
              ),
              validator: (value) => _required(value, 'Recipe name'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _description,
              maxLength: 500,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Description',
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _imageUrl,
              keyboardType: TextInputType.url,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                labelText: 'Image URL (optional)',
                hintText: 'https://…',
                prefixIcon: Icon(Icons.image_outlined),
                border: OutlineInputBorder(),
              ),
              validator: _optionalUrl,
            ),
            if (_imageUrl.text.trim().isNotEmpty &&
                _optionalUrl(_imageUrl.text) == null) ...[
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  height: 170,
                  child: CachedNetworkImage(
                    imageUrl: _imageUrl.text.trim(),
                    fit: BoxFit.cover,
                    width: double.infinity,
                    placeholder: (_, _) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (_, _, _) => const Center(
                      child: Text('Image could not be loaded. Check the URL.'),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () {
                    _imageUrl.clear();
                    setState(() {});
                  },
                  icon: const Icon(Icons.close),
                  label: const Text('Remove image'),
                ),
              ),
            ],
            const SizedBox(height: 14),
            _section('Recipe details'),
            Row(
              children: [
                Expanded(child: _textField(_cuisine, 'Cuisine')),
                const SizedBox(width: 10),
                Expanded(child: _textField(_mealType, 'Meal type')),
              ],
            ),
            const SizedBox(height: 12),
            _textField(_category, 'Category'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _numberField(
                    _preparation,
                    'Prep (min)',
                    required: false,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _numberField(_cooking, 'Cook (min)', required: false),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _numberField(_servings, 'Servings', required: true),
                ),
              ],
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _difficulty,
              decoration: const InputDecoration(
                labelText: 'Difficulty',
                border: OutlineInputBorder(),
              ),
              items: const ['Easy', 'Medium', 'Hard']
                  .map(
                    (value) =>
                        DropdownMenuItem(value: value, child: Text(value)),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) setState(() => _difficulty = value);
                _scheduleDraftSave();
              },
            ),
            const SizedBox(height: 20),
            _section('Ingredients'),
            const Text('Add quantity and unit if you know them.'),
            const SizedBox(height: 8),
            ..._ingredients.indexed.map(
              (entry) => _ingredientRow(entry.$1, entry.$2),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: _addIngredient,
                icon: const Icon(Icons.add),
                label: const Text('Add ingredient'),
              ),
            ),
            const SizedBox(height: 12),
            _section('Instructions'),
            ..._instructions.indexed.map(
              (entry) => _instructionRow(entry.$1, entry.$2),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: _addInstruction,
                icon: const Icon(Icons.add),
                label: const Text('Add step'),
              ),
            ),
            const SizedBox(height: 12),
            _section('More information'),
            TextFormField(
              controller: _tags,
              maxLength: 200,
              decoration: const InputDecoration(
                labelText: 'Tags',
                hintText: 'quick, family favourite',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _nutrition,
              maxLength: 300,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Nutrition (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _notes,
              maxLength: 500,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Private notes',
                border: OutlineInputBorder(),
              ),
            ),
            if (_formError != null) ...[
              const SizedBox(height: 12),
              Text(
                _formError!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _ingredientRow(int index, _IngredientInput item) => Card(
    key: ObjectKey(item),
    margin: const EdgeInsets.symmetric(vertical: 5),
    child: Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          TextFormField(
            controller: item.name,
            maxLength: 80,
            decoration: InputDecoration(
              labelText: 'Ingredient ${index + 1} *',
              counterText: '',
              border: const OutlineInputBorder(),
            ),
            validator: (value) => _required(value, 'Ingredient'),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextField(
                  controller: item.quantity,
                  maxLength: 20,
                  decoration: const InputDecoration(
                    labelText: 'Quantity',
                    counterText: '',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: item.unit,
                  maxLength: 20,
                  decoration: const InputDecoration(
                    labelText: 'Unit',
                    counterText: '',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Move ingredient up',
                onPressed: index == 0
                    ? null
                    : () => _move(_ingredients, index, index - 1),
                icon: const Icon(Icons.arrow_upward),
              ),
              IconButton(
                tooltip: 'Move ingredient down',
                onPressed: index == _ingredients.length - 1
                    ? null
                    : () => _move(_ingredients, index, index + 1),
                icon: const Icon(Icons.arrow_downward),
              ),
              IconButton(
                tooltip: 'Remove ingredient',
                onPressed: () {
                  setState(() {
                    item.dispose();
                    _ingredients.removeAt(index);
                  });
                  _scheduleDraftSave();
                },
                icon: const Icon(Icons.delete_outline),
              ),
            ],
          ),
        ],
      ),
    ),
  );

  Widget _instructionRow(int index, TextEditingController controller) => Card(
    key: ObjectKey(controller),
    margin: const EdgeInsets.symmetric(vertical: 5),
    child: Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: CircleAvatar(
              radius: 14,
              child: Text('${index + 1}', style: const TextStyle(fontSize: 12)),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextFormField(
              controller: controller,
              maxLength: 400,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Instruction *',
                counterText: '',
                border: OutlineInputBorder(),
              ),
              validator: (value) => _required(value, 'Instruction'),
            ),
          ),
          Column(
            children: [
              IconButton(
                tooltip: 'Move step up',
                onPressed: index == 0
                    ? null
                    : () => _move(_instructions, index, index - 1),
                icon: const Icon(Icons.arrow_upward),
              ),
              IconButton(
                tooltip: 'Move step down',
                onPressed: index == _instructions.length - 1
                    ? null
                    : () => _move(_instructions, index, index + 1),
                icon: const Icon(Icons.arrow_downward),
              ),
              IconButton(
                tooltip: 'Delete step',
                onPressed: () {
                  setState(() {
                    controller.dispose();
                    _instructions.removeAt(index);
                  });
                  _scheduleDraftSave();
                },
                icon: const Icon(Icons.delete_outline),
              ),
            ],
          ),
        ],
      ),
    ),
  );

  Widget _textField(TextEditingController controller, String label) =>
      TextFormField(
        controller: controller,
        maxLength: 60,
        textCapitalization: TextCapitalization.words,
        decoration: InputDecoration(
          labelText: label,
          counterText: '',
          border: const OutlineInputBorder(),
        ),
      );

  Widget _numberField(
    TextEditingController controller,
    String label, {
    required bool required,
  }) => TextFormField(
    controller: controller,
    keyboardType: TextInputType.number,
    maxLength: 4,
    decoration: InputDecoration(
      labelText: label,
      counterText: '',
      border: const OutlineInputBorder(),
    ),
    validator: (value) => _positiveInt(
      value,
      label,
      required: required,
      max: label == 'Servings' ? 100 : 1440,
    ),
  );

  Widget _section(String title) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
    ),
  );
}

class _IngredientInput {
  final TextEditingController name;
  final TextEditingController quantity;
  final TextEditingController unit;

  _IngredientInput({
    String nameText = '',
    String quantityText = '',
    String unitText = '',
    required VoidCallback onChanged,
  }) : name = TextEditingController(text: nameText),
       quantity = TextEditingController(text: quantityText),
       unit = TextEditingController(text: unitText) {
    name.addListener(onChanged);
    quantity.addListener(onChanged);
    unit.addListener(onChanged);
  }

  factory _IngredientInput.fromIngredient(
    RecipeIngredient item,
    VoidCallback onChanged,
  ) => _IngredientInput(
    nameText: item.name,
    quantityText: item.quantity,
    unitText: item.unit,
    onChanged: onChanged,
  );

  void dispose() {
    name.dispose();
    quantity.dispose();
    unit.dispose();
  }
}
