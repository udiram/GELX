package com.gelx.gelx_droid.ui.home;

import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.ColorMatrix;
import android.graphics.ColorMatrixColorFilter;
import android.graphics.Matrix;
import android.graphics.Paint;
import android.graphics.Point;
import android.graphics.RectF;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.LayerDrawable;
import android.net.Uri;
import android.os.Bundle;
import android.provider.MediaStore;
import android.util.Log;
import android.view.Display;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.SeekBar;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.content.ContextCompat;
import androidx.fragment.app.Fragment;
import androidx.lifecycle.Observer;
import androidx.lifecycle.ViewModelProviders;


import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.StringRequest;
import com.android.volley.toolbox.Volley;
import com.gelx.gelx_droid.ContrastActivity;
import com.gelx.gelx_droid.R;
import com.gelx.gelx_droid.data.XYDataProvider;
import com.gelx.gelx_droid.data.model.XY;
import com.github.chrisbanes.photoview.OnPhotoTapListener;
import com.github.chrisbanes.photoview.OnSingleFlingListener;
import com.github.chrisbanes.photoview.PhotoView;

import static com.gelx.gelx_droid.ContrastActivity.changeBitmapContrastBrightness;

public class HomeFragment extends Fragment {
    private static final int RESULT_LOAD_IMAGE = 1000;
    private HomeViewModel homeViewModel;
    private PhotoView uploadImg;
    private int[] viewCoords = new int[2];
    SeekBar seekbar;
    TextView contrastval;
    private Bitmap bitmap;

    Canvas canvas;
    Paint paint;

    float downx = 0;
    float downy = 0;
    float upx = 0;
    float upy = 0;

    static final String PHOTO_TAP_TOAST_STRING = "Photo Tap! X: %.2f %% Y:%.2f %% ID: %d";
    static final String SCALE_TOAST_STRING = "Scaled to: %.2ff";
    static final String FLING_LOG_STRING = "Fling velocityX: %.2f, velocityY: %.2f";

    private PhotoView mPhotoView;
    private Toast mCurrentToast;
    private Matrix mCurrentDisplayMatrix = null;

    private Button sendDataBtn;

    public View onCreateView(@NonNull LayoutInflater inflater,
                             ViewGroup container, Bundle savedInstanceState) {
        View root = inflater.inflate(R.layout.fragment_home, container, false);
//        final TextView textView = root.findViewById(R.id.text_home);


        final Button uploadBtn = root.findViewById(R.id.uploadBtn);
        sendDataBtn = root.findViewById(R.id.sendDataBtn);
        sendDataBtn.setVisibility(View.GONE);
        final Button clearBtn = root.findViewById(R.id.clearButton);
        uploadImg = root.findViewById(R.id.uploadedImageView);
        seekbar = (SeekBar) root.findViewById(R.id.seekbar);
        contrastval = (TextView) root.findViewById(R.id.contrastValue);
//

        uploadImg.setOnPhotoTapListener(new PhotoTapListener());
        uploadImg.setOnSingleFlingListener(new SingleFlingListener());

        seekbar.setOnSeekBarChangeListener(new SeekBar.OnSeekBarChangeListener() {
            @Override
            public void onProgressChanged(SeekBar seekBar, int progress, boolean b) {
                if (bitmap != null) {
                    uploadImg.setImageBitmap(changeBitmapContrastBrightness(bitmap, (float) progress / 100f, 1));
                }
                contrastval.setText("Contrast: " + (float) progress / 100f);
            }

            @Override
            public void onStartTrackingTouch(SeekBar seekBar) {
            }

            @Override
            public void onStopTrackingTouch(SeekBar seekBar) {
            }
        });

        seekbar.setMax(2000);
        seekbar.setProgress(100);

        final Drawable[] layers = new Drawable[2];

        final Canvas c;
        final Bitmap bm2;


//        uploadImg.setOnTouchListener(new View.OnTouchListener() {
//            @Override
//            public boolean onTouch(View view, MotionEvent motionEvent) {
//
//                int touchX = (int) motionEvent.getX();
//                int touchY = (int) motionEvent.getY();
//
//                int imageX = touchX - viewCoords[0]; // viewCoords[0] is the X coordinate
//                int imageY = touchY - viewCoords[1]; // viewCoords[1] is the y coordinate
//
//
//                XY data = new XY();
//                data.x = imageX;
//                data.y = imageY;
//                XYDataProvider.addData(data);
//                XYDataProvider.sendDataToServer();
//
//                Bitmap bm = ((BitmapDrawable) uploadImg.getDrawable()).getBitmap();
//
//
//                Bitmap.Config config = bm.getConfig();
//                int width = bm.getWidth();
//                int height = bm.getHeight();
//
//                Bitmap bm2 = Bitmap.createBitmap(width, height, config);
//                Canvas c = new Canvas(bm2);
//
//                c.drawBitmap(bm, 0, 0, null);
//                Paint p = new Paint();
//
//
//                Bitmap repeat = BitmapFactory.decodeResource(getResources(), R.drawable.circle);
//                Bitmap repeat2 = Bitmap.createScaledBitmap(repeat, 50, 50, false);
//                c.drawBitmap(repeat2, 0, 0, p);
//                c.drawBitmap(repeat2, imageX - 25, imageY - 25, p);
//
//                uploadImg.setImageBitmap(bm2);
//
//                return false;
//
//            }
//
//        });


        clearBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                XYDataProvider.clearDataList();
                uploadImg.setImageBitmap(bitmap);
                sendDataBtn.setVisibility(View.GONE);
                seekbar.setProgress(100);

            }
        });
        uploadBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                sendDataBtn.setVisibility(View.GONE);

                XYDataProvider.clearDataList();

                Intent galleryIntent = new Intent(Intent.ACTION_PICK,
                        MediaStore.Images.Media.EXTERNAL_CONTENT_URI);
                galleryIntent.setType("image/*");
                startActivityForResult(galleryIntent, RESULT_LOAD_IMAGE);
            }
        });

        sendDataBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                XYDataProvider.sendDataToServer(getActivity());
            }
        });

        homeViewModel = ViewModelProviders.of(this).get(HomeViewModel.class);

//        homeViewModel.getText().observe(getViewLifecycleOwner(),
//                new Observer<String>() {
//                    @Override
//                    public void onChanged(@Nullable String s) {
//                        textView.setText(s);
//                    }
//                });

//        RequestQueue queue = Volley.newRequestQueue(getActivity());
//        String url ="http://10.0.2.2:8000/polls/add";
//
//// Request a string response from the provided URL.
//        StringRequest stringRequest = new StringRequest(Request.Method.GET, url,
//                new Response.Listener<String>() {
//                    @Override
//                    public void onResponse(String response) {
//                        // Display the first 500 characters of the response string.
//                        textView.setText("Response is: "+ response);
//                    }
//                 }, new Response.ErrorListener() {
//            @Override
//            public void onErrorResponse(VolleyError error) {
//                textView.setText("That didn't work! "+ error.getMessage());
//            }
//        });


// Add the request to the RequestQueue.
//        queue.add(stringRequest);


        Point point = new Point();
        Display cureentDispaly = getActivity().getWindowManager().getDefaultDisplay();
        cureentDispaly.getSize(point);
        int weidth = point.x;
        int height = point.y;


        Bitmap bitmap = Bitmap.createBitmap(weidth, height, Bitmap.Config.ARGB_8888);
        canvas = new Canvas(bitmap);
        paint = new Paint();
        paint.setColor(Color.GREEN);
        paint.setStyle(Paint.Style.STROKE);
        paint.setStrokeWidth(10);


        //imageView = (ImageView)findViewById(R.id.imageView);
        //imageView.setImageBitmap(bitmap);

        return root;
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {

        if (data == null) {
            return;
        }

        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == RESULT_LOAD_IMAGE) {
            Uri selectedImageUri = data.getData();
            uploadImg.setImageURI(selectedImageUri);

            BitmapDrawable drawable = (BitmapDrawable) uploadImg.getDrawable();
            bitmap = drawable.getBitmap();

            uploadImg.getLocationOnScreen(viewCoords);
        }
    }

    public static Bitmap changeBitmapContrastBrightness(Bitmap bmp, float contrast, float brightness) {
        ColorMatrix cm = new ColorMatrix(new float[]
                {
                        contrast, 0, 0, 0, brightness,
                        0, contrast, 0, 0, brightness,
                        0, 0, contrast, 0, brightness,
                        0, 0, 0, 1, 0
                });

        Bitmap ret = Bitmap.createBitmap(bmp.getWidth(), bmp.getHeight(), bmp.getConfig());

        Canvas canvas = new Canvas(ret);

        Paint paint = new Paint();
        paint.setColorFilter(new ColorMatrixColorFilter(cm));
        canvas.drawBitmap(bmp, 0, 0, paint);

        return ret;


    }

    private class PhotoTapListener implements OnPhotoTapListener {

        @Override
        public void onPhotoTap(ImageView view, float x, float y) {


            float xPercentage = x * 100f;
            float yPercentage = y * 100f;

            XY data = new XY();
            data.x = (xPercentage);
            data.y = (yPercentage);

            String percentages = xPercentage + " " + yPercentage + " " + data.x + " " + data.y;

//                Toast.makeText(getActivity(),percentages, Toast.LENGTH_LONG ).show();

            boolean canAddData = XYDataProvider.addData(data);


            if (canAddData == false) {

                sendDataBtn.setVisibility(View.VISIBLE);

                Toast.makeText(getActivity(), "Ten points active, please clear all data to add more points or send data", Toast.LENGTH_LONG).show();
            }


        }
    }

    private void showToast(CharSequence text) {
        if (mCurrentToast != null) {
            mCurrentToast.cancel();
        }

        mCurrentToast = Toast.makeText(getActivity(), text, Toast.LENGTH_SHORT);
        mCurrentToast.show();
    }


    private class SingleFlingListener implements OnSingleFlingListener {

        @Override
        public boolean onFling(MotionEvent e1, MotionEvent e2, float velocityX, float velocityY) {
            Log.d("PhotoView", String.format(FLING_LOG_STRING, velocityX, velocityY));
            return true;

        }
    }

}

// circles for later
//send JSON to server, with percentages!!!!
//