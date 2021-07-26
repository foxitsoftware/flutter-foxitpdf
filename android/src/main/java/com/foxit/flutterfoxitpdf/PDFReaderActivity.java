package com.foxit.flutterfoxitpdf;

import android.Manifest;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.res.Configuration;
import android.os.Build;
import android.os.Bundle;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import androidx.fragment.app.FragmentActivity;
import android.view.KeyEvent;

import com.foxit.sdk.PDFViewCtrl;
import com.foxit.uiextensions.UIExtensionsManager;
import com.foxit.uiextensions.utils.AppTheme;
import com.foxit.uiextensions.utils.UIToast;

public class PDFReaderActivity extends FragmentActivity {
      private static final int REQUEST_EXTERNAL_STORAGE = 1;
    private static final String[] PERMISSIONS_STORAGE = {
            Manifest.permission.READ_EXTERNAL_STORAGE,
            Manifest.permission.WRITE_EXTERNAL_STORAGE
    };

    public PDFViewCtrl pdfViewCtrl;
    private UIExtensionsManager uiextensionsManager;

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        AppTheme.setThemeFullScreen(this);

        pdfViewCtrl = new PDFViewCtrl(getApplicationContext());
        uiextensionsManager = new UIExtensionsManager(this, pdfViewCtrl, null);
        uiextensionsManager.setAttachedActivity(this);
        pdfViewCtrl.setUIExtensionsManager(uiextensionsManager);
        pdfViewCtrl.setAttachedActivity(this);
        uiextensionsManager.onCreate(this, pdfViewCtrl, null);

        Bundle bundle = getIntent().getExtras();
        String path = bundle == null ? "" : bundle.getString("path");
        byte[] password = bundle == null ? null : bundle.getString("password", "").getBytes();
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            int permission = ContextCompat.checkSelfPermission(this.getApplicationContext(), Manifest.permission.WRITE_EXTERNAL_STORAGE);
            if (permission != PackageManager.PERMISSION_GRANTED) {
                ActivityCompat.requestPermissions(this, PERMISSIONS_STORAGE, REQUEST_EXTERNAL_STORAGE);
            } else {
                uiextensionsManager.openDocument(path, password);
            }
        } else {
            uiextensionsManager.openDocument(path, password);
        }

        setContentView(uiextensionsManager.getContentView());
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if (requestCode == REQUEST_EXTERNAL_STORAGE) {
            if (grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                Bundle bundle = getIntent().getExtras();
                String path = bundle == null ? "" : bundle.getString("path");
                byte[] password = bundle == null ? null : bundle.getString("password", "").getBytes();
                uiextensionsManager.openDocument(path, password);
            } else {
                UIToast.getInstance(getApplicationContext()).show("Permission Denied");
            }
        }
    }

    @Override
    protected void onStart() {
        super.onStart();
        if (uiextensionsManager == null) return;
        uiextensionsManager.onStart(this);
    }

    @Override
    protected void onPause() {
        super.onPause();
        if (uiextensionsManager == null) return;
        uiextensionsManager.onPause(this);
    }

    @Override
    protected void onResume() {
        super.onResume();
        if (uiextensionsManager == null) return;
        uiextensionsManager.onResume(this);
    }

    @Override
    protected void onStop() {
        super.onStop();
        if (uiextensionsManager == null) return;
        uiextensionsManager.onStop(this);
    }

    @Override
    protected void onDestroy() {
        if (uiextensionsManager != null){
            uiextensionsManager.onDestroy(this);
            freeMemory();
        }
        super.onDestroy();
    }

    private void freeMemory(){
        System.runFinalization();
        Runtime.getRuntime().gc();
        System.gc();
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (uiextensionsManager != null)
            uiextensionsManager.handleActivityResult(this, requestCode, resultCode, data);
    }

    @Override
    public void onConfigurationChanged(Configuration newConfig) {
        super.onConfigurationChanged(newConfig);
        if (uiextensionsManager == null) return;
        uiextensionsManager.onConfigurationChanged(this, newConfig);
    }

    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if (uiextensionsManager != null && uiextensionsManager.onKeyDown(this, keyCode, event))
            return true;
        return super.onKeyDown(keyCode, event);
    }

}
