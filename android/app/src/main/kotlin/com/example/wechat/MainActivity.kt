package com.example.wechat

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor, "android.move_task_to_back").setMethodCallHandler { methodCall, result ->
            if (methodCall.method == "moveTaskToBack") {
                result.success(null)
                moveTaskToBack(false)
            }
        }
    }
}
