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
    var progressView: UIProgressView!
    var urlStr: String!
    var finished: Bool!
    var timer: Timer!
    
    override func loadView() {
        self.webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
        self.webView.uiDelegate = self
        view = self.webView
        
        self.finished = false
        self.timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: true)
        
        self.progressView = UIProgressView()
        view.addSubview(self.progressView)
        let navFrame = navigationController?.navigationBar.frame
        let y = (navFrame?.origin.y)! + (navFrame?.size.height)! + 1
        self.progressView.frame = CGRect(x: 0, y: y, width: (navFrame?.size.width)!, height: 1)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let myURL = URL(string: "https://www.bilibili.com/video/av" + self.urlStr + "/")
        let myRequest = URLRequest(url: myURL!)
        self.webView.load(myRequest)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func timerCallback() {
        if self.webView.isLoading {
            self.progressView.progress = Float(webView.estimatedProgress)
        } else {
            self.progressView.isHidden = true
            self.timer.invalidate()
        }
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
