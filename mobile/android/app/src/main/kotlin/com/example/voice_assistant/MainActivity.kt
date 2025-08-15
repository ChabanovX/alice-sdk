package com.example.voice_assistant

import androidx.annotation.NonNull
import com.yandex.mapkit.MapKitFactory
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        MapKitFactory.setLocale("ru_RU")
        MapKitFactory.setApiKey("2a1db1a2-dd56-484b-8ea3-5bf7214baae1")
        super.configureFlutterEngine(flutterEngine)
    }
}
