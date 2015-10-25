//
//  ViewController.swift
//  AppOfTheWeek
//
//  Created by Denis Berton on 22/10/15.
//  Copyright © 2015 AppCorner.it. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {

    private var webView = WKWebView()
    var baseUrl = "http://www.appcorner.it/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.frame = view.bounds
        webView.navigationDelegate = self
        webView.opaque = false;
        webView.backgroundColor = UIColor.clearColor()
        let language = NSLocale.preferredLanguages()[0]
        let itLang = language == "it" || language == "it_IT"
        if(itLang)
        {
            baseUrl += "it/"
            if(UIDevice.currentDevice().userInterfaceIdiom == .Pad)
            {
                baseUrl += "app-in-sconto-ipad.html"
            }
            else{
                baseUrl += "app-in-sconto-iphone.html"
            }
        }
        else
        {
            baseUrl += "en/"
            if(UIDevice.currentDevice().userInterfaceIdiom == .Pad)
            {
                baseUrl += "app-price-drop-ipad.html"
            }
            else{
                baseUrl += "app-price-drop-iphone.html"
            }
        }
        webView.loadRequest(NSURLRequest(URL: NSURL(string: baseUrl)!))
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        let constraintH = NSLayoutConstraint.constraintsWithVisualFormat("H:|[webView]|", options: NSLayoutFormatOptions(rawValue: 0),metrics: nil, views:["webView":webView])
        let constraintV = NSLayoutConstraint.constraintsWithVisualFormat("V:|[webView]|", options: NSLayoutFormatOptions(rawValue: 0),metrics: nil, views: ["webView":webView])
        view.addConstraints(constraintH)
        view.addConstraints(constraintV)
    }
    
    //MARK: WKNavigationDelegate
    
    func webView(webView: WKWebView, didCommitNavigation navigation: WKNavigation!)
    {
        webView.evaluateJavaScript("var meta = document.createElement('meta');meta.setAttribute('name', 'viewport');meta.setAttribute('content', 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no');document.getElementsByTagName('head')[0].appendChild(meta);", completionHandler:nil)
    }
    
    func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void)
    {
        let url = navigationAction.request.URL?.absoluteString
        if((url!.containsString("://itunes.apple.com")))
        {
            UIApplication.sharedApplication().openURL(NSURL(string: (navigationAction.request.URL?.absoluteString.stringByReplacingOccurrencesOfString("https", withString: "itms"))!)!)
            decisionHandler(.Cancel)
        }
        decisionHandler(.Allow)
    }
}

