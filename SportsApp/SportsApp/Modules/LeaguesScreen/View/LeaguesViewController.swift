import UIKit

class LeaguesViewController: UIViewController, LeaguesViewProtocol, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var presenter: LeaguesPresenterProtocol!
    
    var activityIndicator = UIActivityIndicatorView(style: .large)

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        presenter.fetchLeagues()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }
    
    private func setupUI() {
        tableView.backgroundColor = .clear
        tableView.backgroundView = nil
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        searchBar.delegate = self
        searchBar.backgroundImage = UIImage()
        searchBar.backgroundColor = .clear
        searchBar.barTintColor = .clear
        
        let nib = UINib(nibName: "LeagueTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "LeagueCell")
        
        activityIndicator.color = .titles
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.filterLeagues(with: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func showLoading() {
        DispatchQueue.main.async { self.activityIndicator.startAnimating() }
    }
    func hideLoading() {
        DispatchQueue.main.async { self.activityIndicator.stopAnimating() }
    }
    func reloadData() {
        DispatchQueue.main.async { self.tableView.reloadData() }
    }
    func showError(message: String) {
        DispatchQueue.main.async { print("Error: \(message)") }
    }
}

extension LeaguesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.leaguesCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeagueCell", for: indexPath) as! LeagueTableViewCell
        let league = presenter.getLeague(at: indexPath.row)
        let placeHolder = getPlaceholderImage(for: presenter.sportEndpoint)
        cell.configure(with: league, placeHolder: placeHolder)
        
        let leagueId = league.leagueKey ?? ""
        let isFav = presenter.isFavorite(leagueId: leagueId)
        
        cell.favoriteButton.setImage(UIImage(systemName: isFav ? "heart.fill" : "heart"), for: .normal)
        cell.favoriteButton.tintColor = isFav ? .red : .darkGray
        
        cell.favoriteAction = { [weak self] in
            self?.presenter.toggleFavorite(league: league)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedLeague = presenter.getLeague(at: indexPath.row)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let detailsVC = storyboard.instantiateViewController(withIdentifier: "LeagueDetailsCollectionViewController") as? LeagueDetailsCollectionViewController {
            detailsVC.presenter = LeagueDetailsPresenter(view: detailsVC, sportEndpoint: presenter.sportEndpoint, league: selectedLeague)
            detailsVC.title = selectedLeague.safeLeagueName
            self.navigationController?.pushViewController(detailsVC, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
