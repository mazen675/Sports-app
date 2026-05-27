import UIKit

class FavouritesViewController: UIViewController, FavouritesViewProtocol {

    @IBOutlet weak var tableView: UITableView!
    var presenter: FavouritesPresenterProtocol!
    var activityIndicator = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        self.tableView.backgroundColor = .systemBackground
        
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        
        presenter = FavouritesPresenter(view: self)
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.loadFavourites()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        let nib = UINib(nibName: "LeagueTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "LeagueCell")
    }
    
    // MARK: - MVP Methods
    func showLoading() {
        DispatchQueue.main.async { self.activityIndicator.startAnimating() }
    }
    
    func hideLoading() {
        DispatchQueue.main.async { self.activityIndicator.stopAnimating() }
    }
    
    func reloadData() {
        DispatchQueue.main.async { self.tableView.reloadData() }
    }
    
    func navigateToLeagueDetails(league: LeagueModel, sportEndpoint: String) {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let detailsVC = storyboard.instantiateViewController(withIdentifier: "LeagueDetailsCollectionViewController") as? LeagueDetailsCollectionViewController {
                
                detailsVC.presenter = LeagueDetailsPresenter(view: detailsVC, sportEndpoint: sportEndpoint, league: league)
                detailsVC.title = league.safeLeagueName
                
                self.navigationController?.pushViewController(detailsVC, animated: true)
            }
        }
    }
}

// MARK: - TableView Configuration
extension FavouritesViewController: UITableViewDelegate, UITableViewDataSource {
    
    // 🚨 FIX 1: Uses numberOfSections instead of a flat list
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.numberOfSections
    }
    
    // 🚨 FIX 2: Replaced 'favouritesCount' with 'numberOfItems(in:)'
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfItems(in: section)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .systemGray6
        
        let titleLabel = UILabel()
        titleLabel.text = presenter.titleForSection(section)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textColor = .label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeagueCell", for: indexPath) as! LeagueTableViewCell
        
        // 🚨 FIX 3: Passed the whole 'indexPath' instead of 'indexPath.row'
        let league = presenter.getFavourite(at: indexPath)
        cell.configure(with: league)
        
        cell.favoriteButton.isHidden = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 🚨 FIX 4: Passed the whole 'indexPath'
        presenter.didSelectFavourite(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // 🚨 FIX 5: Passed the whole 'indexPath'
            presenter.removeFavourite(at: indexPath)
            
            if presenter.numberOfItems(in: indexPath.section) == 0 {
                tableView.reloadData()
            } else {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
}
