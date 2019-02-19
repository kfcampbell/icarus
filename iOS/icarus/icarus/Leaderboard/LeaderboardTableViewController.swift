//
//  LeaderboardTableViewController.swift
//  icarus
//
//  Created by Keegan Campbell on 2/18/19.
//  Copyright © 2019 kfcampbell. All rights reserved.
//

import UIKit

class LeaderboardTableViewController: UITableViewController {
    
    private var leaderboardViewModel = LeaderboardViewModel()
    
    @IBAction func refreshLeaderboard(_ sender: UIRefreshControl) {
        leaderboardViewModel.getHighScores(successCallback: {
            self.tableView.reloadData()
            sender.endRefreshing()
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        leaderboardViewModel.getHighScores(successCallback: self.tableView.reloadData)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leaderboardViewModel.highScores.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "leaderboardCell", for: indexPath)

        if(leaderboardViewModel.highScores.count > indexPath.row) {
            let highScore = leaderboardViewModel.highScores[indexPath.row]
            cell.textLabel?.text = "\(highScore.displayName) - (\(highScore.phoneModel)) \((leaderboardViewModel.getComputedHeight(score: highScore)).truncate(places: 2))m"
        }

        return cell
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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
