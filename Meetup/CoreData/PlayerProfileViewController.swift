//
//  PlayerProfileViewController.swift
//  Meetup
//
//  Created by Kevin Nguyen on 1/26/18.
//  Copyright © 2018 Kevin Nguyen. All rights reserved.
//

import UIKit

class PlayerProfileViewController: UIViewController {
    
    var player: NBAPlayer?
    
    let segmentedControl = UISegmentedControl(items: ["Latest", "Career", "Season"])
    let segmentedButtonBar = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = player?.name
        
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.backgroundColor = .clear
        segmentedControl.tintColor = .clear
        segmentedControl.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "DINCondensed-Bold", size: 18.0)!,
                                                 NSForegroundColorAttributeName: UIColor.lightGray], for: .normal)
        segmentedControl.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "DINCondensed-Bold", size: 18.0)!,
                                                 NSForegroundColorAttributeName: UIColor.orange], for: .selected)
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
        view.addSubview(segmentedControl)
        
        segmentedControl.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        segmentedControl.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        segmentedControl.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        segmentedButtonBar.translatesAutoresizingMaskIntoConstraints = false
        segmentedButtonBar.backgroundColor = .orange
        view.addSubview(segmentedButtonBar)
        
        segmentedButtonBar.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor).isActive = true
        segmentedButtonBar.leftAnchor.constraint(equalTo: segmentedControl.leftAnchor).isActive = true
        segmentedButtonBar.widthAnchor.constraint(equalTo: segmentedControl.widthAnchor, multiplier: 1 / CGFloat(segmentedControl.numberOfSegments)).isActive = true
        segmentedButtonBar.heightAnchor.constraint(equalToConstant: 5).isActive = true
	
        
    }
    
    func segmentedControlValueChanged() {
        UIView.animate(withDuration: 0.3) {
            print(self.segmentedControl.frame.width)
            print(self.segmentedControl.selectedSegmentIndex)
            self.segmentedButtonBar.frame.origin.x = (self.segmentedControl.frame.width / CGFloat(self.segmentedControl.numberOfSegments)) * CGFloat(self.segmentedControl.selectedSegmentIndex)
            print(self.segmentedButtonBar.frame.origin.x)        }
    }

}
