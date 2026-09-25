# Recipe Book

A Flutter recipe browser with Spoonacular search and recipe details, plus locally managed recipes, favorites, and profile information.

## Features and screens


## 📱 Screenshots

<div align="center">

<img src="https://raw.githubusercontent.com/juwelzan/screenshot/main/recipebook%20/Screenshot%20iPhone%2018%20Pro%2025-09-2026%20at%204.30.19%20PM.png" width="190" alt="RecipeBook Screenshot 1">

<img src="https://raw.githubusercontent.com/juwelzan/screenshot/main/recipebook%20/Screenshot%20iPhone%2018%20Pro%2025-09-2026%20at%204.30.26%20PM.png" width="190" alt="RecipeBook Screenshot 2">

<img src="https://raw.githubusercontent.com/juwelzan/screenshot/main/recipebook%20/Screenshot%20iPhone%2018%20Pro%2025-09-2026%20at%204.30.35%20PM.png" width="190" alt="RecipeBook Screenshot 3">

<img src="https://raw.githubusercontent.com/juwelzan/screenshot/main/recipebook%20/Screenshot%20iPhone%2018%20Pro%2025-09-2026%20at%204.30.41%20PM.png" width="190" alt="RecipeBook Screenshot 4">

<img src="https://raw.githubusercontent.com/juwelzan/screenshot/main/recipebook%20/Screenshot%20iPhone%2018%20Pro%2025-09-2026%20at%204.30.48%20PM.png" width="190" alt="RecipeBook Screenshot 5">

<img src="https://raw.githubusercontent.com/juwelzan/screenshot/main/recipebook%20/Screenshot%20iPhone%2018%20Pro%2025-09-2026%20at%204.31.35%20PM.png" width="190" alt="RecipeBook Screenshot 6">

<img src="https://raw.githubusercontent.com/juwelzan/screenshot/main/recipebook%20/Screenshot%20iPhone%2018%20Pro%2025-09-2026%20at%204.31.50%20PM.png" width="190" alt="RecipeBook Screenshot 7">

</div>



- **Home:** search recipes, select vegetarian, vegan, gluten-free, and ketogenic diet filters, browse the first five cards in Popular Recipes, and page through search results in batches of ten.
- **Recipe details:** show the image and API-provided ready time, ingredients, instructions, cuisine, meal type, servings, and health score when available.
- **Favorites:** save or remove Spoonacular recipes. Favorites persist locally across app restarts.
- **My Recipes:** create, view, edit, and delete recipes stored on this device. The editor supports description, image URL, cuisine, meal type, category, prep/cook time, servings, difficulty, tags, nutrition text, and private notes. Ingredients have quantity and unit fields and can be reordered; instruction steps can also be reordered. The form validates required fields, numeric values, image URLs, empty steps, and duplicate ingredient names. An unfinished new recipe is auto-saved as a local draft.
- **Profile:** save a name, email, bio, and profile image URL locally. Recipe and favorites counts are calculated from the current local state. The About dialog describes the app.

Profile details and user-created recipes are local-only: there is no account, authentication, cloud sync, or logout flow. User recipe images are entered as URLs; gallery upload is not implemented. Favorites contain Spoonacular recipes and use a separate model from user-created recipes.

## API integration

- **Provider:** Spoonacular Food API
- **Base URL:** `https://api.spoonacular.com/recipes`
- **Search:** `GET /complexSearch` with `query`, `diet`, `offset`, and `number` parameters. Each request asks for recipe information and returns at most ten results. Search input is debounced; Load more requests the next offset.
- **Details:** `GET /{id}/information` when a user opens an API recipe.
- Search results and recipe details are parsed into `RecipeModel`. The model reads available images, timing, servings, health score, cuisines, meal types, diets, ingredients, and instructions. Optional API fields may be absent.
- HTTP calls use a 20-second timeout. Network failures, non-success status codes, invalid JSON, and malformed response structures produce app-level errors and retry actions.
- The API does not store user-created recipes; those are persisted separately on-device.

Spoonacular documents other capabilities including ingredient-based search, nutrient-based search, random recipes, and autocomplete. They are not currently wired into the app. See the [Spoonacular API documentation](https://spoonacular.com/food-api/docs), [complex recipe search](https://spoonacular.com/food-api/docs#Search-Recipes-Complex), and [recipe information](https://spoonacular.com/food-api/docs#Get-Recipe-Information).

## API key configuration

Set a valid Spoonacular API key at build/run time:

```sh
flutter run --dart-define=SPOONACULAR_API_KEY=YOUR_API_KEY
```

Pass the same define to builds that need live API access, for example:

```sh
flutter build apk --debug --dart-define=SPOONACULAR_API_KEY=YOUR_API_KEY
```

The previous key was present in the repository source. Revoke or rotate it with Spoonacular before use. A Dart define avoids committing a key in source, but the value is still embedded in a distributed client and can be extracted. A production app should call Spoonacular through a backend that protects and rate-limits the key. With no key configured, local recipes, favorites, and profile data remain available; API-backed screens show a configuration error.

## Architecture and project structure

Provider is used for app state. API requests flow through `ApiService` and `ApiColler`; local recipes and profile data use `UserContentProvider`; API favorites use `SharedProvider`. `SharedPreferences` stores local JSON/string-list data. Network images use `cached_network_image`.

```text
lib/
├── app_config.dart
├── main.dart
├── core/
│   ├── api/                 # HTTP client and API exceptions
│   ├── assets/              # SVG and Lottie asset references
│   ├── constant/            # Spoonacular URL and runtime key config
│   ├── model/               # API recipe model
│   └── service/             # API request and response parsing
├── features/
│   ├── add_my_recipe_screen/
│   │   ├── model/           # User-created local recipe model
│   │   └── ui/              # Collection, editor, and local details
│   ├── home_screen/         # Home, search, categories, recipe cards
│   ├── main_screen/         # Bottom navigation and selected tab state
│   ├── prodact_details_screen/ # Spoonacular recipe details
│   ├── save_recipe_screen/  # Favorites
│   └── user_profile_screen/
│       ├── model/
│       ├── provider/        # Local recipes, profile, and draft state
│       └── ui/
└── shared/
    ├── effect/
    ├── provider/            # API recipe favorites
    └── widgets/
test/
├── recipe_model_test.dart
└── user_content_provider_test.dart
```

## Installation and development

Requirements: Flutter/Dart compatible with the SDK constraint in `pubspec.yaml` (`^3.11.0`), plus the Android or iOS toolchain for the platform you are building.

```sh
flutter pub get
flutter run --dart-define=SPOONACULAR_API_KEY=YOUR_API_KEY
```

Useful checks:

```sh
flutter analyze
flutter test
flutter build apk --debug --dart-define=SPOONACULAR_API_KEY=YOUR_API_KEY
flutter build ios --no-codesign --dart-define=SPOONACULAR_API_KEY=YOUR_API_KEY
```

Release signing is not configured for distribution. The Android release build currently uses the debug signing configuration and must be changed before publishing. iOS deployment target and plugin integration are defined in the Xcode project.

## Dependencies

Runtime packages are Provider, Equatable, `http`, SharedPreferences, `cached_network_image`, `flutter_svg`, and Lottie. Flutter's Material icons are used. No additional image picker, database, authentication, or state-management package is configured.

`get` and `cupertino_icons` were removed because the app source does not use them. `flutter pub get` reports newer package releases outside the current dependency constraints; review them separately before a major dependency upgrade.

## Tests

The test suite covers API recipe JSON parsing and round-trip persistence for local recipes, profile data, drafts, and recipe deletion. It does not perform live Spoonacular requests or full UI/device interaction tests.

## Assets and screenshots

SVG navigation/utility icons and Lottie animations are under `assets/`. Platform launcher and launch-screen assets are under `android/` and `ios/`. No app screenshots are currently tracked in the repository.

## Future work

- Add a backend for API key protection, account-based profiles, and cloud recipe sync.
- Add gallery/file image selection and local image storage.
- Add offline caching for API recipe data.
- Add ingredient search, recipe autocomplete, and nutrient filters using documented Spoonacular endpoints.
- Configure production Android/iOS signing and add widget/integration tests.

No author or license information is specified in the repository.
