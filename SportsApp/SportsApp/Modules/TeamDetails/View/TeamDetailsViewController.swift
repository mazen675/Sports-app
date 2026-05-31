import UIKit

class TeamDetailsViewController: UIViewController, TeamDetailsViewProtocol {

    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var teamImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var leagueCountry: UIButton!
    @IBOutlet weak var leagueNameLabel: UIButton!
    
    var presenter: TeamDetailsPresenterProtocol!
    var currentTeam: TeamModel?
    var groupedSections: [PlayerSection] = []
    var activityIndicator = UIActivityIndicatorView(style: .large)

    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 80
        
        activityIndicator.color = .titles
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        
        let headerNib = UINib(nibName: "CustomTableViewHeader", bundle: nil)
        tableView.register(headerNib, forHeaderFooterViewReuseIdentifier: "CustomTableViewHeader")
        tableView.backgroundColor = .clear
        tableView.backgroundView = nil
        presenter.fetchTeamDetails()
        
        self.teamNameLabel.isHidden = true
        self.leagueCountry.isHidden = true
        self.leagueNameLabel.isHidden = true
        self.teamImageView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            presenter.viewWillAppear()
     }
    
    func showLoading() {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
            self.teamNameLabel.isHidden = true
            self.leagueCountry.isHidden = true
            self.leagueNameLabel.isHidden = true
            self.teamImageView.isHidden = true
        }
    }
    
    func hideLoading() {
        DispatchQueue.main.async { 
            self.activityIndicator.stopAnimating()
            self.teamNameLabel.isHidden = false
            self.leagueCountry.isHidden = false
            self.leagueNameLabel.isHidden = false
            self.teamImageView.isHidden = false
        }
    }
    
    func displayTeamDetails(team: TeamModel, leagueName:String , leagueExtraInfo: String , placeHolder:String) {
        self.currentTeam = team
        self.teamNameLabel.text = team.safeTeamName
        self.leagueCountry.setTitle(leagueExtraInfo.uppercased(), for: .normal)
        self.leagueNameLabel.setTitle(leagueName.uppercased(), for: .normal)
        
        self.teamImageView.sd_setImage(with: URL(string: team.safeTeamLogo), placeholderImage: UIImage(named: placeHolder))
        
        self.groupPlayersByType(players: team.safePlayers)
        if team.safePlayers.isEmpty {
            let emptyView = Bundle.main.loadNibNamed("EmptyStateView", owner: nil, options: nil)?.first as! EmptyStateView
            emptyView.config(title: "No Players", subtitle: "There are no players listed for this team yet.")
            self.tableView.backgroundView = emptyView
            } else {
            self.tableView.backgroundView = nil
         }
        self.tableView.reloadData()
        
    }
    
    func showError(message: String) {
        DispatchQueue.main.async { print("Error: \(message)") }
    }
    
    private func groupPlayersByType(players: [Player]) {
        let groupedDictionary = Dictionary(grouping: players, by: { $0.safePlayerType })
        
        self.groupedSections = groupedDictionary.map { (key, value) in
            PlayerSection(type: key, players: value)
        }
        
        self.groupedSections.sort { section1, section2 in
            return getSortRank(for: section1.type) < getSortRank(for: section2.type)
        }
    }
        
    private func getSortRank(for type: String) -> Int {
        let lowercasedType = type.lowercased()
        
        if lowercasedType.contains("goalkeeper") { return 0 }
        if lowercasedType.contains("defender") { return 1 }
        if lowercasedType.contains("midfielder") { return 2 }
        if lowercasedType.contains("forward") || lowercasedType.contains("striker") { return 3 }
        
        return 4
    }
}

extension TeamDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
            return groupedSections.count
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return groupedSections[section].players.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TeamPlayerCell", for: indexPath) as! PlayerTableViewCell
            
            let player = groupedSections[indexPath.section].players[indexPath.row]
            cell.config(player: player)
            
            return cell
        }
        
   
        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CustomTableViewHeader") as! CustomTableViewHeader
            
            let sectionTitle = groupedSections[section].type
            header.config(color: UIColor.systemBlue, title: sectionTitle)
            
            return header
        }
        
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 50.0
        }
}
struct PlayerSection {
    let type: String
    let players: [Player]
}
