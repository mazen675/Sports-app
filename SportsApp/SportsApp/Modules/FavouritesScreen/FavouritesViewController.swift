import UIKit

class FavouritesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var dummyFavorites: [LeagueModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        
        // 🚨 Make sure this is UNCOMMENTED!
        loadDummyData()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        let nib = UINib(nibName: "LeagueTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "LeagueCell")
    }
    
    // 🚨 Make sure this whole function is UNCOMMENTED!
    private func loadDummyData() {
        // Now that our custom init is in LeagueModel, this works perfectly:
        let fakeLeague = LeagueModel(leagueKey: "1", leagueName: "Test Premier League", leagueLogo: "https://apiv2.allsportsapi.com/logo/logo_leagues/152_premier-league.png", countryName: "England")
        
        dummyFavorites = [fakeLeague]
        tableView.reloadData()
    }
}

// MARK: - TableView Configuration
extension FavouritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dummyFavorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeagueCell", for: indexPath) as! LeagueTableViewCell
        
        let league = dummyFavorites[indexPath.row]
        cell.configure(with: league)
        
        // Visually activate the heart for favorites!
        cell.favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        cell.favoriteButton.tintColor = .red
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
