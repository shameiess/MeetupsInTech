//
//  SideMenuViewController.swift
//  Meetup
//
//  Created by Kevin Nguyen on 7/28/17.
//  Copyright © 2017 Kevin Nguyen. All rights reserved.
//

import UIKit
import SideMenu

class SideMenuViewController: UITableViewController {

    let items = ["Yelp","Second","Third","Fourth"]

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "sideMenuCell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.row)!")
        if (indexPath.row == 0) {
            self.navigationController?.pushViewController(YelpViewController(), animated: true)
        }
        else {
//            let messagesTableViewController = MessagesTableViewController()
//            let navController = UINavigationController(rootViewController: messagesTableViewController)
//            self.present(navController, animated: true, completion: nil)
            self.navigationController?.pushViewController(MessagesTableViewController(), animated: true)
//            self.present(MessagesTableViewController(), animated: true, completion: nil)
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
