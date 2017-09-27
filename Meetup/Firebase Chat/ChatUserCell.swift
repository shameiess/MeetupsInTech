//
//  ChatUserCell.swift
//  Meetup
//
//  Created by Kevin Nguyen on 8/16/17.
//  Copyright © 2017 Kevin Nguyen. All rights reserved.
//

import UIKit
import Firebase

class ChatUserCell: UITableViewCell {
    
    var message: ChatMessage? {
        didSet {
            if let chatPartnerId = message?.chatPartnerId() {
                let ref = Database.database().reference().child("users").child(chatPartnerId)
                ref.observe(.value, with: { (snapshot) in
                    if let dictionary = snapshot.value as? [String: Any] {
                        let user = ChatUser()
                        user.setValuesForKeys(dictionary)
                        self.textLabel?.text = user.name
                        if let profileImageURL = user.profileImageURL {
                            let url = URL(string: profileImageURL)
                            self.profileImageView.kf.setImage(with: url, placeholder: UIImage(), options: [.transition(.fade(0.1))])
                        }
                    }
                }, withCancel: nil)
            }
            detailTextLabel?.text = message?.text
            if let seconds = message?.timestamp?.doubleValue {
                let timeStamp = Date(timeIntervalSince1970: seconds)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm:ss a"
                timeLabel.text = dateFormatter.string(from: timeStamp)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = CGRect(x: 100, y: (textLabel?.frame.origin.y)! - 2, width: contentView.frame.size.width - 115, height: textLabel!.frame.height)
        textLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 20)//UIFont.systemFont(ofSize: 20)
        textLabel?.textColor = UIColor.orange
        textLabel?.numberOfLines = 0
        textLabel?.lineBreakMode = .byWordWrapping
        //textLabel?.preferredMaxLayoutWidth = textLabel!.frame.size.width - 70//(textLabel?.bounds.size.width)!
        textLabel?.sizeToFit()
        //textLabel?.backgroundColor = UIColor.red
        //textLabel?.adjustsFontSizeToFitWidth = true
        detailTextLabel?.frame = CGRect(x: 100, y: (detailTextLabel?.frame.origin.y)! + 2, width: (detailTextLabel?.frame.width)!, height: (detailTextLabel?.frame.height)!)
        detailTextLabel?.textColor = UIColor.lightGray
        
//        self.contentView.setNeedsLayout()
//        self.contentView.layoutIfNeeded()
        
        //self.setNeedsLayout()
//        self.layoutIfNeeded()
    }
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 35
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AvenirNext-DemiBold", size: 12)
        label.textColor = UIColor.lightGray
        return label
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        addSubview(profileImageView)
        addSubview(timeLabel)
        
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 27).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        timeLabel.heightAnchor.constraint(equalTo: (textLabel?.heightAnchor)!).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
