//
//  ViewController.swift
//  webport
//
//  Created by Samo Pajk on 15/04/2019.
//  Copyright © 2019 Razum d.o.o. All rights reserved.
//

import UIKit
import WebKit
import Swifter

class WebPortController: UIViewController, WKNavigationDelegate, WKUIDelegate {
    private var localWebserverUrl: String = "http://localhost:8080"
    private var webSrcDir: String = "build"
    private var webview: WKWebView!
    private var server: HttpServer = HttpServer()
    
    override func viewDidLoad(){
        // Do any additional setup after loading the view, typically from a nib.
        super.viewDidLoad()
        
        let config = WKWebViewConfiguration()
        config.preferences.javaScriptEnabled = true
        config.preferences.javaScriptCanOpenWindowsAutomatically = true
        
        //Create webview and add it as view child
        webview = WKWebView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height),configuration:config)
        webview.navigationDelegate = self
        webview.uiDelegate = self
        webview.scrollView.isScrollEnabled = false
        self.view.addSubview(webview)
        
        if let devServerAddress = getDevServerAddress() { // Try get dev server address and if exists load it
            print("Loading page from dev server:\(devServerAddress)")
            webview.load(URLRequest(url: devServerAddress))
        }else if Bundle.main.path(forResource:"index", ofType:"html", inDirectory:webSrcDir) != nil{ //Load index html that is bundles with app
            setLocalHttpServer()
            
            print("Loading local index.html file.")
            let indexFileUrl = URL(string: "http://localhost:8080/index.html")!
            webview.load(URLRequest(url: indexFileUrl))
        }else{
            print("Error cannot find index.html, or webserver address!")
        }
    }
    
    func setLocalHttpServer(){
        server.middleware.append({ request in
            //Handle all requests to localhost:8080 by trying to serve files available in webSrcDir
            var filePath = request.path
            if filePath.hasSuffix("/"){
                filePath += "index.html"
            }
            filePath = self.webSrcDir + "/" + filePath
            
            if let path = Bundle.main.path(forResource:filePath, ofType:"", inDirectory:nil), let data = try? Data(contentsOf: URL(fileURLWithPath: path)){ //Relative url to application directory
                return HttpResponse.ok(HttpResponseBody.data(data))
            }else{
                print("Failed to find file:\(request.path)")
                return HttpResponse.notFound
            }
        })
        do {
            try server.start(8080, forceIPv4: true, priority: DispatchQoS.QoSClass.default)
        } catch {
            print("Error starting local webserver: \(error)")
        }
        
    }

    private func getDevServerAddress    () -> URL? {
        //Read a "webserver" file from build directory and if it exists use its contents as dev server address
        if let webserverAddressFile = Bundle.main.path(forResource:"webserver", ofType:"", inDirectory:webSrcDir), let data = try? Data(contentsOf: URL(fileURLWithPath:webserverAddressFile)), let address = String(data: data, encoding: .utf8)?.trimmingCharacters(in:CharacterSet(arrayLiteral:"\n")) {
            return address.count > 5 ? URL(string:address) : nil
        }
        return nil
    }
    
    // this handles target=_blank links by opening them in the same view
    public func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        return nil
    }
    
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error){
        print("Error loading page:\(String(describing:webView.url)) error:\(error)")
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(WKNavigationActionPolicy.allow)
    }
}

