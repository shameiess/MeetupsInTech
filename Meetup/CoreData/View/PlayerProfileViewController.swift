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
    var playerProfile: NBAPlayerProfile?
    
    @IBOutlet weak var barSegmentedControl: BarSegmentedControl! {
        didSet {
            barSegmentedControl.delegate = self
        }
    }
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.delegate = self
        }
    }
    
    var slides:[UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.title = player?.name
        barSegmentedControl.barColor = .orange

        if let player = player {
            NBADataAPI().fetchPlayer(personId: player.personId, success: { [weak self] (profile) in
                self?.playerProfile = profile
                self?.slides = (self?.createSlides(player: profile))!
                self?.setupSlideScrollView(slides: (self?.slides)!)
            }) { (error) in
                print(error)
            }
        }
    }
    
    func createSlides(player: NBAPlayerProfile?) -> [UIViewController] {

//        let slide1 = StatsTableViewController(nibName: "StatsCollectionViewController", bundle: nil)
        let storyboard = UIStoryboard(name: "StatsCollectionViewController", bundle: nil)
        let slide1 = storyboard.instantiateViewController(withIdentifier: StatsCollectionViewController.storyboardIdentifier) as! StatsCollectionViewController

//        slide1.view.backgroundColor = .blue
//        slide1.player = player
//        slide1.statsSummary = player?.league.standard.stats?.latest

        let slide2 = StatsTableViewController(nibName: "StatsTableViewController", bundle: nil)
        slide2.view.backgroundColor = .yellow
        slide2.player = player
        slide2.statsSummary = player?.league.standard.stats?.careerSummary

        let slide3 =  StatsTableViewController(nibName: "StatsTableViewController", bundle: nil)
        slide3.view.backgroundColor = .red
        slide3.player = player

        return [slide1, slide2, slide3]
    }
    
    func setupSlideScrollView(slides: [UIViewController]) {
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: scrollView.contentSize.height)
        for i in 0 ..< slides.count {
            slides[i].view.frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
            scrollView.addSubview(self.slides[i].view)
        }
    }
}

extension PlayerProfileViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isDragging {
            let segmentIndex = round(scrollView.contentOffset.x/view.frame.width)
            barSegmentedControl.selectedSegmentIndex = Int(segmentIndex)
        }
    }
}

extension PlayerProfileViewController: BarSegmentedControlDelegate {
    func scrollToOffset(atIndex: Int) {
        if !scrollView.isDragging && atIndex >= 0 {
        	scrollView.setContentOffset(CGPoint(x: view.frame.width * CGFloat(atIndex), y: 0.0), animated: true)
        }
    }
}
