package com.foxit.flutterfoxitpdf;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;

import com.foxit.sdk.common.Constants;
import com.foxit.sdk.common.Library;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** FlutterFoxitpdfPlugin */
public class FlutterFoxitpdfPlugin implements MethodCallHandler {
  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_foxitpdf");
    channel.setMethodCallHandler(new FlutterFoxitpdfPlugin(registrar.activity()));
  }

  private int errorCode = Constants.e_ErrUnknown;
  private Activity mActivity = null;
  private FlutterFoxitpdfPlugin(Activity activity) {
    mActivity = activity;
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

    if (mActivity == null) {
      result.error("-1","The Activity is null", -1);
      return;
    }

    Intent intent = new Intent(mActivity, PDFReaderActivity.class);
    Bundle bundle = new Bundle();
    bundle.putInt("type", 0);
    bundle.putString("path", path);
    bundle.putString("password", password);
    intent.putExtras(bundle);

    mActivity.startActivity(intent);
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

    if (mActivity == null) {
      result.error("-1","The Activity is null", -1);
      return;
    }

    Intent intent = new Intent(mActivity, PDFReaderActivity.class);
    Bundle bundle = new Bundle();
    bundle.putInt("type", 1);
    bundle.putString("path", path);
    bundle.putString("password", password);
    intent.putExtras(bundle);

    mActivity.startActivity(intent);
    result.success(true);
  }

}
