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
        textLabel?.frame = CGRect(x: 100, y: (textLabel?.frame.origin.y)! - 2, width: (textLabel?.frame.width)!, height: (textLabel?.frame.height)!)
        textLabel?.font =  UIFont.systemFont(ofSize: 20)
//        textLabel?.numberOfLines = 1
//        textLabel?.lineBreakMode = .byTruncatingTail
//        textLabel?.preferredMaxLayoutWidth = 100//textLabel!.frame.width
//        textLabel?.sizeToFit()
//        textLabel?.backgroundColor = UIColor.red
        //textLabel?.adjustsFontSizeToFitWidth = true
        detailTextLabel?.frame = CGRect(x: 100, y: (detailTextLabel?.frame.origin.y)! + 2, width: (detailTextLabel?.frame.width)!, height: (detailTextLabel?.frame.height)!)
    }
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 35
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        addSubview(profileImageView)
        
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
