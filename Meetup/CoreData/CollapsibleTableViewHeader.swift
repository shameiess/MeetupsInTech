//
//  CollapsibleTableViewHeader.swift
//  Meetup
//
//  Created by Kevin Nguyen on 11/16/17.
//  Copyright © 2017 Kevin Nguyen. All rights reserved.
//

import UIKit

protocol CollapsibleTableViewHeaderDelegate {
    func toggleSection(_ header: CollapsibleTableViewHeader, section: Int)
}

class CollapsibleTableViewHeader: UITableViewHeaderFooterView {

    var delegate: CollapsibleTableViewHeaderDelegate?
    var section: Int = 0
    
    var titleLabel = UILabel()
    var arrowLabel = UILabel()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor(red: 11, green: 89, blue: 153)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(headerTapped)))
        
        let marginsGuide = contentView.layoutMarginsGuide
        
        contentView.addSubview(titleLabel)
        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: marginsGuide.topAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: marginsGuide.bottomAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: marginsGuide.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: marginsGuide.trailingAnchor).isActive = true
        
        contentView.addSubview(arrowLabel)
        arrowLabel.textColor = .white
        arrowLabel.translatesAutoresizingMaskIntoConstraints = false
        arrowLabel.topAnchor.constraint(equalTo: marginsGuide.topAnchor).isActive = true
        arrowLabel.bottomAnchor.constraint(equalTo: marginsGuide.bottomAnchor).isActive = true
        arrowLabel.widthAnchor.constraint(equalToConstant: 12).isActive = true
        arrowLabel.trailingAnchor.constraint(equalTo: marginsGuide.trailingAnchor).isActive = true
    }
    
    func headerTapped(gestureRecognizer: UITapGestureRecognizer) {
        guard let cell = gestureRecognizer.view as? CollapsibleTableViewHeader else { return }
        delegate?.toggleSection(self, section: cell.section)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCollapsed(_ collapsed: Bool) {
        arrowLabel.rotate(collapsed ? 0.0 : .pi/2)
    }
    
}
