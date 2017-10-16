//
//  VideoSearchController.swift
//  BilibiliAPI
//
//  Created by Yuan Zhou on 2017/10/15.
//  Copyright © 2017年 Yuan Zhou. All rights reserved.
//

import UIKit

class VideoSearchController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var content: UILabel!
    let searchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.titleView = searchBar
        searchBar.keyboardType = UIKeyboardType.numberPad
        searchBar.becomeFirstResponder()
        if #available(iOS 11.0, *) {
            searchBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
        }
        
        let searchButton = UIBarButtonItem(title: "Search", style: .plain, target: self, action: #selector(searchPressed))
        self.navigationItem.setRightBarButton(searchButton, animated: true)
    }
    
    @objc func searchPressed(_ sender: Any) {
        searchBar.resignFirstResponder()
        content.text = "Searching " + searchBar.text!
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParentViewController {
            // Your code...
            searchBar.resignFirstResponder()
            searchBar.isHidden = true
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
