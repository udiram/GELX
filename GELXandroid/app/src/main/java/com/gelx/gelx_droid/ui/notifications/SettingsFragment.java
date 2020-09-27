package com.gelx.gelx_droid.ui.notifications;

import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import androidx.lifecycle.Observer;
import androidx.lifecycle.ViewModelProviders;

import com.gelx.gelx_droid.HomeActivity;
import com.gelx.gelx_droid.R;
import com.gelx.gelx_droid.ui.login.LoginActivity;
import com.google.android.gms.auth.api.signin.GoogleSignIn;
import com.google.android.gms.auth.api.signin.GoogleSignInClient;
import com.google.android.gms.auth.api.signin.GoogleSignInOptions;
import com.google.firebase.auth.FirebaseAuth;

public class SettingsFragment extends Fragment {


    public View onCreateView(@NonNull LayoutInflater inflater,
                             ViewGroup container, Bundle savedInstanceState) {

        View root = inflater.inflate(R.layout.fragment_settings, container, false);

        Button signOut = root.findViewById(R.id.signOutBtn);

        signOut.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                GoogleSignInOptions gso = new GoogleSignInOptions.
                        Builder(GoogleSignInOptions.DEFAULT_SIGN_IN).
                        build();
                GoogleSignInClient googleSignInClient= GoogleSignIn.getClient(getActivity(), gso);
                googleSignInClient.signOut();

                signOutComplete();

            }
        });
        return root;
    }

    FirebaseAuth.AuthStateListener authStateListener = new FirebaseAuth.AuthStateListener() {
        @Override
        public void onAuthStateChanged(@NonNull FirebaseAuth firebaseAuth) {
            if (firebaseAuth.getCurrentUser() == null){
                //Do anything here which needs to be done after signout is complete
                signOutComplete();
            }
        }
    };

    private void signOutComplete() {
        Intent success = new Intent(getActivity(), LoginActivity.class);
        startActivity(success);
        getActivity().finish();
    }
}