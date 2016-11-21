//
//  MeetupsDrawerView.swift
//  Pulley
//
//  Created by Brendan Lee + Kevin Nguyen on 7/6/16.
//  Copyright © 2016 52inc. All rights reserved.
//

import UIKit
import CoreLocation

class DrawerContentViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var gripperView: UIView!
    
    var meetups = [Meetup]()
    var filteredMeetups = [Meetup]()
    
    @IBOutlet var seperatorHeightConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        //setupUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(DrawerContentViewController.refreshTable), name: .meetups, object: nil)

        gripperView.layer.cornerRadius = 2.5
        seperatorHeightConstraint.constant = 1.0 / UIScreen.main.scale
    }
    
    func refreshTable(notification: Notification) {
        self.meetups = notification.object as! [Meetup]
        self.filteredMeetups = self.meetups
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "drawerTable") {
            let nextView = segue.destination as! MeetupDetailTable
            
            // Passes the selected Meetup and index to detail view
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let selected: Meetup
                if (searchBar.text != "" && self.filteredMeetups.count != 0) {
                    selected = filteredMeetups[indexPath.row]
                } else {
                    selected = meetups[indexPath.row]
                }
                nextView.meetup = selected
            }
        }
    }
}

extension DrawerContentViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredMeetups.count != 0 {
            return filteredMeetups.count
        }
        return meetups.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =  tableView.dequeueReusableCell(withIdentifier: "PulleyCell"
            , for: indexPath)
        let meetup: Meetup
        
        if (searchBar.text != "" && self.filteredMeetups.count != 0) {
            meetup = filteredMeetups[indexPath.row]
        } else {
            meetup = meetups[indexPath.row]
        }
        
        cell.textLabel?.text = meetup.meetupName
        cell.detailTextLabel?.text = meetup.timestamp?.convertToDateString()
        cell.contentView.layer.cornerRadius = 15
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "drawerTable", sender: meetups[indexPath.row])
    }
}

extension DrawerContentViewController: PulleyDrawerViewControllerDelegate {
    func collapsedDrawerHeight() -> CGFloat {
        return 68.0
    }
    func partialRevealDrawerHeight() -> CGFloat {
        return 264.0
    }
    func supportedDrawerPositions() -> [PulleyPosition] {
        return PulleyPosition.all // You can specify the drawer positions you support. This is the same as: [.open, .partiallyRevealed, .collapsed, .closed]
    }
    func drawerPositionDidChange(drawer: PulleyViewController) {
        tableView.isScrollEnabled = drawer.drawerPosition == .open
        if drawer.drawerPosition != .open {
            searchBar.resignFirstResponder()
        }
    }
}

extension DrawerContentViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if let drawerVC = self.parent as? PulleyViewController {
            drawerVC.setDrawerPosition(position: .open, animated: true)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            self.filteredMeetups = meetups
        } else {
            filteredMeetups = filteredMeetups.filter {
                return $0.meetupName!.localizedCaseInsensitiveContains(searchText)
            }
        }
        tableView.reloadData()
    }
}
