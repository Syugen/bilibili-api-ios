//
//  UserSearchController.swift
//  BilibiliAPI
//
//  Created by Yuan Zhou on 2017/11/12.
//  Copyright © 2017年 Yuan Zhou. All rights reserved.
//

import UIKit

class UserSearchController: UITableViewController {

    @IBOutlet weak var upName: UILabel!
    @IBOutlet weak var upImage: UIImageView!
    @IBOutlet weak var upsign: UILabel!
    @IBOutlet weak var videoamount: UILabel!
    @IBOutlet weak var following: UILabel!
    @IBOutlet weak var follower: UILabel!
    @IBOutlet weak var favoriteIcon: UIButton!
    
    let searchBar = UISearchBar()
    var searchButtonPressed = false
    
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
        reset_views()
        if self.searchButtonPressed {
            self.searchButtonPressed = false
            search()
        }
    }
    
    func reset_views() {
    }

    @objc func searchPressed(_ sender: UIBarButtonItem) {
        //search()
    }
    
    func search() {
        self.reset_views()
        //self.videoName.text = "Searching " + searchBar.text!
        self.searchBar.resignFirstResponder()
        if Int(self.searchBar.text!) == nil {
            let alertController = UIAlertController(title: "Error", message:
                "Video ID should be an integer", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        } else {
            //get_request("bili_video", "https://api.bilibili.com/archive_stat/stat?aid=" + self.searchBar.text!)
            //get_request("jiji_video", "http://www.jijidown.com/Api/AvToCid/" + self.searchBar.text!)
            //get_request("webpage", "http://bili.utoptutor.com/videopage?aid=" + self.searchBar.text!)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParentViewController {
            searchBar.resignFirstResponder()
            if #available(iOS 11.0, *) {
                searchBar.isHidden = true
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if #available(iOS 11.0, *) {
            searchBar.isHidden = false
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
