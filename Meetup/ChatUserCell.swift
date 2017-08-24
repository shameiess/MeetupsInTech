//
//  ChatUserCell.swift
//  Meetup
//
//  Created by Kevin Nguyen on 8/16/17.
//  Copyright © 2017 Kevin Nguyen. All rights reserved.
//

import UIKit

class ChatUserCell: UITableViewCell {
    
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
        imageView.layer.borderColor = UIColor.cyan.cgColor
        imageView.layer.borderWidth = 2
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        addSubview(profileImageView)
        
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
