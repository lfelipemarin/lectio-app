# lectio_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Build for prod
- Run flutter build appbundle --release --split-debug-info=build/symbols
- Copy to Google Play Console the app-release.aab file from build/app/outputs/bundle/release
  to the Google Play Console
- Zip the files under build/app/intermediates/merged_native_libs/release/out/lib and upload it
  to Google Play Console release