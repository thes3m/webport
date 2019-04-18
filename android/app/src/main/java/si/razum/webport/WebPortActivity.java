package si.razum.webport;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

public class WebPortActivity extends AppCompatActivity {
    private String firstHTMLFileName = "index.html";
    private WebView webview;
    private WebViewClient webViewClient;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_webport);

        webViewClient = new WebViewClient();

        //Set webview settings
        webview = (WebView) findViewById(R.id.webport_main_webview);
        WebSettings settings = webview.getSettings();
        settings.setJavaScriptEnabled(true);
        webview.setWebViewClient(webViewClient);

        String webserverAddress = GetWebServerAddress();
        if (webserverAddress != null) {
            System.out.print("Opening webserver page:" + webserverAddress);
            webview.loadUrl(webserverAddress);
        }else{
            //Open assets file
            System.out.print("Opening local " + firstHTMLFileName + " file.");
            webview.loadUrl("file:///android_asset/" + firstHTMLFileName);
        }
    }

    private String GetWebServerAddress(){
        BufferedReader reader = null;
        try {
            reader = new BufferedReader(new InputStreamReader(getAssets().open("webserver"), "UTF-8"));

            String webserverAddress = reader.readLine();
            // do reading, usually loop until end of file reading
            reader.close();
            return  webserverAddress.length() > 5 ? webserverAddress : null;
        } catch (IOException e) {
            //log the exception
        } finally {
            if (reader != null) {
                try {
                    reader.close();
                } catch (IOException e) {
                    //log the exception
                }
            }
        }
        return null;
    }

    @Override
    public void onBackPressed() {
        if(webview.canGoBack()) {
            webview.goBack();
        } else {
            super.onBackPressed();
        }
    }
}
