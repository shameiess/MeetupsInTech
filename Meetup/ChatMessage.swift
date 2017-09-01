//
//  ChatMessage.swift
//  Meetup
//
//  Created by Kevin Nguyen on 8/24/17.
//  Copyright © 2017 Kevin Nguyen. All rights reserved.
//

import UIKit
import FirebaseAuth

class ChatMessage: NSObject {
    
    var text: String?
    var timestamp: NSNumber?
    var senderId: String?
    var recipientId: String?
    
    func chatPartnerId() -> String? {
        return (senderId == Auth.auth().currentUser?.uid) ? recipientId : senderId
    }
}
