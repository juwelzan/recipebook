# Recipe Book

A Flutter recipe browser backed by the Spoonacular API.

## Run

Provide a Spoonacular API key at launch. The key that was previously committed
to this repository has been removed; rotate it in Spoonacular before using the
app again.

```sh
flutter pub get
flutter run --dart-define=SPOONACULAR_API_KEY=your_key
```

The same `--dart-define` must be supplied to build commands. Dart defines keep
credentials out of source control, but a key embedded in a mobile app can still
be extracted from its binary. For production distribution, proxy Spoonacular
requests through a backend that protects and rate-limits the key.

## Structure

- `lib/core/api` handles HTTP requests, timeouts, JSON decoding, and API errors.
- `lib/core/service` builds Spoonacular requests and parses recipe responses.
- `lib/core/model` holds the recipe data model.
- `lib/features` contains Provider state and screens/widgets.
- `lib/shared/provider` persists saved recipes with SharedPreferences.

Recipe search supports query, diet filters, and offset pagination. Recipe
details use Spoonacular's recipe information endpoint. Saved recipes are stored
locally on the device.
