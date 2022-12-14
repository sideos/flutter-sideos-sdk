package io.sideos.sideossdk;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import org.json.JSONException;
import org.json.JSONObject;
import androidx.security.crypto.EncryptedSharedPreferences;

/** SideossdkPlugin */
public class SideossdkPlugin implements FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "sideossdk");
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }

  private static String dbPath = "";
  private static EncryptedSharedPreferences encryptedSharedPreferences;

  public static String saveKeys(String key) {
    encryptedSharedPreferences.edit().putString("MainKey", key).apply();
    return getKeys();
  }

  public static String getKeys() {
    String res = encryptedSharedPreferences.getString("MainKey", "");
    if (res=="") {
      String s = rustGetKeys(dbPath);
      try {
        JSONObject k = new JSONObject(s);
        Boolean error = k.getBoolean("error");
        if (error) { // No db yet create DID and Key
          try {
            String result = rustCreateLocalDid("v002");
            JSONObject obj = new JSONObject(result);
            if (obj.getBoolean("error")==true) {
              res = ""; // Weird...
            } else {
              res = obj.getString("message");
              encryptedSharedPreferences.edit().putString("MainKey", res).apply();
            }
          } catch (JSONException e) {
            e.printStackTrace();
          }
        } else {
          res = k.getString("message");
          encryptedSharedPreferences.edit().putString("MainKey", res).apply();
        }
      } catch (JSONException e) {
        e.printStackTrace();
      }
    }
    return res;
  }

  public static String getKeyForSignature() {
    String res = encryptedSharedPreferences.getString("MainKey", "");
    return res;
  }
  
  private static native String rustCreateLocalDid(String version);
  private static native String rustGetKeys(String dbpath);

}
