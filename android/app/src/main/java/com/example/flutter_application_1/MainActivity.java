package com.example.flutter_application_1;
import android.content.Intent;
import com.hover.sdk.api.Hover;
import com.hover.sdk.api.HoverParameters;
import java.util.Map;
import io.flutter.Log;
import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {

    // Hover Action function
  private static final String CHANNEL = "kikoba.co.tz/hover";
    private  void SendMoney(String PhoneNumber,String amount){
        try {
            Hover.initialize(this);
            Log.d("MainActivity", "Sims are = " + Hover.getPresentSims(this));
            Log.d("MainActivity", "Hover actions are = " + Hover.getAllValidActions(this));
        } catch (Exception e) {
            Log.e("MainActivity", "hover exception", e);

        }
        
        //add your action Id from dashboard 
        Intent i = new HoverParameters.Builder(this)
                .request("368461a5")
                .extra("PhoneNumber", PhoneNumber)
                .extra("Amount", amount)
                .buildIntent();

        startActivityForResult(i,0);
    }
    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                   (call, result) -> {
                    final Map<String,Object> arguments = call.arguments();
                    String PhoneNumber = (String) arguments.get("phoneNumber");
                    String amount = (String) arguments.get("amount");
                    if (call.method.equals("sendMoney")) {
                      SendMoney(PhoneNumber,amount);
                      String response = "sent";
                      result.success(response);
                    }
                }
        );
    }
}