//
//  TodayViewController.swift
//  AppOfTheWeekExtension
//
//  Created by Denis Berton on 22/10/15.
//  Copyright © 2015 AppCorner.it. All rights reserved.
//

import UIKit
import NotificationCenter
import WebKit

class TodayViewController: UIViewController, NCWidgetProviding, WKNavigationDelegate {
    
    private var webView = WKWebView()
    let banner_width = 728
    let banner_height = 90
    
    override func viewDidLoad() {
        super.viewDidLoad()
        preferredContentSize = CGSizeMake(1,CGFloat(banner_height/2))
        
        webView.navigationDelegate = self
        webView.opaque = false;
        webView.backgroundColor = UIColor.clearColor()
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        let constraintH = NSLayoutConstraint.constraintsWithVisualFormat("H:|[webView]|", options: NSLayoutFormatOptions(rawValue: 0),metrics: nil, views:["webView":webView])
        let constraintV = NSLayoutConstraint.constraintsWithVisualFormat("V:|[webView]|", options: NSLayoutFormatOptions(rawValue: 0),metrics: nil, views: ["webView":webView])
        view.addConstraints(constraintH)
        view.addConstraints(constraintV)
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        // Perform any! setup necessary in order to update the view.
        let htmlSting = "<html><head></head><body><div id='ibb-widget-root'></div><script>(function(t,e,i,d){var o=t.getElementById(i),n=t.createElement(e);o.style.height=\(banner_height);o.style.width=\(banner_width);o.style.display='inline-block';n.id='ibb-widget',n.setAttribute('src',('https:'===t.location.protocol?'https://':'http://')+d),n.setAttribute('width','\(banner_width)'),n.setAttribute('height','\(banner_height)'),n.setAttribute('frameborder','0'),n.setAttribute('scrolling','no'),o.appendChild(n)})(document,'iframe','ibb-widget-root',\"banners.itunes.apple.com/banner.html?partnerId=&aId=1l3v7u2&bt=cms_promotional&cid=aWzWv97gDs&c=us&l=\(NSLocale.preferredLanguages()[0])&w=\(banner_width)&h=\(banner_height)\");</script></body></html>"
        webView.loadHTMLString(htmlSting, baseURL: nil)
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(NCUpdateResult.NewData)
    }
 
    //MARK: WKNavigationDelegate
    
    func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void)
    {
        let url = navigationAction.request.URL?.absoluteString
        if((url!.containsString("://itunes.apple.com")))
        {
            let urlString = navigationAction.request.URL?.absoluteString
            let range: Range<String.Index> = (urlString?.rangeOfString("/id"))!
            let index = urlString!.startIndex.advancedBy((urlString?.startIndex.distanceTo(range.startIndex))!)
            //itms scheme url open iTunes instead of App Store.
            let str = "https://itunes.apple.com/app"+urlString!.substringFromIndex(index)
            extensionContext!.openURL(NSURL(string:str)!, completionHandler: nil)
            decisionHandler(.Cancel)
        }
        decisionHandler(.Allow)
    }
}
