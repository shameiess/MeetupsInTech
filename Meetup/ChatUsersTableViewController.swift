//
//  ChatUsersTableViewController.swift
//  Meetup
//
//  Created by Kevin Nguyen on 8/24/17.
//  Copyright © 2017 Kevin Nguyen. All rights reserved.
//

import UIKit
import Firebase

class ChatUsersTableViewController: UITableViewController {

    let cellId = "cellId"
    var users = [ChatUser]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        tableView.register(ChatUserCell.self, forCellReuseIdentifier: cellId)
        
        //checkIfUserIsLoggedIn()
        //fetchUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkIfUserIsLoggedIn()
    }
    
    func fetchUser() {
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: Any] {
                let user = ChatUser()
                user.id = snapshot.key
                user.setValuesForKeys(dictionary)
                // ^will crash if key is not correct or use safer way:
                //                user.name = dictionary["name"] as? String
                //                user.email = dictionary["email"] as? String
                //                user.profileImageURL = dictionary["profileImageURL"] as? String
                self.users.append(user)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }, withCancel: nil)
    }
    
    func checkIfUserIsLoggedIn() {
        self.users.removeAll()
        
        if Auth.auth().currentUser == nil {
            perform(#selector(handleCancel), with: nil, afterDelay: 1)
        } else {
            let uid = Auth.auth().currentUser?.uid
            Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                print(snapshot)
                if let dictionary = snapshot.value as? [String: Any] {
                    self.navigationItem.title = dictionary["name"] as? String
                    self.fetchUser()
                }
            })
        }
    }
    
    func handleCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ChatUserCell
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        if let profileImageURL = user.profileImageURL {
            let url = URL(string: profileImageURL)
            cell.profileImageView.kf.setImage(with: url, placeholder: UIImage(), options: [.transition(.fade(0.1))])
        }
        
        cell.layoutIfNeeded()
        cell.setNeedsLayout()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        let chatLogViewController = ChatLogViewController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogViewController.user = user
        self.navigationController?.pushViewController(chatLogViewController, animated: true)
    }

}
