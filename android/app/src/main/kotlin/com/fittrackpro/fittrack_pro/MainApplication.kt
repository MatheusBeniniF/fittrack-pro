package com.fittrackpro.fittrack_pro

import android.app.Application
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.os.Build
import io.flutter.app.FlutterApplication

class MainApplication : FlutterApplication() {
    companion object {
        const val WORKOUT_CHANNEL_ID = "workout_channel"
        const val WORKOUT_CHANNEL_NAME = "Workout Notifications"
        const val WORKOUT_CHANNEL_DESCRIPTION = "Notifications for workout tracking"
    }

    override fun onCreate() {
        super.onCreate()
        createNotificationChannels()
    }

    private fun createNotificationChannels() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            
            val workoutChannel = NotificationChannel(
                WORKOUT_CHANNEL_ID,
                WORKOUT_CHANNEL_NAME,
                NotificationManager.IMPORTANCE_LOW
            ).apply {
                description = WORKOUT_CHANNEL_DESCRIPTION
                setShowBadge(false)
                enableLights(false)
                enableVibration(false)
            }
            
            notificationManager.createNotificationChannel(workoutChannel)
        }
    }
}