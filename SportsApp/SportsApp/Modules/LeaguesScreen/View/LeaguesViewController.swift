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
        
        tableView.keyboardDismissMode = .onDrag

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
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
        let data = presenter.getLeagueData(at: indexPath.row)
        cell.configure(with: data.league, placeHolder: data.placeholder)
        cell.favoriteButton.setImage(UIImage(systemName: data.isFavorite ? "heart.fill" : "heart"), for: .normal)
        cell.favoriteButton.tintColor = data.isFavorite ? .red : .darkGray
        
        cell.favoriteAction = { [weak self] in
            self?.presenter.toggleFavorite(league: data.league)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectLeague(at: indexPath.row) 
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func navigateToLeagueDetails(league: LeagueModel, endpoint: String, title: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailsVC = storyboard.instantiateViewController(withIdentifier: "LeagueDetailsCollectionViewController") as? LeagueDetailsCollectionViewController {
            detailsVC.presenter = LeagueDetailsPresenter(view: detailsVC, sportEndpoint: endpoint, league: league)
            detailsVC.title = title
            self.navigationController?.pushViewController(detailsVC, animated: true)
        }
    }
}
