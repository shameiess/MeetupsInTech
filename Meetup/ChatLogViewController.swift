//
//  ChatLogViewController.swift
//  Meetup
//
//  Created by Kevin Nguyen on 8/22/17.
//  Copyright © 2017 Kevin Nguyen. All rights reserved.
//

import UIKit
import Firebase

class ChatLogViewController: UICollectionViewController {
    
    var user: ChatUser? {
        didSet {
            self.navigationItem.title = user?.name
        }
    }

    lazy var inputTextField: UITextField = {
        let inputTextField = UITextField()
        inputTextField.placeholder = "Enter message..."
        inputTextField.translatesAutoresizingMaskIntoConstraints = false
        inputTextField.delegate = self
        return inputTextField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = UIColor.white
        
        setupInputContainerView()
    }
    
    func setupInputContainerView() {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(sendButton)
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        
        containerView.addSubview(inputTextField)
        inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        let separatorLine = UIView()
        separatorLine.backgroundColor = UIColor.lightGray
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(separatorLine)
        separatorLine.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        separatorLine.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        separatorLine.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        separatorLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    func handleSend() {
        print(inputTextField.text!)
        let ref = Database.database().reference().child("messages").childByAutoId()
        let recipientId = user!.id!
        let senderId = Auth.auth().currentUser!.uid
        let timestamp = Int(NSDate().timeIntervalSince1970)
        let values = ["text": inputTextField.text!, "recipientId": recipientId, "senderId": senderId, "timestamp": timestamp] as [String : Any]
        ref.updateChildValues(values)
    }

}

extension ChatLogViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
}
