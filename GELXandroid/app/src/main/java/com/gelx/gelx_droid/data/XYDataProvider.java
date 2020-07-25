package com.gelx.gelx_droid.data;

import android.util.Log;

import com.gelx.gelx_droid.data.model.XY;

import org.json.JSONArray;

import java.util.ArrayList;
import java.util.List;

public class XYDataProvider {

    private static List<XY> xyDataList = new ArrayList<>();

    public static void clearDataList() {
        xyDataList.clear();
    }

    public static void addData(XY xy) {
        xyDataList.add(xy);
    }

    public static void sendDataToServer() {
        JSONArray jsonArray = new JSONArray(xyDataList);
        Log.i("JSON", jsonArray.toString());
    }

    public static void printDataList(){

        for (XY data : xyDataList) {
            Log.i("XYData", data.x +" "+data.y);
        }

    }

}