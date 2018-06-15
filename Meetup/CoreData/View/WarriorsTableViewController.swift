//
//  WarriorsTableViewController.swift
//  Meetup
//
//  Created by Kevin Nguyen on 11/16/17.
//  Copyright © 2017 Kevin Nguyen. All rights reserved.
//

import UIKit

let nbaCellId = "nbaCellId"

class WarriorsTableViewController: UITableViewController {
    
    // MARK: - Properties
    let searchController = UISearchController(searchResultsController: nil)
//    var players = teamsData.flatMap{$0.players}
    
    var nbaplayers = [NBAPlayer]()
    var nbateams = [NBATeam]()
    var nbateamsconfig = [NBATeamConfig]()
    var nbaFranchise: [NBAFranchise] = []
    
    var filteredPlayers = [NBAPlayer]()
    
    var actualTeams = [NBATeam]()

    func buildTeamsData() {
        for team in nbateams {
            let teamGroup = NBAFranchise(name: team, players: nbaplayers.filter{ $0.teamId == team.teamId})
            nbaFranchise.append(teamGroup)
        }
    }
    
    // MARK: - View Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        NBAMock().getNBAData { (players, teams, teamConfigs) in
//            nbaplayers = players
//            nbateams = teams
//            nbateamsconfig = teamConfigs
//        }
//
//        if (nbaplayers.count > 0 && nbateams.count > 0 && nbateamsconfig.count > 0) {
//            buildTeamsData()
//        }
                
        NBADataManager().getNBAData { (players, teams, teamConfigs) in
            self.nbaplayers = players
            self.nbateams = teams
            self.nbateamsconfig = teamConfigs
            DispatchQueue.main.async {
                self.buildTeamsData()
                self.tableView.reloadData()
            }
        }

        // Setup Table View
        tableView.backgroundColor = .black
        tableView.estimatedRowHeight = 44.0
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: nbaCellId)
        
        // Setup the navigation
        self.title = "NBA"
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.isTranslucent = false
        self.edgesForExtendedLayout = []
        
        // Setup the Search Controller
        if #available(iOS 11.0, *) {
            searchController.searchResultsUpdater = self
            searchController.obscuresBackgroundDuringPresentation = false
            searchController.searchBar.placeholder = "Search Players"
            searchController.searchBar.tintColor = .white
            navigationItem.searchController = searchController
        } else {
            tableView.tableHeaderView = searchController.searchBar
        }
    }
    
    // MARK: - Table view data source and delegate

    override func numberOfSections(in tableView: UITableView) -> Int {
        if isFiltering() {
            return 1
        }
        return nbaFranchise.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredPlayers.count
        }
        return nbaFranchise[section].collapsed ? 0 : nbaFranchise[section].players.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if isFiltering() {
        	return nil
        }
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? CollapsibleTableViewHeader ?? CollapsibleTableViewHeader(reuseIdentifier: "header")
        
        header.titleLabel.text = nbaFranchise[section].name.fullName
        
        if let teamColor = nbateamsconfig.first(where: { $0.teamId == nbaFranchise[section].name.teamId }) {
        	header.contentView.backgroundColor = UIColor(hexString: teamColor.primaryColor)
        }
        header.arrowLabel.text = ">"
        header.setCollapsed(nbaFranchise[section].collapsed)
        
        header.section = section
        header.delegate = self
        return header
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: nbaCellId, for: indexPath)
        cell.textLabel?.numberOfLines = 0

        if isFiltering() {
            let player = filteredPlayers[indexPath.row]
            cell.textLabel?.text = "\(player.name)\n\(player.jersey)"
            return cell
        }
        let player = nbaFranchise[indexPath.section].players[indexPath.row]
        cell.textLabel?.text = "\(player.name)\n\(player.jersey)"

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if isFiltering() {
            let player = filteredPlayers[indexPath.row]
        }
        let player = nbaFranchise[indexPath.section].players[indexPath.row]
        
        let playerProfileVC = PlayerProfileViewController()
        playerProfileVC.player = player
        self.navigationController?.pushViewController(playerProfileVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 2
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && (!searchBarIsEmpty())
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension WarriorsTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    // MARK: - Private instance methods
    func filterContentForSearchText(_ searchText: String) {
        filteredPlayers = nbaplayers.filter({ (player: NBAPlayer) -> Bool in
        	return player.name.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
}

extension WarriorsTableViewController: CollapsibleTableViewHeaderDelegate {
    func toggleSection(_ header: CollapsibleTableViewHeader, section: Int) {
        nbaFranchise[section].collapsed = !nbaFranchise[section].collapsed
        
        tableView.reloadSections(NSIndexSet(index: section) as IndexSet, with: .automatic)
    }
}
