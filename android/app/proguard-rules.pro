# Flutter ProGuard Rules

# Keep Flutter classes
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Add any additional rules below

# Fix for Play Core missing classes
-dontwarn com.google.android.play.core.**
-dontwarn com.google.android.gms.**
-keep class com.google.android.play.core.** { *; }
