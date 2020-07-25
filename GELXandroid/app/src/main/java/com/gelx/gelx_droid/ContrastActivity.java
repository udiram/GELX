package com.gelx.gelx_droid;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.ColorMatrix;
import android.graphics.ColorMatrixColorFilter;
import android.graphics.Paint;
import android.os.Bundle;
import androidx.appcompat.app.AppCompatActivity;
import android.widget.ImageView;
import android.widget.SeekBar;
import android.widget.TextView;

public class ContrastActivity extends AppCompatActivity {

    ImageView imageView;
    SeekBar seekbar;
    TextView textView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_contrast);
        imageView = (ImageView) findViewById(R.id.image);
        textView = (TextView) findViewById(R.id.label);

        seekbar = (SeekBar) findViewById(R.id.seekbar);
        seekbar.setOnSeekBarChangeListener(new SeekBar.OnSeekBarChangeListener() {
            @Override
            public void onProgressChanged(SeekBar seekBar, int progress, boolean b) {
                imageView.setImageBitmap(changeBitmapContrastBrightness(BitmapFactory.decodeResource(getResources(), R.drawable.gelx), (float) progress / 100f, 1));
                textView.setText("Contrast: "+(float) progress / 100f);
            }

            @Override
            public void onStartTrackingTouch(SeekBar seekBar) {}

            @Override
            public void onStopTrackingTouch(SeekBar seekBar) {}
        });

        seekbar.setMax(200);
        seekbar.setProgress(100);
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