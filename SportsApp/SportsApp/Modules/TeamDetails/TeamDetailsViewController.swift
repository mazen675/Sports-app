//
//  TeamDetailsViewController.swift
//  SportsApp
//
//  Created by Mazen Amr on 23/05/2026.
//

import UIKit

struct Player2 {
    let name: String
    let position: String
}

class TeamDetailsViewController: UIViewController {

    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var teamImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var leagueCountry: UILabel!
    @IBOutlet weak var leagueNameLabel: UILabel!
    
    let dummySquad: [Player2] = [
        Player2(name: "Bukayo Saka", position: "Forward"),
        Player2(name: "Martin Ødegaard", position: "Midfielder"),
        Player2(name: "William Saliba", position: "Defender"),
        Player2(name: "Declan Rice", position: "Midfielder")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        // 1. Configure Top Header UI
        teamNameLabel.text = "Liverpool FC"
        teamImageView.image = UIImage(named: "liverpool") // Do not include ".png" when loading from Assets
        leagueCountry.text = "England"
        leagueNameLabel.text = "Premier League"

        // 2. Assign delegates
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 80
    }
}

// MARK: - Table View Data Source & Delegate
extension TeamDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dummySquad.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeamPlayerCell", for: indexPath) as! PlayerTableViewCell
        
        let player = dummySquad[indexPath.row]
        
        // 3. Use the new config function
        cell.config(player: player)
        
        return cell
    }
}
