package com.gelx.gelx_droid;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.TextView;

import androidx.recyclerview.widget.RecyclerView;

import com.gelx.gelx_droid.data.model.LadderData;

import java.util.ArrayList;

public class ItemArrayAdapter extends RecyclerView.Adapter<ItemArrayAdapter.ViewHolder> {

    //All methods in this adapter are required for a bare minimum recyclerview adapter
    private int listItemLayout;
    private ArrayList<LadderData> itemList;
    OnLadderDataDeleteListener onLadderDataDeleteListener;
    // Constructor of the class
    public ItemArrayAdapter(int layoutId, ArrayList<LadderData> itemList, OnLadderDataDeleteListener onLadderDataDeleteListener) {
        listItemLayout = layoutId;
        this.itemList = itemList;
        this.onLadderDataDeleteListener = onLadderDataDeleteListener;
    }

    // get the size of the list
    @Override
    public int getItemCount() {
        return itemList == null ? 0 : itemList.size();
    }


    // specify the row layout file and click for each row
    @Override
    public ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(listItemLayout, parent, false);
        ViewHolder myViewHolder = new ViewHolder(view, onLadderDataDeleteListener);
        return myViewHolder;
    }

    // load data in each row element
    @Override
    public void onBindViewHolder(final ViewHolder holder, final int listPosition) {
        TextView length = holder.length;
        TextView point = holder.point;
        holder.
        length.setText(itemList.get(listPosition).getLadder_length()+"");
        point.setText(itemList.get(listPosition).getLadder_point()+"");
    }

    // Static inner class to initialize the views of rows
    static class ViewHolder extends RecyclerView.ViewHolder implements View.OnClickListener {
        public TextView length;
        public TextView point;
        private Button deleteBtn;
        private OnLadderDataDeleteListener onLadderDataDeleteListener;

        public ViewHolder(View itemView, OnLadderDataDeleteListener onLadderDataDeleteListener) {
            super(itemView);

            point = (TextView) itemView.findViewById(R.id.point_text);
            length = (TextView) itemView.findViewById(R.id.length_text);
            deleteBtn = itemView.findViewById(R.id.delete);
            this.onLadderDataDeleteListener = onLadderDataDeleteListener;
            deleteBtn.setOnClickListener(this);
        }
        @Override
        public void onClick(View view) {
            onLadderDataDeleteListener.onLadderDataDelete(getAdapterPosition());
        }
    }
}
