//
//  CommentsView.swift
//  Meetup
//
//  Created by Kevin Nguyen on 11/16/16.
//  Copyright © 2016 Kevin Nguyen. All rights reserved.
//

import UIKit

class CommentsView: UIViewController {

    @IBOutlet weak var commentsTableView: UITableView!
    var comments: [Meetup.MeetupComment]?
    var event_id: String?
    var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentsTableView.dataSource = self
        commentsTableView.delegate = self
        setupLoadingIndicator()
        
        let url = "https://api.meetup.com/2/event_comments?&sign=true&photo-host=public&event_id=" + event_id! + "&page=20&key=61843107c6fc55826453135e261d"
        
        MeetupClient.requestGETURL(url, success: {
            (JSONResponse) -> Void in
            self.comments = Meetup.commentsfromMeetup(json: JSONResponse)
            self.commentsTableView.reloadData()
            self.activityIndicator.stopAnimating()

        }) { (error) -> Void in
            print(error)
        }
    }
    
    func setupLoadingIndicator() {
        commentsTableView.backgroundView = activityIndicator
        activityIndicator.center = view.center;
        activityIndicator.activityIndicatorViewStyle  = UIActivityIndicatorViewStyle.gray;
        activityIndicator.hidesWhenStopped = true;
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
    }
}

extension CommentsView: UITableViewDelegate, UITableViewDataSource {
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
        return self.comments?.count ?? 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = commentsTableView.dequeueReusableCell(withIdentifier: "comment", for: indexPath)
        let comment = comments?[indexPath.row]
        
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = comment?.comment
        //let nameTime = " \(comment?.member_name) at \(comment?.time?.convertToDateString())"
        cell.detailTextLabel?.text = comment?.member_name?.appending(" on ").appending((comment?.time?.convertToDateString())!)
        return cell
    }
}
