//
//  WarriorsTableViewControllerTests.swift
//  MeetupTests
//
//  Created by Kevin Nguyen on 1/29/18.
//  Copyright © 2018 Kevin Nguyen. All rights reserved.
//

import XCTest
@testable import Meetup

class WarriorsTableViewControllerTests: XCTestCase {

    var test: WarriorsTableViewController!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        test = WarriorsTableViewController()
        test.viewDidLoad()
    }
    

    // MARK : UI
    func testHasATableView() {
        XCTAssertNotNil(test.tableView)
    }
    
    // MARK : NBA Data
    func testNBATeamsCount() {
        XCTAssert(test.nbateams.count == 30, "There are a total of 30 NBA teams.")
    }
    
    func testPlayersJSONFilesExists() {
        let playersPath = Bundle.main.path(forResource: "players", ofType: "json")
        XCTAssertNotNil(playersPath)
    }
    
    func testTeamsJSONFilesExists() {
        let teamsPath = Bundle.main.path(forResource: "teams", ofType: "json")
        XCTAssertNotNil(teamsPath)
    }
    
    func testTeamsConfigJSONFilesExists() {
        let teamsConfigPath = Bundle.main.path(forResource: "teams_config", ofType: "json")
        XCTAssertNotNil(teamsConfigPath)
    }
    
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
}
