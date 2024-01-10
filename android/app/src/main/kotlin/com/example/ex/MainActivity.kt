package com.example.ex

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import androidx.annotation.NonNull
import androidx.annotation.RequiresApi
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodChannel
import io.flutter.Log

class MainActivity: FlutterActivity() {
    private val CHANNEL = "test"

    @RequiresApi(Build.VERSION_CODES.TIRAMISU)
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        channel.setMethodCallHandler {
            call, result ->
            if(call.method == "send100"){
                val args = call.arguments as Map<*, *>;
                val pass = args["pass"] as Int
                Log.d("Kotlin", "mess")
                if(pass == 1234){
                    channel.invokeMethod("add100", null)
                } else {
                    channel.invokeMethod("minus100", null)
                }
            }
        }

        val tr: BroadcastReceiver = TestReceiver()
        val filter = IntentFilter("com.example.android.ACTION_CUSTOM_BROADCAST")
        registerReceiver(tr, filter, Context.RECEIVER_EXPORTED)
    }
}

class TestReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        Log.d("Kotlin", "Received an intent")
//        val pass = intent.getIntExtra("pass", 0)
        val flutterEngine = FlutterEngine(context)

        flutterEngine
            .dartExecutor
            .executeDartEntrypoint(DartExecutor.DartEntrypoint.createDefault())

        val channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "test")

        channel.invokeMethod("broadcast", mapOf("pass" to 1234))
    }
}