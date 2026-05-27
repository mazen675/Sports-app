import UIKit

class TeamDetailsViewController: UIViewController, TeamDetailsViewProtocol {

    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var teamImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var leagueCountry: UIButton!
    @IBOutlet weak var leagueNameLabel: UIButton!
    
    var presenter: TeamDetailsPresenterProtocol!
    var currentTeam: TeamModel?
    
    // 🚨 Add Circular Progress Bar
    var activityIndicator = UIActivityIndicatorView(style: .large)

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 80
        
        // Setup Progress Bar
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        
        presenter.fetchTeamDetails()
    }
    
    // MARK: - MVP Methods
    func showLoading() {
        activityIndicator.startAnimating()
    }
    
    func hideLoading() {
        activityIndicator.stopAnimating()
    }
    
    func displayTeamDetails(team: TeamModel, leagueName:String , leagueExtraInfo: String) {
        self.currentTeam = team
        
        DispatchQueue.main.async {
            self.teamNameLabel.text = team.safeTeamName
            self.leagueCountry.setTitle(leagueExtraInfo, for: .normal)
            self.leagueNameLabel.setTitle(leagueName, for: .normal)
            
            if let url = URL(string: team.safeTeamLogo) {
                self.teamImageView.load(from: team.safeTeamLogo)
            }
            self.tableView.reloadData()
        }
    }
    
    func showError(message: String) { print("Error: \(message)") }
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
