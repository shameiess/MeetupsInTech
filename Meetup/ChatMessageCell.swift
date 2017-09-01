//
//  ChatMessageCell.swift
//  Meetup
//
//  Created by Kevin Nguyen on 8/28/17.
//  Copyright © 2017 Kevin Nguyen. All rights reserved.
//

import UIKit

class ChatMessageCell: UICollectionViewCell {

    let textView: UITextView = {
        let textView = UITextView()
        textView.text = "SAMPLE TEXT"
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.blue
        
        addSubview(textView)
        textView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
