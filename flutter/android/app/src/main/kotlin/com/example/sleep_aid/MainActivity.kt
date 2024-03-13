package com.example.sleep_aid

import android.Manifest
import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.provider.Settings
import androidx.core.app.ActivityCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel


class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.systemsettings/launcher"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            if (call.method == "openSystemSettings") {
                openSystemSettings()
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
    }


    private fun openSystemSettings() {
        val intent = Intent(Settings.ACTION_BLUETOOTH_SETTINGS)
        startActivity(intent)
    }

    private val mPermissionList: MutableList<String> = ArrayList()

    private fun initPermission() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            // Android 版本大于等于 Android 12 时
            mPermissionList.add(Manifest.permission.BLUETOOTH_SCAN)
            mPermissionList.add(Manifest.permission.BLUETOOTH_ADVERTISE)
            mPermissionList.add(Manifest.permission.BLUETOOTH_CONNECT)
        } else {
            // Android 版本小于 Android 12 及以下版本
            mPermissionList.add(Manifest.permission.ACCESS_COARSE_LOCATION)
            mPermissionList.add(Manifest.permission.ACCESS_FINE_LOCATION)
        }

        if (mPermissionList.isNotEmpty()) {
            ActivityCompat.requestPermissions(this, mPermissionList.toTypedArray(), 1001)
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        initPermission() // 请求权限
    }

    // 这里是处理权限请求结果的函数
    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        // 根据需要处理权限请求结果
    }
}