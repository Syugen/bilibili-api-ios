//
//  SettingsController.swift
//  BilibiliAPI
//
//  Created by Yuan Zhou on 2017/11/14.
//  Copyright © 2017年 Yuan Zhou. All rights reserved.
//

import UIKit

class SettingsController: UITableViewController {
    
    @IBOutlet weak var mySwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if !DB.shared.downloadImage {
            self.mySwitch.setOn(false, animated: false)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            if indexPath.row == 0 {
                let alertController = UIAlertController(title: "", message:
                    "Do you really want to remove all favorite videos in your collection?".localized, preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Yes".localized, style: UIAlertActionStyle.destructive, handler: {
                    (action) -> Void in
                    DB.shared.removeVideos()
                }))
                alertController.addAction(UIAlertAction(title: "Cancel".localized, style: UIAlertActionStyle.cancel, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                tableView.deselectRow(at: indexPath, animated: true)
            } else if indexPath.row == 1 {
                let alertController = UIAlertController(title: "", message:
                    "Do you really want to remove all favorite users in your collection?".localized, preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Yes".localized, style: UIAlertActionStyle.destructive, handler: {
                    (action) -> Void in
                    DB.shared.removeUsers()
                }))
                alertController.addAction(UIAlertAction(title: "Cancel".localized, style: UIAlertActionStyle.cancel, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
    }
    
    @IBAction func downloadImageSwitchChanged(_ sender: Any) {
        if let mySwitch = sender as? UISwitch {
            if mySwitch.isOn {
                DB.shared.downloadImage = true
            } else {
                DB.shared.downloadImage = false
            }
            UserDefaults.standard.set(DB.shared.downloadImage, forKey: DownloadImage)
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
