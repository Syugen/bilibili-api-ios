//
//  WebKitController.swift
//  BilibiliAPI
//
//  Created by Yuan Zhou on 2017/10/29.
//  Copyright © 2017年 Yuan Zhou. All rights reserved.
//

import UIKit
import WebKit

class WebKitController: UIViewController, WKUIDelegate {

    var webView: WKWebView!
    var urlStr: String!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let myURL = URL(string: "https://www.bilibili.com/video/av" + self.urlStr + "/")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
