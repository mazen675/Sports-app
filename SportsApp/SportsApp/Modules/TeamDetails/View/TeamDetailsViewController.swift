import UIKit

class TeamDetailsViewController: UIViewController, TeamDetailsViewProtocol {

    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var teamImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var leagueCountry: UIButton!
    @IBOutlet weak var leagueNameLabel: UIButton!
    
    var presenter: TeamDetailsPresenterProtocol!
    var currentTeam: TeamModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 80
        
        // Fetch real data!
        presenter.fetchTeamDetails()
    }
    
    // MARK: - MVP Methods
    func showLoading() {
        print("Loading Team Details...")
    }
    
    func hideLoading() {
        print("Finished Loading Team Details")
    }
    
    func displayTeamDetails(team: TeamModel, leagueName:String , leagueExtraInfo: String) {
        self.currentTeam = team
        
        DispatchQueue.main.async {
            self.teamNameLabel.text = team.safeTeamName
            self.leagueCountry.titleLabel?.text = leagueExtraInfo
            self.leagueNameLabel.titleLabel?.text = leagueName
            
            if let url = URL(string: team.safeTeamLogo) {
                // Ensure you have import SDWebImage in your project if you want to use it here,
                // otherwise use your UIImageView+Extension:
                self.teamImageView.load(from: team.safeTeamLogo)
            }
            
            self.tableView.reloadData()
        }
    }
    
    func showError(message: String) {
        print("Error: \(message)")
    }
}

extension TeamDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentTeam?.safePlayers.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeamPlayerCell", for: indexPath) as! PlayerTableViewCell
        
        if let player = currentTeam?.safePlayers[indexPath.row] {
            cell.config(player: player)
        }
        
        return cell
    }
}
