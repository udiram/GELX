package com.gelx.gelx_droid.data;

import android.content.Context;
import android.content.SharedPreferences;
import android.preference.PreferenceManager;

public class PermanentStorage {

    public static final String jobB64 = "image+job";

    private static PermanentStorage permanentStorage;

    public static synchronized PermanentStorage getInstance() {
        if (permanentStorage == null) {
            permanentStorage = new PermanentStorage();
        }
        return permanentStorage;
    }

    public void storeString(Context context, String key, String value) {
        SharedPreferences preferences = PreferenceManager.getDefaultSharedPreferences(context);
        SharedPreferences.Editor editor = preferences.edit();
        editor.putString(key, value);
        editor.apply();
    }


    public String retrieveString(String key, Context context) {
        SharedPreferences preferences = PreferenceManager.getDefaultSharedPreferences(context);
        String result = preferences.getString(key, "");
        return result;
    }
}
