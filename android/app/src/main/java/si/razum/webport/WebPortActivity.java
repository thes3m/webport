package si.razum.webport;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;

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

        //Open assets file
        webview.loadUrl("file:///android_asset/" + firstHTMLFileName);
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
