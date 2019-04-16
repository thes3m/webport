//
//  ViewController.swift
//  webport
//
//  Created by Samo Pajk on 15/04/2019.
//  Copyright © 2019 Razum d.o.o. All rights reserved.
//

import UIKit
import WebKit

class WebPortController: UIViewController {
    private var webSrcDir: String = "build"
    private var webview: WKWebView!
    
    override func viewDidLoad(){
        // Do any additional setup after loading the view, typically from a nib.
        super.viewDidLoad()
        
        //Create webview and add it as view child
        webview = WKWebView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        self.view.addSubview(webview)
        
        //Load index html
        if let path = Bundle.main.path(forResource:"index", ofType:"html", inDirectory:webSrcDir){
            let indexFileUrl = URL(fileURLWithPath:path)
            
            if let data = try? Data(contentsOf: indexFileUrl), let htmlString = String(data: data, encoding: .utf8), htmlString.contains("base href") == true {
                print("WARNING detected <base href> in index.html, webpage might not show up properly")
            }
            
            let readDirectory = URL(fileURLWithPath:(path as NSString).deletingLastPathComponent)
            webview.loadFileURL(indexFileUrl, allowingReadAccessTo:readDirectory)
        }else{
            print("Error cannot find index.html, make sure that file exists")
        }
        
    }


}

