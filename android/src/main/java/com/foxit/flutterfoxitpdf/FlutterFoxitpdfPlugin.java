package com.foxit.flutterfoxitpdf;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;

import com.foxit.sdk.common.Constants;
import com.foxit.sdk.common.Library;

import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;


/** FlutterFoxitpdfPlugin */
public class FlutterFoxitpdfPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
  private MethodChannel channel;
  private Activity activity;
  private int errorCode = Constants.e_ErrUnknown;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPlugin.FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "flutter_foxitpdf");
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    if (channel != null) {
      channel.setMethodCallHandler(null);
      channel = null;
    }
  }

  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
    activity = binding.getActivity();
  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
    activity = binding.getActivity();
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
    activity = null;
  }

  @Override
  public void onDetachedFromActivity() {
    activity = null;
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    switch (call.method) {
      case "getPlatformVersion":
          result.success("Android " + android.os.Build.VERSION.RELEASE);
          break;
      case "initialize":
        initialize(call, result);
        break;
      case "openDocument":
        openDocument(call, result);
        break;
      case "openDocFromUrl":
        openDocFromUrl(call, result);
        break;
      default:
        result.notImplemented();
        break;
    }
  }

  private void initialize(MethodCall call, Result result) {
    String sn = call.argument("sn");
    String key = call.argument("key");
    errorCode = Library.initialize(sn, key);
    result.success(errorCode);
  }

  private void openDocument(MethodCall call, Result result) {
    if (errorCode != Constants.e_ErrSuccess) {
      result.error("" + errorCode,"Failed to initialize Foxit Library", errorCode);
      return;
    }
    String path = call.argument("path");
    String password = call.argument("password");

    if (path == null || path.trim().length() < 1) {
      result.error("" + Constants.e_ErrParam,"Invalid path", Constants.e_ErrParam);
      return;
    }

    if (activity == null) {
      result.error("-1","The Activity is null", -1);
      return;
    }

    Intent intent = new Intent(activity, PDFReaderActivity.class);
    Bundle bundle = new Bundle();
    bundle.putInt("type", 0);
    bundle.putString("path", path);
    bundle.putString("password", password);
    intent.putExtras(bundle);

    activity.startActivity(intent);
    result.success(true);
  }

  private void openDocFromUrl(MethodCall call, Result result) {
    if (errorCode != Constants.e_ErrSuccess) {
      result.error("" + errorCode,"Failed to initialize Foxit Library", errorCode);
      return;
    }
    String path = call.argument("path");
    String password = call.argument("password");

    if (path == null || path.trim().length() < 1) {
      result.error("" + Constants.e_ErrParam,"Invalid path", Constants.e_ErrParam);
      return;
    }

    if (activity == null) {
      result.error("-1","The Activity is null", -1);
      return;
    }

    Intent intent = new Intent(activity, PDFReaderActivity.class);
    Bundle bundle = new Bundle();
    bundle.putInt("type", 1);
    bundle.putString("path", path);
    bundle.putString("password", password);
    intent.putExtras(bundle);

    activity.startActivity(intent);
    result.success(true);
  }

}
