package com.fittrackpro.fittrack_pro

import android.content.Intent
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.fittrackpro/workout"
    private val WORKOUT_EVENT_CHANNEL = "com.fittrackpro/workout_events"
    private val HEART_RATE_EVENT_CHANNEL = "com.fittrackpro/heart_rate"
    
    private lateinit var methodChannelHandler: MethodChannelHandler
    private lateinit var workoutEventHandler: WorkoutEventHandler
    private lateinit var heartRateEventHandler: HeartRateEventHandler

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        // Initialize handlers
        methodChannelHandler = MethodChannelHandler(this)
        workoutEventHandler = WorkoutEventHandler()
        heartRateEventHandler = HeartRateEventHandler()
        
        // Setup method channel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler(methodChannelHandler)
        
        // Setup event channels
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, WORKOUT_EVENT_CHANNEL).setStreamHandler(workoutEventHandler)
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, HEART_RATE_EVENT_CHANNEL).setStreamHandler(heartRateEventHandler)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        // Request necessary permissions
        PermissionManager.requestPermissions(this)
    }

    override fun onDestroy() {
        super.onDestroy()
        methodChannelHandler.cleanup()
        workoutEventHandler.cleanup()
        heartRateEventHandler.cleanup()
    }
}