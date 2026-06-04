import UIKit

class TeamDetailsViewController: UIViewController, TeamDetailsViewProtocol {

    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var teamImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var leagueCountry: UIButton!
    @IBOutlet weak var leagueNameLabel: UIButton!
    
    @IBOutlet weak var emptyStateCardView: UIView!
    @IBOutlet weak var emptyStateTitleLabel: UILabel!
    @IBOutlet weak var emptyStateSubtitlesLabel: UILabel!
    
    var presenter: TeamDetailsPresenterProtocol!
    var currentTeam: TeamModel?
    var activityIndicator = UIActivityIndicatorView(style: .large)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI(){
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
        self.emptyStateCardView.isHidden = true
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

        if team.safePlayers.isEmpty {
            self.emptyStateCardView.isHidden = false
            self.emptyStateTitleLabel.text = "no_players_title".localized
            self.emptyStateSubtitlesLabel.text = "no_players_subtitle".localized
            } else {
            self.tableView.backgroundView = nil
         }
        self.tableView.reloadData()
        
    }
    
    func showError(message: String) {
        DispatchQueue.main.async { print("Error: \(message)") }
    }
    
}

extension TeamDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
            return presenter.numberOfSections
        }
            
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return presenter.numberOfRows(in: section)
        }
            
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TeamPlayerCell", for: indexPath) as! PlayerTableViewCell
            
            let player = presenter.getPlayer(at: indexPath)
            cell.config(player: player)
            
            return cell
        }
       
        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CustomTableViewHeader") as! CustomTableViewHeader
            
            let sectionTitle = presenter.getSectionTitle(for: section)
            header.config(color: UIColor.systemBlue, title: sectionTitle)
            
            return header
        }
            
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 50.0
        }
}
