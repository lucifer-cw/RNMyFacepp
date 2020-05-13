
package com.reactlibrary;

import android.Manifest;
import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Intent;
import android.content.pm.PackageManager;

import com.facebook.react.bridge.ActivityEventListener;
import com.facebook.react.bridge.BaseActivityEventListener;
import com.facebook.react.bridge.Promise;
import com.megvii.demo.utils.Configuration;

import android.graphics.Bitmap;
import android.os.Build;
import android.util.Base64;
import android.widget.Toast;

import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Callback;
import com.megvii.demo.activity.IDCardDetectActivity;
import com.megvii.idcardquality.IDCardQualityLicenseManager;
import com.megvii.licensemanager.Manager;
import com.megvii.meglive_sdk.listener.DetectCallback;
import com.megvii.meglive_sdk.listener.PreCallback;
import com.megvii.meglive_sdk.manager.MegLiveManager;

import java.io.ByteArrayOutputStream;
import java.io.IOException;

import static android.app.Activity.RESULT_OK;
import static android.os.Build.VERSION_CODES.M;
import static com.facebook.react.bridge.UiThreadUtil.runOnUiThread;

public class RNMyFaceppModule extends ReactContextBaseJavaModule implements PreCallback ,DetectCallback{

  private final ReactApplicationContext reactContext;
  private IDCardQualityLicenseManager mIdCardLicenseManager;
  private static final int INTO_IDCARDSCAN_PAGE = 100;
  private MegLiveManager megLiveManager;
  private Callback jscallback = null;
  private Promise jspromise = null;

  private final ActivityEventListener mActivityEventListener = new BaseActivityEventListener() {

    @Override
    public void onActivityResult(Activity activity, int requestCode, int resultCode, Intent intent) {
      if (requestCode == INTO_IDCARDSCAN_PAGE && resultCode == RESULT_OK) {
        if(jscallback !=  null){
          if(intent != null ){
            String result = new String(Base64.encode(intent.getByteArrayExtra("idcardimg_bitmap"),Base64.NO_WRAP));
            jscallback.invoke(null,result);
          }
        }
      }
    }
  };

  /**
   * bitmap转为base64
   * @param bitmap
   * @return
   */
  public static String bitmapToBase64(Bitmap bitmap) {

    String result = null;
    ByteArrayOutputStream baos = null;
    try {
      if (bitmap != null) {
        baos = new ByteArrayOutputStream();
        bitmap.compress(Bitmap.CompressFormat.JPEG, 100, baos);

        baos.flush();
        baos.close();

        byte[] bitmapBytes = baos.toByteArray();
        result = Base64.encodeToString(bitmapBytes, Base64.DEFAULT);
      }
    } catch (IOException e) {
      e.printStackTrace();
    } finally {
      try {
        if (baos != null) {
          baos.flush();
          baos.close();
        }
      } catch (IOException e) {
        e.printStackTrace();
      }
    }
    return result;
  }

  public RNMyFaceppModule(ReactApplicationContext reactContext) {
    super(reactContext);
    reactContext.addActivityEventListener(mActivityEventListener);
    this.reactContext = reactContext;
  }

  private void init() {
    megLiveManager= MegLiveManager.getInstance();
    /**
     * 如果build.gradle中的applicationId 与 manifest中package不一致，必须将manifest中package通过
     * 下面方法传入，如果一致可以不调用此方法
     */
    megLiveManager.setManifestPack(this.reactContext,"com.ajxtpro");
  }

  private void initConfig() {
    requestCameraPerm();
    Configuration.setIsVertical(this.reactContext, true);
  }

  public void startGetLicense(Integer page) {
    Activity activity = getCurrentActivity();
    Configuration.setCardType(this.reactContext, page);
    mIdCardLicenseManager = new
            IDCardQualityLicenseManager(
            activity);

    long status = 0;
    try {
      status = mIdCardLicenseManager.checkCachedLicense();
    } catch (Throwable e) {
      e.printStackTrace();
    }
    if (status > 0) {//大于0，已授权或者授权未过期
      Intent intent = new Intent(activity, IDCardDetectActivity.class);
      activity.startActivityForResult(intent, INTO_IDCARDSCAN_PAGE);
      Toast.makeText(activity, "授权成功", Toast.LENGTH_SHORT).show();

    } else { //需要重新授权
      Toast.makeText(activity, "没有缓存的授权信息，开始授权", Toast.LENGTH_SHORT).show();

      new Thread(new Runnable() {
        @Override
        public void run() {
          try {
            getLicense();
          } catch (Throwable e) {
            e.printStackTrace();
          }
        }
      }).start();
    }
  }

  private void getLicense() {
    final Activity activity = getCurrentActivity();
    Manager manager = new Manager(activity);
    manager.registerLicenseManager(mIdCardLicenseManager);

    String uuid = Configuration.getUUID(activity);

    String authMsg = mIdCardLicenseManager.getContext(uuid);
    manager.takeLicenseFromNetwork(authMsg);
    if (mIdCardLicenseManager.checkCachedLicense() > 0) {//大于0，已授权或者授权未过期
      runOnUiThread(new Runnable() {
        @Override
        public void run() {
          Intent intent = new Intent(activity, IDCardDetectActivity.class);
          activity.startActivityForResult(intent, INTO_IDCARDSCAN_PAGE);
          Toast.makeText(activity, "授权成功", Toast.LENGTH_SHORT).show();
        }
      });
    }

  }

  private void requestCameraPerm() {
    if (Build.VERSION.SDK_INT >= M) {
      if (ContextCompat.checkSelfPermission(this.reactContext,Manifest.permission.CAMERA)
              != PackageManager.PERMISSION_GRANTED) {
        ActivityCompat.requestPermissions(this.reactContext.getCurrentActivity(), new String[]{Manifest.permission.CAMERA}, 101);
      }
    }
  }

  @Override
  public String getName() {
    return "RNMyFacepp";
  }

  @ReactMethod
  public void initFaceIDCardLicense() {
    //1、初始化配置
    initConfig();
  }

  @ReactMethod
  public void startIdCardDetectShootPage(Integer page, Callback callback) {
    this.jscallback = callback;
    //1、初始化配置
    initConfig();
    //2、请求授权信息
    startGetLicense(page+1);
  }

//  活体采集识别
  @ReactMethod
  public void startLiveDetect(String bizToken, Promise promise){
    this.jspromise = promise;
    requestCameraPerm();
    init();
    megLiveManager.preDetect(this.reactContext, bizToken,"en","https://api.megvii.com", this);
  }

  @ReactMethod
  public void show(String message, int duration) {
    Toast.makeText(getReactApplicationContext(), message, duration).show();
  }

  @Override
  public void onPreStart() {

  }

  @Override
  public void onPreFinish(String token, int errorCode, String errorMessage) {
    if (errorCode == 1000) {
      megLiveManager.setVerticalDetectionType(MegLiveManager.DETECT_VERITICAL_FRONT);
      megLiveManager.startDetect(this);
    }
  }

  @Override
  public void onDetectFinish(String token, int errorCode, String errorMessage, String data) {
    if (errorCode == 1000) {
      this.jspromise.resolve(data);
//      verify(token, data.getBytes());
    }else {
      this.jspromise.reject("err",errorMessage);
    }
  }


}