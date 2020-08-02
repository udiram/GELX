package com.gelx.gelx_droid.ui.home;

import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.ColorMatrix;
import android.graphics.ColorMatrixColorFilter;
import android.graphics.Matrix;
import android.graphics.Paint;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.LayerDrawable;
import android.net.Uri;
import android.os.Bundle;
import android.provider.MediaStore;
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

import static com.gelx.gelx_droid.ContrastActivity.changeBitmapContrastBrightness;

public class HomeFragment extends Fragment {
    private static final int RESULT_LOAD_IMAGE = 1000;
    private HomeViewModel homeViewModel;
    private ImageView uploadImg;
    private int[] viewCoords = new int[2];
    SeekBar seekbar;
    TextView contrastval;
    private Bitmap bitmap;


    public View onCreateView(@NonNull LayoutInflater inflater,
                             ViewGroup container, Bundle savedInstanceState) { View root = inflater.inflate(R.layout.fragment_home, container, false);
//        final TextView textView = root.findViewById(R.id.text_home);

        final Button uploadBtn = root.findViewById(R.id.uploadBtn);
        uploadImg = root.findViewById(R.id.uploadedImageView);
        seekbar = (SeekBar) root.findViewById(R.id.seekbar);
        contrastval = (TextView) root.findViewById(R.id.contrastValue);

        seekbar.setOnSeekBarChangeListener(new SeekBar.OnSeekBarChangeListener() {
            @Override
            public void onProgressChanged(SeekBar seekBar, int progress, boolean b) {
                if (bitmap != null) {
                    uploadImg.setImageBitmap(changeBitmapContrastBrightness(bitmap, (float) progress / 100f, 1));
                }
                contrastval.setText("Contrast: "+(float) progress / 100f);
            }

            @Override
            public void onStartTrackingTouch(SeekBar seekBar) {}

            @Override
            public void onStopTrackingTouch(SeekBar seekBar) {}
        });

        seekbar.setMax(2000);
        seekbar.setProgress(100);

        final Drawable[] layers = new Drawable[2];

        final Canvas c;
        final Bitmap bm2;


        uploadImg.setOnTouchListener(new View.OnTouchListener() {
            @Override
            public boolean onTouch(View view, MotionEvent motionEvent) {


                int touchX = (int) motionEvent.getX();
                int touchY = (int) motionEvent.getY();

                int imageX = touchX - viewCoords[0]; // viewCoords[0] is the X coordinate
                int imageY = touchY - viewCoords[1]; // viewCoords[1] is the y coordinate


                XY data = new XY();
                data.x = imageX;
                data.y = imageY;
                XYDataProvider.addData(data);
                XYDataProvider.sendDataToServer();

                Bitmap bm = ((BitmapDrawable)uploadImg.getDrawable()).getBitmap();


                Bitmap.Config config = bm.getConfig();
                int width = bm.getWidth();
                int height = bm.getHeight();

                Bitmap bm2 = Bitmap.createBitmap(width, height, config);
                Canvas c = new Canvas(bm2);

                c.drawBitmap(bm, 0, 0, null);
                Paint p = new Paint();


                Bitmap repeat = BitmapFactory.decodeResource(getResources(), R.drawable.gelx);
                Bitmap repeat2 = Bitmap.createScaledBitmap(repeat, 50, 50, false);
                c.drawBitmap(repeat2, touchX, touchY,p);

                uploadImg.setImageBitmap(bm2);

                return false;

            }

        });

        uploadBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                Intent galleryIntent = new Intent(Intent.ACTION_PICK,
                        MediaStore.Images.Media.EXTERNAL_CONTENT_URI);
                galleryIntent.setType("image/*");
                startActivityForResult(galleryIntent, RESULT_LOAD_IMAGE);
            }
        });
        homeViewModel =
                ViewModelProviders.of(this).get(HomeViewModel.class);

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

        return root;
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
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
}