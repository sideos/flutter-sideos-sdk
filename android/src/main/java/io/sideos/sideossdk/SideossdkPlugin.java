package io.sideos.sideossdk;

import static androidx.security.crypto.MasterKey.DEFAULT_AES_GCM_MASTER_KEY_SIZE;

import android.content.Context;
import android.security.keystore.KeyGenParameterSpec;
import android.security.keystore.KeyProperties;

import androidx.annotation.NonNull;
import androidx.security.crypto.EncryptedSharedPreferences;
import androidx.security.crypto.MasterKey;

import java.io.IOException;
import java.security.GeneralSecurityException;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** SideossdkPlugin */
public class SideossdkPlugin implements FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  private Context context;
  
  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "sideossdk");
    channel.setMethodCallHandler(this);
    this.context = flutterPluginBinding.getApplicationContext();
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("initSDK")) {
      String keys = getKeys();
      result.success(keys);
      return;
    }
    if (call.method.equals("saveKeys")) {
      String keys = call.argument("keys");
      saveKeys(keys);
      result.success(keys);
      return;
    }
    else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }

  private void createKeys() {
      Context context = this.context;
      try {
        MasterKey mainKey = new MasterKey.Builder(context, "SideosKey")
          .setKeyScheme(MasterKey.KeyScheme.AES256_GCM)
          .build();
        new KeyGenParameterSpec.Builder(
          "SideosKey",
          KeyProperties.PURPOSE_ENCRYPT | KeyProperties.PURPOSE_DECRYPT)
          .setBlockModes(KeyProperties.BLOCK_MODE_GCM)
          .setEncryptionPaddings(KeyProperties.ENCRYPTION_PADDING_NONE)
          .setKeySize(DEFAULT_AES_GCM_MASTER_KEY_SIZE);

        encryptedSharedPreferences = (EncryptedSharedPreferences) EncryptedSharedPreferences.create(
          context,
          "SideosKey",
          mainKey,
          EncryptedSharedPreferences.PrefKeyEncryptionScheme.AES256_SIV,
          EncryptedSharedPreferences.PrefValueEncryptionScheme.AES256_GCM
        );
      } catch (GeneralSecurityException e) {
        e.printStackTrace();
      } catch (IOException e) {
        e.printStackTrace();
      }
    }

  private static EncryptedSharedPreferences encryptedSharedPreferences;

  public String saveKeys(String key) {
    encryptedSharedPreferences.edit().putString("MainKey", key).apply();
    return "";
  }

  public String getKeys() {
    createKeys();
    String res = encryptedSharedPreferences.getString("MainKey", "");
    return res;
  }
  
  private static native String rust_setup(String keys);

}
