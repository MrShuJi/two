//
//  webViewController.swift
//  two
//
//  Created by shuji on 2017/10/16.
//  Copyright © 2017年 shuji. All rights reserved.
//

import UIKit


class webViewController: UIViewController, UIWebViewDelegate {
    
    var detailURL = "http://www.baidu.com"
    var webViews: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.webViews = UIWebView()
        
        self.pleaseWait()
        webViews.frame = view.bounds
        let url = NSURL(string: detailURL);
       // let request = NSURLRequest(url: url as! URL);
        
        
        
        webViews.loadHTMLString(detailURL, baseURL: nil)
         webViews.scalesPageToFit = true
        self.webViews.delegate = self
        // Do any additional setup after loading the view.
        
         view.addSubview(webViews)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //webView代理方法,网页内容加载完成时调用
    func webViewDidFinishLoad(_ webView:UIWebView){
        self.clearAllNotice()
        
    }
    
    //webView代理方法,链接地址发生改变的时候调用
    func webView(_ webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool{
        
        return true
    }
    
}
