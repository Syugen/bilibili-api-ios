//
//  VideoSearchController.swift
//  BilibiliAPI
//
//  Created by Yuan Zhou on 2017/10/15.
//  Copyright © 2017年 Yuan Zhou. All rights reserved.
//

import UIKit

class VideoSearchController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var videoName: UILabel!
    @IBOutlet weak var upName: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var videoImage: UIImageView!
    @IBOutlet weak var upImage: UIImageView!
    let searchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.titleView = searchBar
        self.searchBar.keyboardType = UIKeyboardType.numberPad
        self.searchBar.becomeFirstResponder()
        if #available(iOS 11.0, *) {
            self.searchBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
        }
        
        let searchButton = UIBarButtonItem(title: "Search", style: .plain, target: self, action: #selector(searchPressed))
        self.navigationItem.setRightBarButton(searchButton, animated: true)
    }
    
    @objc func searchPressed(_ sender: UIBarButtonItem) {
        self.searchBar.resignFirstResponder()
        self.videoName.text = "Searching " + searchBar.text!
        let url = URL(string: "http://bili.utoptutor.com/biliapi_videoinfo?aid=" + self.searchBar.text!)
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if let data = data {
                do {
                    // Convert the data to JSON
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String : Any]
                    self.displayInfo(json)
                    
                }  catch let error as NSError {
                    print(error.localizedDescription)
                }
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    func displayInfo(_ json: [String : Any]) {
        let jiji = json["jiji"] as! [String : Any]
        let web = json["web"] as! [String : Any]
        
        DispatchQueue.main.async(execute: {
            if json["code"] as! Int != 0 {
                self.videoName.text = "Video not found"
                return
            }
            if web["error"] as! Bool == true {
                self.videoName.text = jiji["title"] as? String
                self.upName.text = "Uploader: " + (jiji["up"] as! String)
                let upimgurl = URL(string: jiji["upimg"] as! String)
                let upimg = try? Data(contentsOf: upimgurl!)
                self.upImage.image = UIImage(data: upimg!)
            } else {
                self.videoName.text = web["title"] as? String
                self.upName.text = "Uploader: " + (web["upName"] as! String)
                let upimgurl = URL(string: web["upAvatar"] as! String)
                let upimg = try? Data(contentsOf: upimgurl!)
                self.upImage.image = UIImage(data: upimg!)
            }
            let imgurl = URL(string: jiji["img"] as! String)
            let img = try? Data(contentsOf: imgurl!)
            self.videoImage.image = UIImage(data: img!)
        })
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParentViewController {
            searchBar.resignFirstResponder()
            searchBar.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        searchBar.isHidden = false
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
