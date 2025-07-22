package com.fittrackpro.fittrack_pro

import android.Manifest
import android.app.Activity
import android.content.pm.PackageManager
import android.os.Build
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat

object PermissionManager {
    private const val PERMISSION_REQUEST_CODE = 1001
    
    private val REQUIRED_PERMISSIONS = arrayOf(
        Manifest.permission.WAKE_LOCK,
        Manifest.permission.FOREGROUND_SERVICE,
        Manifest.permission.VIBRATE,
        Manifest.permission.ACCESS_NETWORK_STATE,
        Manifest.permission.INTERNET
    ).let { permissions ->
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            permissions + arrayOf(
                Manifest.permission.POST_NOTIFICATIONS,
                Manifest.permission.FOREGROUND_SERVICE_HEALTH
            )
        } else {
            permissions
        }
    }

    fun requestPermissions(activity: Activity) {
        val permissionsToRequest = REQUIRED_PERMISSIONS.filter { permission ->
            ContextCompat.checkSelfPermission(activity, permission) != PackageManager.PERMISSION_GRANTED
        }

        if (permissionsToRequest.isNotEmpty()) {
            ActivityCompat.requestPermissions(
                activity,
                permissionsToRequest.toTypedArray(),
                PERMISSION_REQUEST_CODE
            )
        }
    }

    fun hasAllPermissions(activity: Activity): Boolean {
        return REQUIRED_PERMISSIONS.all { permission ->
            ContextCompat.checkSelfPermission(activity, permission) == PackageManager.PERMISSION_GRANTED
        }
    }
}