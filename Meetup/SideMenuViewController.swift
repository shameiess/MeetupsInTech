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

    let items = ["❗️Yelp","🔥 Firebase Chat", "📝 CoreData NBA 🏀", "👾 ARKit", "🧠 CoreML + Vision"]

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
        switch indexPath.row {
        case 0:
            self.navigationController?.pushViewController(YelpViewController(), animated: true)
        case 1:
            self.navigationController?.pushViewController(MessagesTableViewController(), animated: true)
        case 2:
            self.navigationController?.pushViewController(WarriorsTableViewController(), animated: true)
        case 3:
            let storyboard = UIStoryboard(name: "ARKit", bundle: nil)
            let viewController = storyboard.instantiateInitialViewController()
            self.present(viewController!, animated: true, completion: nil)
        case 4:
            let storyboard = UIStoryboard(name: "Classification", bundle: nil)
            let viewController = storyboard.instantiateInitialViewController()
            self.present(viewController!, animated: true, completion: nil)
        default:
            return
        }
    }
}
