//
//  YelpTableViewCell.swift
//  Meetup
//
//  Created by Kevin Nguyen on 8/3/17.
//  Copyright © 2017 Kevin Nguyen. All rights reserved.
//

import UIKit

class YelpTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingStackView: YelpRatingControl!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var reviewsLabel: UILabel!

}
