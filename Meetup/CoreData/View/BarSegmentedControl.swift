//
//  BarSegmentedControl.swift
//  Meetup
//
//  Created by Kevin Nguyen on 7/5/18.
//  Copyright © 2018 Kevin Nguyen. All rights reserved.
//

import UIKit

protocol BarSegmentedControlDelegate: class {
    func scrollToOffset(atIndex: Int)
}

class BarSegmentedControl: UISegmentedControl {
    
    let buttonBar = UIView()
    weak var delegate: BarSegmentedControlDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    override func prepareForInterfaceBuilder() {
        configure()
    }
    
    // Took away @IBInspectable since arrays are not supported
    var segments: [String] = ["Latest", "Career", "Season"] {
        didSet {
            applySegments(segments: segments)
        }
    }
    
    func applySegments(segments: [String]) {
        self.removeAllSegments()
        for segment in segments {
            self.insertSegment(withTitle: segment, at: self.numberOfSegments, animated: false)
        }
    }
    
    @IBInspectable var barColor: UIColor = .black {
    	didSet {
    		applyBarColor(color: barColor)
    	}
    }
    
    func applyBarColor(color: UIColor) {
		buttonBar.backgroundColor = barColor
    }
    
    func configure() {
        applySegments(segments: segments)
        applyBarColor(color: barColor)
        
        // UISegmentedControl
        selectedSegmentIndex = 0
        backgroundColor = .clear
        tintColor = .clear
		setTitleTextAttributes([NSFontAttributeName: UIFont(name: "DINCondensed-Bold", size: 18.0)!,
                                NSForegroundColorAttributeName: UIColor.lightGray], for: .normal)
		setTitleTextAttributes([NSFontAttributeName: UIFont(name: "DINCondensed-Bold", size: 18.0)!,
                                NSForegroundColorAttributeName: UIColor.orange], for: .selected)
        addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
        
        // buttonBar
        buttonBar.translatesAutoresizingMaskIntoConstraints = false
        addSubview(buttonBar)
    }
    
    override var selectedSegmentIndex: Int {
        didSet {
            segmentedControlValueChanged()
        }
    }
    
    func segmentedControlValueChanged() {
        UIView.animate(withDuration: 0.0, animations: {
            self.buttonBar.frame.origin.x = (self.frame.width / CGFloat(self.numberOfSegments)) * CGFloat(self.selectedSegmentIndex)

        }) { (completion) in
            self.delegate?.scrollToOffset(atIndex: self.selectedSegmentIndex)
        }
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        buttonBar.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        buttonBar.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        buttonBar.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1 / CGFloat(self.numberOfSegments)).isActive = true
        buttonBar.heightAnchor.constraint(equalToConstant: 5).isActive = true
    }

    override func draw(_ rect: CGRect) {
        // Drawing code
    }

}
