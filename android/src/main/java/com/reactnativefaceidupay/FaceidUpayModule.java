package com.reactnativefaceidupay;

import androidx.annotation.NonNull;


import android.app.Activity;
import android.content.Intent;
import android.util.Log;


import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.module.annotations.ReactModule;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.ActivityEventListener;


import org.json.JSONArray;
import org.json.JSONObject;

import com.google.gson.Gson;



import com.upaybiometrics.faceidlib.BioCaller;
import com.upaybiometrics.faceidlib.models.FaceIdLoginData;
import com.upaybiometrics.faceidlib.models.FaceIdResultData;
import com.upaybiometrics.faceidlib.utils.Rut;

@ReactModule(name = FaceidUpayModule.NAME)
public class FaceidUpayModule extends ReactContextBaseJavaModule implements ActivityEventListener  {
    public static final String NAME = "FaceidUpay";
    private final int START_PAYMENT_REQUEST_CODE = 1001;
    private static final String TAG = FaceidUpayModule.class.getName();
    private Callback callback;
    private Activity context;
    private final ReactApplicationContext reactContext;


    public FaceidUpayModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
        this.context =getCurrentActivity();
        this.reactContext.addActivityEventListener(this);
    }

    @Override
    @NonNull
    public String getName() {
        return NAME;
    }



    @ReactMethod
    public void multiply(int a, int b, Promise promise) {
        promise.resolve(a * b);
    }


@ReactMethod
  public void docLivenessFlow(String Identifier, String Data,  Callback callback) {


    this.callback = callback;
    try {
      Log.d(TAG, "INIT CAPTURE AND LIVENESS");
      JSONObject obj = new JSONObject(Data);

      String BaseURL = obj.get("BaseURL").toString();
      String deviceKeyIdentifier = obj.get("deviceKeyIdentifier").toString();
      String dLicense = obj.get("dLicense").toString();
      String projectSecret = obj.get("projectSecret").toString();
      String licenseKey = obj.get("licenseKey").toString();


        Log.d(TAG, "BaseURL" + BaseURL);
        Log.d(TAG, "deviceKeyIdentifier " + deviceKeyIdentifier);
        Log.d(TAG, "dLicense " + dLicense);
        Log.d(TAG, "projectSecret " + projectSecret);
        Log.d(TAG, "licenseKey " + licenseKey);


     BioCaller.docLivenessFlow(context, dLicense, projectSecret, BaseURL, deviceKeyIdentifier, licenseKey, 2862);
    }catch (Exception e){
      Log.d(TAG, e);
      callBackError(e.getMessage());
    }
  }



 private void callBackError(String sMensaje) {
    callback.invoke(null, sMensaje);
  }

  private void callBack(String sMensaje) {
     callback.invoke("OK", sMensaje);
  }


  public void onActivityResult(int requestCode, int resultCode, Intent data) {
    Log.d(TAG, "requestCode: " + requestCode);
    Log.d(TAG, "resultCode: " + resultCode);
    Log.d(TAG, "data: " + data);

    if(requestCode == 2862){
      if(resultCode == Activity.RESULT_OK){
        FaceIdResultData faceIdResultData = BioCaller.getFaceIdResultData();
        //Toast.makeText(this, "Flujo completado para " + faceIdResultData.scanDocumentData.getRut().toString() + " " + faceIdResultData.resultado, Toast.LENGTH_SHORT).show();
      } else {
        //Toast.makeText(this, "Flujo cancelado", Toast.LENGTH_SHORT).show();
      }
    }


  }




  @Override
  public void onNewIntent(Intent intent) {

  }



    public static native int nativeMultiply(int a, int b);



  @Override
  public void onActivityResult(Activity activity, int requestCode, int resultCode, Intent data) {
    Log.d(TAG, "requestCode: " + requestCode);
    Log.d(TAG, "resultCode: " + resultCode);
    Log.d(TAG, "data: " + data);

     if(resultCode == 2863){
      FaceIdLoginData resultadoLogin = BioCaller.getLoginResultData();
      try {
        Gson gson = new Gson();
        String json = gson.toJson(resultadoLogin);
        callBack(json);
      } catch (Exception e){
        callBackError("Exception " + e.getMessage());
      }
    } else if(requestCode == 2862){
      FaceIdResultData resultData = BioCaller.getFaceIdResultData();
      try {
        Gson gson = new Gson();
        String json = gson.toJson(resultData);
        callBack(json);
      } catch (Exception e){
        callBackError("Exception " + e.getMessage());
      }
    }else {
      callBackError("error to get info");
    }
  }
}
