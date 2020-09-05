package com.gelx.gelx_droid.data.model;

public class LadderData {

    private int user_id;
    private int ladder_point;
    private int ladder_length;

    public int getUser_id() {
        return user_id;
    }

    public void setUser_id(int user_id) {
        this.user_id = user_id;
    }



    public int getLadder_point() {
        return ladder_point;
    }

    public LadderData(int ladder_point, int ladder_length) {
        this.ladder_point = ladder_point;
        this.ladder_length = ladder_length;
    }

    public void setLadder_point(int ladder_point) {
        this.ladder_point = ladder_point;
    }

    public int getLadder_length() {
        return ladder_length;
    }

    public void setLadder_length(int ladder_length) {
        this.ladder_length = ladder_length;
    }
}
