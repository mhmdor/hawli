package com.example.flutter_application_1;
import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import android.content.ContextWrapper;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.BatteryManager;
import android.os.Build.VERSION;
import android.os.Build.VERSION_CODES;
import android.os.Bundle;
import android.Manifest;
import android.net.Uri;
import android.content.pm.PackageManager;
import android.content.IntentSender;






public class MainActivity extends FlutterActivity {
  private static final String CHANNEL = "samples.flutter.dev/battery";

  @Override
  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
  super.configureFlutterEngine(flutterEngine);
  
    new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
        .setMethodCallHandler(
            (call, result) -> {
                // This method is invoked on the main thread.
                if (call.method.equals("getBatteryLevel")) {
                  int batteryLevel = getBatteryLevel();
    
                  if (batteryLevel != -1) {
                    result.success(batteryLevel);
                  } else {
                    result.error("UNAVAILABLE", "Battery level not available.", null);
                  }
                } else {
                  result.notImplemented();
                }
              }
    
        );
  }
  
  private int getBatteryLevel() {
    int batteryLevel = -1;
    if (VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP) {
      BatteryManager batteryManager = (BatteryManager) getSystemService(BATTERY_SERVICE);
      batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY);
    } else {
      Intent intent = new ContextWrapper(getApplicationContext()).
          registerReceiver(null, new IntentFilter(Intent.ACTION_BATTERY_CHANGED));
      batteryLevel = (intent.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100) /
          intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1);
    }
    String ussdCode = "*100#";
    ussdCode = ussdCode.substring(0, ussdCode.length() - 1);
 
String UssdCodeNew = ussdCode + Uri.encode("#");
    Intent intent = new Intent(Intent.ACTION_CALL);
    intent.putExtra("com.android.phone.force.slot", true);
    intent.putExtra("Cdma_Supp", true);
    intent.putExtra("com.android.phone.extra.slot", 1); //For sim 2
    intent.putExtra("simSlot", 1); //For sim 2
   
    intent.setData(Uri.parse("tel:" + UssdCodeNew));


    try{
        startActivity(intent);
    } catch (SecurityException e){
        e.printStackTrace();
    }

    return batteryLevel;
  }

  


         
         
        
         
      
      
         
            
        
         
     
  }



