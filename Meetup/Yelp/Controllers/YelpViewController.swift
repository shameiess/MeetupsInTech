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
import Kingfisher
import CoreLocation

let cellIdentifier = "yelpTableViewCell"
// let headerHeight:CGFloat = 150.0

class YelpViewController: UIViewController, LocationServiceDelegate {
    
    // MARK: UI
    @IBOutlet var tableView: UITableView!
    var searchController: UISearchController!
    var refreshControl: UIRefreshControl!
    var refreshLoadingView: UIView!
    var refreshColorView: UIView!
    var compass_background: UIImageView!
    var compass_spinner: UIImageView!
    var isRefreshIconsOverlap = false
    var isRefreshAnimating = false
    // var headerView: UIView!
    
    var businesses: [YelpBusiness] = [] {
        didSet {
            DispatchQueue.main.async{ self.tableView.reloadData() }
        }
    }
    
    let networking = YelpClient.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupSearchController()
        setupTableView()
        setupRefreshControl()
        // setupHeaderView()
        
        let locationManager = UserLocation.sharedInstance
        locationManager.delegate = self
        UserLocation.sharedInstance.startUpdatingLocation()
    }
    
    func tracingLocation(currentLocation: CLLocation) {
        let lat = currentLocation.coordinate.latitude
        let lon = currentLocation.coordinate.longitude
        print("lat : \(lat)")
        print("lon : \(lon)")
        networking.getYelpBusinesses(["term": searchController.searchBar.text ?? "Pho", "latitude": lat, "longitude": lon]) { [weak self] (businesses, error) in
            if let error = error {
                print(error)
                return
            }
            guard let yelpBusinesses = businesses else {
                print("Error: Retreiving businesses")
                return
            }
            self?.businesses = yelpBusinesses
            DispatchQueue.main.async{
                self?.refreshControl!.endRefreshing()
            }
        }
        UserLocation.sharedInstance.stopUpdatingLocation()
    }
    
    func tracingLocationDidFailWithError(error: NSError) {
        print("tracingLocationDidFailWithError: \(error.localizedDescription)")
    }
    
    func setupTableView() {
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: displayWidth, height: displayHeight))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.keyboardDismissMode = .interactive
        tableView.register(UINib(nibName: "YelpTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        self.view.addSubview(tableView)
    }
    
    func setupSearchController() {
        searchController = UISearchController(searchResultsController:  nil)
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        UITextField.appearance(whenContainedInInstancesOf: [type(of: searchController.searchBar)]).tintColor = UIColor.darkGray
        self.navigationItem.titleView = searchController.searchBar
        self.definesPresentationContext = true
    }
    
    /*
    func setupHeaderView() {
        headerView = UIView(frame: CGRect(x: 0, y: -(headerHeight+barHeight), width: displayWidth, height: headerHeight+barHeight))
        headerView.backgroundColor = UIColor.cyan
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: displayWidth, height: headerHeight+barHeight))
        imageView.image = #imageLiteral(resourceName: "Yelp_Logo.svg")
        imageView.contentMode = .scaleAspectFill
        headerView.addSubview(imageView)
        self.tableView.addSubview(headerView)
        self.tableView.contentInset = UIEdgeInsets(top: headerHeight+barHeight, left: 0, bottom: 0, right: 0)
        
        func updateHeaderAlphaChanel() {
            if ((self.headerView) != nil) {
                let normalized = 1/self.headerView.frame.size.height
                let offset = -self.tableView.contentOffset.y
                self.headerView.alpha = normalized*offset
            }
        }
    }*/
}

extension YelpViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.businesses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! YelpTableViewCell
        
        let yelp = self.businesses[indexPath.row]
        
        cell.nameLabel.text = "\(indexPath.row.description). \(yelp.name!)"
        cell.mainImageView.layer.cornerRadius = 5
        let url = URL(string: yelp.image_url!)
        cell.mainImageView.kf.setImage(with: url, placeholder: UIImage(), options: [.transition(.fade(0.1))])
        //cell.mainImageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "strength_in_numbers_logo"), options: [.continueInBackground], completed: nil)
        cell.distanceLabel.text = String(format: "%.1f mi", yelp.distance!)
        cell.ratingStackView.starCount = Int(yelp.rating!)
        cell.ratingStackView.rating = yelp.rating!
        cell.reviewsLabel.text = String(format: "%d Reviews", yelp.review_count!)
        
        return cell
    }
    
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {

    }
}

extension YelpViewController: UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        networking.getYelpBusinesses(["term": searchBar.text!]) { (businesses, error) in
//            self.businesses = businesses!
//        }
        UserLocation.sharedInstance.startUpdatingLocation()
    }
}

// MARK: Refresh Control - https://www.jackrabbitmobile.com/app-development/ios-custom-pull-to-refresh-control/
extension YelpViewController {
    func setupRefreshControl() {
        // Programmatically inserting a UIRefreshControl
        self.refreshControl = UIRefreshControl()
        self.tableView.addSubview(refreshControl)
        
        // Setup the loading view, which will hold the moving graphics
        self.refreshLoadingView = UIView(frame: self.refreshControl!.bounds)
        self.refreshLoadingView.backgroundColor = UIColor.clear
        
        // Setup the color view, which will display the rainbowed background
        self.refreshColorView = UIView(frame: self.refreshControl!.bounds)
        self.refreshColorView.backgroundColor = UIColor.clear
        self.refreshColorView.alpha = 0.30
        
        // Create the graphic image views
        compass_background = UIImageView(image: UIImage(named: "compass_background.png"))
        self.compass_spinner = UIImageView(image: UIImage(named: "compass_spinner.png"))
        
        // Add the graphics to the loading view
        self.refreshLoadingView.addSubview(self.compass_background)
        self.refreshLoadingView.addSubview(self.compass_spinner)
        
        // Clip so the graphics don't stick out
        self.refreshLoadingView.clipsToBounds = true;
        
        // Hide the original spinner icon
        self.refreshControl!.tintColor = UIColor.clear
        
        // Add the loading and colors views to our refresh control
        self.refreshControl!.addSubview(self.refreshColorView)
        self.refreshControl!.addSubview(self.refreshLoadingView)
        
        // Initalize flags
        self.isRefreshIconsOverlap = false;
        self.isRefreshAnimating = false;
        
        // When activated, invoke our refresh function
        self.refreshControl?.addTarget(self, action: #selector(YelpViewController.refresh), for: UIControlEvents.valueChanged)
    }
    
    func refresh(){
        // -- DO SOMETHING AWESOME (... or just wait 3 seconds) --
        // This is where you'll make requests to an API, reload data, or process information
        // DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
        //    self.refreshControl!.endRefreshing()
        // }
        // -- FINISHED SOMETHING AWESOME, WOO! --
        UserLocation.sharedInstance.startUpdatingLocation()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //        updateHeaderAlphaChanel()
        
        // Get the current size of the refresh controller
        var refreshBounds = self.refreshControl!.bounds;
        
        // Distance the table has been pulled >= 0
        let pullDistance = max(0.0, -self.refreshControl!.frame.origin.y);
        
        // Half the width of the table
        let midX = self.tableView.frame.size.width / 2.0;
        
        // Calculate the width and height of our graphics
        let compassHeight = self.compass_background.bounds.size.height;
        let compassHeightHalf = compassHeight / 2.0;
        
        let compassWidth = self.compass_background.bounds.size.width;
        let compassWidthHalf = compassWidth / 2.0;
        
        let spinnerHeight = self.compass_spinner.bounds.size.height;
        let spinnerHeightHalf = spinnerHeight / 2.0;
        
        let spinnerWidth = self.compass_spinner.bounds.size.width;
        let spinnerWidthHalf = spinnerWidth / 2.0;
        
        // Calculate the pull ratio, between 0.0-1.0
        let pullRatio = min( max(pullDistance, 0.0), 100.0) / 100.0;
        
        // Set the Y coord of the graphics, based on pull distance
        let compassY = pullDistance / 2.0 - compassHeightHalf;
        let spinnerY = pullDistance / 2.0 - spinnerHeightHalf;
        
        // Calculate the X coord of the graphics, adjust based on pull ratio
        var compassX = (midX + compassWidthHalf) - (compassWidth * pullRatio);
        var spinnerX = (midX - spinnerWidth - spinnerWidthHalf) + (spinnerWidth * pullRatio);
        
        // When the compass and spinner overlap, keep them together
        if (fabsf(Float(compassX - spinnerX)) < 1.0) {
            self.isRefreshIconsOverlap = true;
        }
        
        // If the graphics have overlapped or we are refreshing, keep them together
        if (self.isRefreshIconsOverlap || self.refreshControl!.isRefreshing) {
            compassX = midX - compassWidthHalf;
            spinnerX = midX - spinnerWidthHalf;
        }
        
        // Set the graphic's frames
        var compassFrame = self.compass_background.frame;
        compassFrame.origin.x = compassX;
        compassFrame.origin.y = compassY;
        
        var spinnerFrame = self.compass_spinner.frame;
        spinnerFrame.origin.x = spinnerX;
        spinnerFrame.origin.y = spinnerY;
        
        self.compass_background.frame = compassFrame;
        self.compass_spinner.frame = spinnerFrame;
        
        // Set the encompassing view's frames
        refreshBounds.size.height = pullDistance;
        
        self.refreshColorView.frame = refreshBounds;
        self.refreshLoadingView.frame = refreshBounds;
        
        // If we're refreshing and the animation is not playing, then play the animation
        if (self.refreshControl!.isRefreshing && !self.isRefreshAnimating) {
            self.animateRefreshView()
        }
    }
    
    func animateRefreshView() {
        // Background color to loop through for our color view
        var colorArray = [UIColor.red, UIColor.blue, UIColor.purple, UIColor.cyan, UIColor.orange, UIColor.magenta]
        
        // In Swift, static variables must be members of a struct or class
        struct ColorIndex {
            static var colorIndex = 0
        }
        
        // Flag that we are animating
        self.isRefreshAnimating = true;
        
        UIView.animate(withDuration: Double(0.3), delay: Double(0.0), options: UIViewAnimationOptions.curveLinear, animations: {
            // Rotate the spinner by M_PI_2 = PI/2 = 90 degrees
            self.compass_spinner.transform = self.compass_spinner.transform.rotated(by: CGFloat.pi/2)
            
            // Change the background color
            self.refreshColorView!.backgroundColor = colorArray[ColorIndex.colorIndex]
            ColorIndex.colorIndex = (ColorIndex.colorIndex + 1) % colorArray.count
        }, completion: { finished in
            // If still refreshing, keep spinning, else reset
            if (self.refreshControl!.isRefreshing) {
                self.animateRefreshView()
            } else {
                self.resetAnimation()
            }
        })
    }
    
    func resetAnimation() {
        // Reset our flags and background color
        self.isRefreshAnimating = false;
        self.isRefreshIconsOverlap = false;
        self.refreshColorView.backgroundColor = UIColor.clear
    }
}

