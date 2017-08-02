//
//  YelpViewController.swift
//  Meetup
//
//  Created by Kevin Nguyen on 7/28/17.
//  Copyright © 2017 Kevin Nguyen. All rights reserved.
//

import UIKit
import Foundation

class YelpViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    var businesses: [Yelp.YelpBusiness] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Hi Kevin")
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        tableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "yelpTableViewCell")
        
        self.view.addSubview(tableView)

        YelpClient.getYelpBusinesses("Pho") { (businesses, error) in
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
//            for business in businesses {
//                print(business.name)
//            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.businesses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "yelpTableViewCell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = self.businesses[indexPath.row].name!
        return cell
    }
}
