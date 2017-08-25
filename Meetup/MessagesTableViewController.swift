//
//  MessagesTableViewController.swift
//  Meetup
//
//  Created by Kevin Nguyen on 8/15/17.
//  Copyright © 2017 Kevin Nguyen. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import Kingfisher
import SDWebImage

class MessagesTableViewController: UITableViewController {
    
    let cellId = "cellId"
    var users = [ChatUser]()
    var messages = [ChatMessage]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logoutBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        let showChatUsers = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(handleShowChatUsers))
        navigationItem.setRightBarButtonItems([logoutBarButtonItem, showChatUsers], animated: true)
        
        tableView.register(ChatUserCell.self, forCellReuseIdentifier: cellId)
        
        checkIfUserIsLoggedIn()
        observeMessages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkIfUserIsLoggedIn()
    }

    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 1)
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
    
    func observeMessages() {
        let ref = Database.database().reference().child("messages").observe(DataEventType.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                let message = ChatMessage()
                message.setValuesForKeys(dictionary)
                self.messages.append(message)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }, withCancel: nil)

    }
    
    func handleLogout() {
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        let loginViewController = LoginViewController()
        self.present(loginViewController, animated: true, completion: nil)
    }
    
    func handleShowChatUsers() {
        let chatUsersViewController = ChatUsersTableViewController()
        chatUsersViewController.messagesController = self
        let navController = UINavigationController(rootViewController: chatUsersViewController)
        self.present(navController, animated: true, completion: nil)
    }
    
    func showShowChatLog(for user: ChatUser) {
        let chatLogController = ChatLogViewController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.user = user
        self.navigationController?.pushViewController(chatLogController, animated: true)
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ChatUserCell
        let message = messages[indexPath.row]
        
        cell.message = message
        
        cell.layoutIfNeeded()
        cell.setNeedsLayout()
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let user = users[indexPath.row]
//        let chatLogViewController = ChatLogViewController(collectionViewLayout: UICollectionViewFlowLayout())
//        chatLogViewController.user = user
//        self.navigationController?.pushViewController(chatLogViewController, animated: true)
//    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
