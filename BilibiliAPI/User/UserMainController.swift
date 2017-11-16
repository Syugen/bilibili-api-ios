//
//  UserMainController.swift
//  BilibiliAPI
//
//  Created by Yuan Zhou on 2017/11/12.
//  Copyright © 2017年 Yuan Zhou. All rights reserved.
//

import UIKit

class UserMainController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var favoriteTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        favoriteTable.dataSource = self
        favoriteTable.delegate = self
        favoriteTable.rowHeight = 70
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(UserDBChange), object: DB.shared, queue: nil) {
            (NSNotification) in
            if DB.shared.shouldReload {
                self.favoriteTable.reloadData()
            }
            let userImages = NSKeyedArchiver.archivedData(withRootObject: DB.shared.userImgs)
            UserDefaults.standard.set(userImages, forKey: UserImgs)
            UserDefaults.standard.set(DB.shared.userIDs, forKey: UserIDs)
            UserDefaults.standard.set(DB.shared.userNames, forKey: UserNames)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Favorite Users".localized
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DB.shared.userIDs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userReusedCell", for: indexPath) as! UserCell
        cell.userID?.text = DB.shared.userIDs[indexPath.row]
        cell.userName?.text = DB.shared.userNames[indexPath.row]
        cell.userImg?.image = DB.shared.userImgs[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alertController = UIAlertController(title: "", message: "Do you really want to remove this user?".localized, preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Yes".localized, style: UIAlertActionStyle.destructive, handler: {
                (action) -> Void in
                DB.shared.shouldReload = false
                DB.shared.userNames.remove(at: indexPath.row)
                DB.shared.userImgs.remove(at: indexPath.row)
                DB.shared.userIDs.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                DB.shared.shouldReload = true
            }))
            alertController.addAction(UIAlertAction(title: "Cancel".localized, style: UIAlertActionStyle.cancel, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let cell = sender as? UserCell {
            let vcDest = segue.destination as! UserSearchController
            vcDest.searchBar.text = cell.userID?.text
            vcDest.searchButtonPressed = true
        }
    }

}
