import UIKit

class LeaguesViewController: UIViewController, LeaguesViewProtocol {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var presenter: LeaguesPresenterProtocol!
    
    // A temporary memory bucket to hold favorite IDs until we build CoreData
        var temporaryFavorites = Set<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        
        presenter.fetchLeagues()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        // Register XIB
        let nib = UINib(nibName: "LeagueTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "LeagueCell")
    }
    
    func showLoading() {
        // You can add a UIActivityIndicatorView here later!
        print("Loading data...")
    }
    
    func hideLoading() {
        print("Data loaded!")
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func showError(message: String) {
        print("Error: \(message)")
    }
}

// TableView Configuration
extension LeaguesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.leaguesCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LeagueCell", for: indexPath) as! LeagueTableViewCell
            let league = presenter.getLeague(at: indexPath.row)
            
            // Load the data
            cell.configure(with: league)
            
            // 1Check our temporary memory to see if this league is favorited
            let leagueId = league.leagueKey ?? ""
            let isFav = temporaryFavorites.contains(leagueId)
            
            // Color the heart based on the memory state
            cell.favoriteButton.setImage(UIImage(systemName: isFav ? "heart.fill" : "heart"), for: .normal)
            cell.favoriteButton.tintColor = isFav ? .red : .lightGray
            
            // What happens when the user clicks the heart
            cell.favoriteAction = { [weak self] in
                guard let self = self else { return }
                
                // Toggle it in our temporary memory
                if isFav {
                    self.temporaryFavorites.remove(leagueId)
                } else {
                    self.temporaryFavorites.insert(leagueId)
                }
                
                // Reload just this one row so the heart beautifully snaps to red/gray
                tableView.reloadRows(at: [indexPath], with: .none)
            }
            
            return cell
        }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
