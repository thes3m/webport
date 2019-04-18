//
//  ViewController.swift
//  webport
//
//  Created by Samo Pajk on 15/04/2019.
//  Copyright © 2019 Razum d.o.o. All rights reserved.
//

import UIKit
import WebKit

class WebPortController: UIViewController, WKNavigationDelegate {
    private var webSrcDir: String = "build"
    private var webview: WKWebView!
    
    override func viewDidLoad(){
        // Do any additional setup after loading the view, typically from a nib.
        super.viewDidLoad()
        
        //Create webview and add it as view child
        webview = WKWebView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        webview.navigationDelegate = self
        self.view.addSubview(webview)
        
        if let devServerAddress = getDevServerAddress() { // Try get dev server address and if exists load it
            print("Loading page from dev server:\(devServerAddress)")
            webview.load(URLRequest(url: devServerAddress))
        }else if let path = Bundle.main.path(forResource:"index", ofType:"html", inDirectory:webSrcDir){ //Load index html that is bundles with app
            let indexFileUrl = URL(fileURLWithPath:path)
            print("Loading page from local index file.")
            
            if let data = try? Data(contentsOf: indexFileUrl), let htmlString = String(data: data, encoding: .utf8), htmlString.contains("base href") == true {
                print("WARNING detected <base href> in index.html, webpage might not show up properly")
            }
            
            let readDirectory = URL(fileURLWithPath:(path as NSString).deletingLastPathComponent)
            webview.loadFileURL(indexFileUrl, allowingReadAccessTo:readDirectory)
        }else{
            print("Error cannot find index.html, or webserver address!")
        }
    }

    func getDevServerAddress    () -> URL? {
        //Read a "webserver" file from build directory and if it exists use its contents as dev server address
        if let webserverAddressFile = Bundle.main.path(forResource:"webserver", ofType:"", inDirectory:webSrcDir), let data = try? Data(contentsOf: URL(fileURLWithPath:webserverAddressFile)), let address = String(data: data, encoding: .utf8)?.trimmingCharacters(in:CharacterSet(arrayLiteral:"\n")) {
            return address.count > 5 ? URL(string:address) : nil
        }
        return nil
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!){
        
    }
    
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error){
        print("Error loading page:\(webView.url) error:\(error)")
    }
}

