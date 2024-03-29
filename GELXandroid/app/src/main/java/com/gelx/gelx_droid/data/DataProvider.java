package com.gelx.gelx_droid.data;

import android.content.Context;
import android.util.Log;

import com.android.volley.AuthFailureError;
import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.StringRequest;
import com.android.volley.toolbox.Volley;
import com.gelx.gelx_droid.data.model.ImageData;
import com.gelx.gelx_droid.data.model.XY;
import com.google.gson.Gson;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


public class DataProvider {

    private static final String sendDataUrl = "http://10.0.2.2:8000/polls/analysis/";
    private static final String sendImageURL = "http://10.0.2.2:8000/polls/image/";

    private static List<XY> xyDataList = new ArrayList<>();

    public static void clearDataList() {
        xyDataList.clear();
    }

    public static boolean addData(XY xy) {
        if (xyDataList.size() < 10) {

            xyDataList.add(xy);

            return true;

        } else {
            return false;
        }
    }

    public static void sendImageToServer(Context context, ImageData imageData) {
        final String jsonString = new Gson().toJson(imageData);
        Log.i("JSON", jsonString);

        RequestQueue queue = Volley.newRequestQueue(context);

        StringRequest stringRequest = new StringRequest(Request.Method.POST, sendImageURL,
                new Response.Listener<String>() {
                    @Override
                    public void onResponse(String response) {

                        Log.i("Image Sent", response);

                    }
                }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {
                Log.e("Image Sent", "error: " + error.getMessage());
            }
        }) {
            @Override
            public byte[] getBody() throws AuthFailureError {
                return jsonString.getBytes();
            }

            @Override
            public Map<String, String> getHeaders() throws AuthFailureError {
                Map<String, String>  params = new HashMap<String, String>();
                params.put("auth-key", "1234");
                return params;
            }
        };
        // Add the request to the RequestQueue.
        queue.add(stringRequest);

    }


    public static void sendDataToServer(Context context) {
        final String jsonArrayString = new Gson().toJson(xyDataList);
        Log.i("JSON", jsonArrayString);

        RequestQueue queue = Volley.newRequestQueue(context);

        StringRequest stringRequest = new StringRequest(Request.Method.POST, sendDataUrl,
                new Response.Listener<String>() {
                    @Override
                    public void onResponse(String response) {

                        Log.i("DataSent", response);

                    }
                }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {
                Log.e("Data Sent", "error: " + error.getMessage());
            }
        }) {
            @Override
            public byte[] getBody() throws AuthFailureError {
                return jsonArrayString.getBytes();
            }
        };
        // Add the request to the RequestQueue.
        queue.add(stringRequest);

    }

    public static void printDataList() {

        for (XY data : xyDataList) {
            Log.i("XYData", data.x + " " + data.y);
        }

    }

}
