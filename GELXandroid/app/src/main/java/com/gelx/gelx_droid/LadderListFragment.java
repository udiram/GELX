package com.gelx.gelx_droid;

import android.app.AlertDialog;
import android.os.Bundle;

import androidx.fragment.app.Fragment;
import androidx.recyclerview.widget.DefaultItemAnimator;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import com.android.volley.AuthFailureError;
import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.StringRequest;
import com.android.volley.toolbox.Volley;
import com.gelx.gelx_droid.data.model.LadderData;
import com.google.gson.Gson;

import java.util.ArrayList;
import java.util.List;

public class LadderListFragment extends Fragment {

    List<LadderData> itemList;
    RecyclerView recyclerView;
    ItemArrayAdapter itemArrayAdapter;

    private static final String sendDataUrl = "http://10.0.2.2:8000/polls/ladder/";

    public LadderListFragment() {
        // Required empty public constructor
    }


    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment

        View view = inflater.inflate(R.layout.fragment_ladder_list, container, false);

        Button addBtn = view.findViewById(R.id.addLadderBtn);

        addBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                showDataDialogue();
            }
        });

        itemList = new ArrayList<>();

        itemArrayAdapter = new ItemArrayAdapter(R.layout.list_items, (ArrayList<LadderData>) itemList, new OnLadderDataDeleteListener() {
            @Override
            public void onLadderDataDelete(int index) {
                //Toast.makeText(getActivity(), "INDEX: "+index, Toast.LENGTH_SHORT).show();
                deleteLadderData(index);
            }
        });

        recyclerView = (RecyclerView) view.findViewById(R.id.item_list);
        recyclerView.setLayoutManager(new LinearLayoutManager(getActivity()));
        recyclerView.setItemAnimator(new DefaultItemAnimator());
        recyclerView.setAdapter(itemArrayAdapter);

        // Populating list items
//        for (int i = 0; i < 10; i++) {
//            itemList.add(new LadderData(i, i +10));
//        }


        return view;

    }

    private void showDataDialogue(){
        final AlertDialog dialogBuilder = new AlertDialog.Builder(getActivity()).create();
        LayoutInflater inflater = this.getLayoutInflater();
        View dialogView = inflater.inflate(R.layout.add_ladder_data_dialogue, null);

        final EditText point = (EditText) dialogView.findViewById(R.id.point);
        final EditText length = (EditText) dialogView.findViewById(R.id.length);

        Button saveBtn = (Button) dialogView.findViewById(R.id.buttonSave);
        Button cancelBtn = (Button) dialogView.findViewById(R.id.buttonCancel);

        saveBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                dialogBuilder.dismiss();
                addLadderData(new LadderData(Integer.parseInt(point.getText().toString()), Integer.parseInt(length.getText().toString())));
                Toast.makeText(getActivity(), point.getText() +"--" + length.getText(), Toast.LENGTH_SHORT).show();


            }
        });
        cancelBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                dialogBuilder.dismiss();
            }
        });

        dialogBuilder.setView(dialogView);
        dialogBuilder.show();
    }


    private void addLadderData(LadderData ladderData) {
        itemList.add(ladderData);
        itemArrayAdapter.notifyDataSetChanged();
        sendLadderData(ladderData);
    }

    private void deleteLadderData(int index) {
        itemList.remove(index);
        itemArrayAdapter.notifyDataSetChanged();
    }

    private void sendLadderData(LadderData ladderData){
        ladderData.setUser_id(-1);
        final String ladderJson = new Gson().toJson(ladderData);
        Log.i("JSON", ladderJson);

        RequestQueue queue = Volley.newRequestQueue(getActivity());

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
                return ladderJson.getBytes();
            }
        };
        // Add the request to the RequestQueue.
        queue.add(stringRequest);


    }
}