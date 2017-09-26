//
//  Shakeable.swift
//  Meetup
//
//  Created by Kevin Nguyen on 8/15/17.
//  Copyright © 2017 Kevin Nguyen. All rights reserved.
//

import UIKit

protocol Shakeable { }

extension Shakeable where Self: UIView {
    
    func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.05
        animation.repeatCount = 5
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 5.0, y: self.center.y))
        layer.add(animation, forKey: "position")
    }
}

extension UIButton: Shakeable {}
