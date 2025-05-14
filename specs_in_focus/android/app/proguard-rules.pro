# Flutter specific rules
-keepattributes Signature
-keepattributes *Annotation*
-keepattributes SourceFile,LineNumberTable

# Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Flutter WebView
-keep class androidx.webkit.** { *; }

# Prevent R8 from stripping interface information
-keep class * implements io.flutter.plugin.common.PluginRegistry$PluginRegistrantCallback
-keepclassmembers class * implements io.flutter.plugin.common.PluginRegistry$PluginRegistrantCallback { 
    public *; 
}

# Gson
-keepattributes Signature
-keepattributes *Annotation*
-dontwarn sun.misc.**
-keep class com.google.gson.** { *; }

# Your models
-keep class com.example.specs_in_focus.models.** { *; }
-keep class specs_in_focus.models.** { *; } 