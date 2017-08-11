//
//  YelpRatingControl.swift
//  Meetup
//
//  Created by Kevin Nguyen on 8/4/17.
//  Copyright © 2017 Kevin Nguyen. All rights reserved.
//

import UIKit
import Foundation

@IBDesignable class YelpRatingControl: UIStackView {
    
    private var ratingButtons = [UIButton]()
    
    var rating: Double? {
        didSet {
            setupButtons()
        }
    }
    
    @IBInspectable var starSize: CGSize = CGSize(width: 13.0, height: 13.0) {
        didSet {
            setupButtons()
        }
    }
    
    @IBInspectable var starCount: Int = 5 {
        didSet {
            setupButtons()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    //MARK: Private methods
    private func setupButtons() {
        
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        ratingButtons.removeAll()
        
        for _ in 0..<starCount {
            let button = UIButton()
            button.backgroundColor = UIColor.orange
            button.setTitle("✩", for: .normal)
            //button.layer.cornerRadius = 5
            
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            
            button.addTarget(self, action: #selector(YelpRatingControl.ratingTapped(button:)), for: .touchUpInside)
            
            addArrangedSubview(button)
            
            ratingButtons.append(button)
        }
        
        // Workaround to add half star ratings
        let isWholeNumber = rating?.truncatingRemainder(dividingBy: 1) == 0
        if (!isWholeNumber) {
            let halfButton = UIButton()
            halfButton.backgroundColor = UIColor.orange
            halfButton.setTitle("✩", for: .normal)
            halfButton.translatesAutoresizingMaskIntoConstraints = false
            halfButton.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            halfButton.widthAnchor.constraint(equalToConstant: starSize.width/2).isActive = true
            addArrangedSubview(halfButton)
            ratingButtons.append(halfButton)
        }
    }
    
    @objc private func ratingTapped(button: UIButton) {
        print("Button pressed 👍")
    }
    
}
