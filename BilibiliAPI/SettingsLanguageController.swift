//
//  SettingsLanguageController.swift
//  BilibiliAPI
//
//  Created by Yuan Zhou on 2017/11/15.
//  Copyright © 2017年 Yuan Zhou. All rights reserved.
//

import UIKit

class SettingsLanguageController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                UserDefaults.standard.set([], forKey: "AppleLanguages")
            } else if indexPath.row == 1 {
                UserDefaults.standard.set(["en"], forKey: "AppleLanguages")
            } else if indexPath.row == 2 {
                UserDefaults.standard.set(["zh-Hans"], forKey: "AppleLanguages")
            }
            UserDefaults.standard.synchronize()
            tableView.deselectRow(at: indexPath, animated: true)
            let alertController = UIAlertController(title: "Language is reset".localized, message:
                "Sorry for the inconvenience, but for current version, you need to restart the app manually to display new language.".localized, preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
