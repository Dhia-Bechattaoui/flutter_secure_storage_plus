package com.dhiabechattaoui.flutter_secure_storage_plus


import android.content.Context
import androidx.security.crypto.EncryptedSharedPreferences
import androidx.security.crypto.MasterKey
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.io.IOException
import java.security.GeneralSecurityException

/** FlutterSecureStoragePlusPlugin */
class FlutterSecureStoragePlusPlugin: FlutterPlugin, MethodCallHandler {
  private lateinit var channel : MethodChannel
  private lateinit var context: Context
  private val prefsName = "flutter_secure_storage_plus"

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_secure_storage_plus")
    channel.setMethodCallHandler(this)
    context = flutterPluginBinding.applicationContext
  }

  private fun getEncryptedPrefs(): android.content.SharedPreferences? {
    return try {
      val masterKey = MasterKey.Builder(context)
        .setKeyScheme(MasterKey.KeyScheme.AES256_GCM)
        .build()

      EncryptedSharedPreferences.create(
        context,
        prefsName,
        masterKey,
        EncryptedSharedPreferences.PrefKeyEncryptionScheme.AES256_SIV,
        EncryptedSharedPreferences.PrefValueEncryptionScheme.AES256_GCM
      )
    } catch (e: GeneralSecurityException) {
      null
    } catch (e: IOException) {
      null
    }
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "getPlatformVersion" -> {
        result.success("Android ${android.os.Build.VERSION.RELEASE}")
      }
      "write" -> {
        val key = call.argument<String>("key")
        val value = call.argument<String>("value")
        if (key == null || value == null) {
          result.error("INVALID_ARGUMENT", "Key and value are required", null)
          return
        }
        val prefs = getEncryptedPrefs()
        if (prefs == null) {
          result.error("STORAGE_ERROR", "Failed to initialize secure storage", null)
          return
        }
        prefs.edit().putString(key, value).apply()
        result.success(null)
      }
      "read" -> {
        val key = call.argument<String>("key")
        if (key == null) {
          result.error("INVALID_ARGUMENT", "Key is required", null)
          return
        }
        val prefs = getEncryptedPrefs()
        if (prefs == null) {
          result.error("STORAGE_ERROR", "Failed to initialize secure storage", null)
          return
        }
        val value = prefs.getString(key, null)
        result.success(value)
      }
      "delete" -> {
        val key = call.argument<String>("key")
        if (key == null) {
          result.error("INVALID_ARGUMENT", "Key is required", null)
          return
        }
        val prefs = getEncryptedPrefs()
        if (prefs == null) {
          result.error("STORAGE_ERROR", "Failed to initialize secure storage", null)
          return
        }
        prefs.edit().remove(key).apply()
        result.success(null)
      }
      else -> {
        result.notImplemented()
      }
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
