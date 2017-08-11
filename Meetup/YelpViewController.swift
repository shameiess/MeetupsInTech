//
//  YelpViewController.swift
//  Meetup
//
//  Created by Kevin Nguyen on 7/28/17.
//  Copyright © 2017 Kevin Nguyen. All rights reserved.
//

import UIKit
import Foundation
import SDWebImage

let cellIdentifier = "yelpTableViewCell"
let headerHeight:CGFloat = 150.0

class YelpViewController: UIViewController {

    // MARK: UI
    @IBOutlet var tableView: UITableView!
    var headerView: UIView!
    var searchController : UISearchController!
    
    var businesses: [Yelp.YelpBusiness] = [] {
        didSet { DispatchQueue.main.async{ self.tableView.reloadData() } }
    }
    let networking = YelpClient.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Hi Kevin")
        
        // MARK: Search Bar
        self.searchController = UISearchController(searchResultsController:  nil)
        self.searchController.searchResultsUpdater = self
        self.searchController.delegate = self
        self.searchController.searchBar.delegate = self
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.dimsBackgroundDuringPresentation = false
        self.navigationItem.titleView = searchController.searchBar
        self.definesPresentationContext = true
        
        // MARK: Table View
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        tableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        self.view.addSubview(tableView)
        tableView.contentInset = UIEdgeInsets(top: headerHeight, left: 0, bottom: 0, right: 0)

        // MARK: Header View
        headerView = UIView(frame: CGRect(x: 0, y: -(headerHeight+barHeight), width: self.view.frame.width, height: headerHeight+barHeight))
        headerView.backgroundColor = UIColor.black
        self.tableView.addSubview(headerView)
        
        networking.getYelpBusinesses("Pho") { (businesses, error) in
            if let error = error {
                print(error)
                return
            }
            guard let yelpBusinesses = businesses else {
                print("Error: Retreiving businesses")
                return
            }
            self.businesses = yelpBusinesses
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            for business in self.businesses {
                print(business.name!)
                print(String(format: "%.1f",business.rating!))
            }
        }
    }
    
    func updateHeaderAlphaChanel() {
        if ((self.headerView) != nil) {
            let normalized = 1/self.headerView.frame.size.height
            let offset = -self.tableView.contentOffset.y
            self.headerView.alpha = normalized*offset
        }
    }
}

extension YelpViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.businesses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("YelpTableViewCell", owner: self, options: nil)?.first as! YelpTableViewCell
        
        let yelp = self.businesses[indexPath.row]
        
        cell.nameLabel.text = "\(indexPath.row.description). \(yelp.name!)"
        cell.mainImageView.layer.cornerRadius = 5
        let url = URL(string: yelp.image_url!)
        cell.mainImageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "strength_in_numbers_logo"), options: [.continueInBackground], completed: nil)
        cell.distanceLabel.text = String(format: "%.1f mi", yelp.distance!)
        cell.ratingStackView.starCount = Int(yelp.rating!)
        cell.ratingStackView.rating = yelp.rating!
        cell.reviewsLabel.text = String(format: "%d Reviews", yelp.review_count!)
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateHeaderAlphaChanel()
    }
    
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
    
    }
    
}

extension YelpViewController: UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        networking.getYelpBusinesses(searchBar.text!) { (businesses, error) in
            self.businesses = businesses!
        }
    }
    
}
