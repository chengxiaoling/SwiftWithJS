//
//  ViewController.swift
//  SwiftWithJS
//
//  Created by kayling on 2018/7/2.
//  Copyright © 2018年 Kayling. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

//    var bridge:WebViewJavascriptBridge?
    lazy var webView:WKWebView = {
        let web = WKWebView.init(frame: self.view.bounds)
        web.navigationDelegate = self
        view.addSubview(web)
        return web
    }()
    lazy var bridge:WebViewJavascriptBridge = {
    
        let bri = WebViewJavascriptBridge.init(webView)
        return bri!
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bridge.setWebViewDelegate(self)
        
        bridge.registerHandler("testObjcCallback") { (data, responseCallback) in
            print("testObjcCallback called:\(String(describing: data))")
            responseCallback!("Response from testObjcCallback")
        }
        
        bridge.callHandler("testJavascriptHandler", data: ["name": "标哥"]) { (responseData) in
            print("from js:\(String(describing: responseData))")
        }
        
        loadExamplePage()
        renderButtons()
    }
    
    func loadExamplePage() {
        let htmlPath = Bundle.main.path(forResource: "ExampleApp", ofType: "html")
        let appHtml = try? String.init(contentsOfFile: htmlPath!, encoding: String.Encoding.utf8)
        let baseURL = URL.init(fileURLWithPath: htmlPath!)
        webView.loadHTMLString(appHtml!, baseURL: baseURL)
    }
    
    func renderButtons() {
        let callbackButton:UIButton = UIButton.init(type: .roundedRect)
        callbackButton.setTitle("Call", for: .normal)
        callbackButton.addTarget(self, action: #selector(callHandler), for: .touchUpInside)
        view.insertSubview(callbackButton, aboveSubview: webView)
        callbackButton.frame = CGRect.init(x: 100, y: 400, width: 100, height: 35)
        callbackButton.titleLabel?.font = UIFont.init(name: "HelveticaNeue", size: 12.0)
    }
    
    @objc func callHandler() {
        let data = ["greetingFromObjC":"Hi there, JS!"]
        bridge.callHandler("testJavascriptHandler", data: data) { (response) in
            print(response!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}
extension ViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("webViewDidStartLoad")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("webViewDidFinishLoad")
    }
}

