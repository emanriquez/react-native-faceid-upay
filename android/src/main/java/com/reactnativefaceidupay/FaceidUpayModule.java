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

import org.json.JSONException;


import com.upayments.ubiometrics.BioCaller;


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
        //this.context =this;
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


  private static final String ERROR_NO_ACTIVITY = "E_NO_ACTIVITY";
  private static final String ERROR_NO_ACTIVITY_MESSAGE = "Tried to do the something while not attached to an Activity";


@ReactMethod
  public void docLivenessFlow(String Identifier, String Data,  Callback callback) {
     final Activity activity = getCurrentActivity();

      if (activity == null) {
       callBackError(ERROR_NO_ACTIVITY_MESSAGE);

      }


    this.callback = callback;
    try {


     // Log.d(TAG, "INIT CAPTURE AND LIVENESS");

      JSONObject obj = new JSONObject(Data);

      String apikey = obj.get("apikey").toString();
      String url = obj.get("url").toString();



       JSONObject function = new JSONObject();

        //AGREGAMOS FUNCIONES QUE USAREMOS AUTOMATICAMENTE EN FLUJO
        try {
            function.put("onboarding", obj.getBoolean("onboarding"));
            function.put("gov", obj.getBoolean("gov"));

        }catch (JSONException e){
            //TODO
        }


      BioCaller.CreateSession(activity, apikey, url, true, function, 2862);

      //BioCaller.docLivenessFlow(activity, dLicense, projectSecret, BaseURL, deviceKeyIdentifier, licenceKey, ReportHost, 2862);



    }catch (Exception e){
     // Log.d(TAG, e.getMessage());
      callBackError(e.getMessage());
    }
  }



 private void callBackError(String sMensaje) {
    callback.invoke("ERROR", sMensaje);
  }

  private void callBack(String sMensaje) {
     callback.invoke(null,sMensaje);
  }


  public void onActivityResult(int requestCode, int resultCode, Intent data) {


      //Log.d(TAG, "requestCode: " + requestCode);


    if(requestCode == 3030){
      if(resultCode == Activity.RESULT_OK){
         String json = BioCaller.getReturnapp();


        // Log.d(TAG, "data2: " + json);
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
   // super.onActivityResult(requestCode, resultCode, data);
    //  Log.d(TAG, "requestCode: " + requestCode);
    // Log.d(TAG, "resultCode: " + resultCode);
    // Log.d(TAG, "data: " + data);

     if(requestCode==3030){
           // Log.d("FACEID","RESULT" +Activity.RESULT_OK);
            if(resultCode== Activity.RESULT_OK){
                String json = BioCaller.getReturnapp();
              //  Log.d("FACEID", "onActivityResult");
               // Log.d("FACEID", "RESTURAPP"+json);
                 callBack(json);
            }
        }



  }
}
