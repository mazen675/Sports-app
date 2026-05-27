import UIKit

class FavouritesViewController: UIViewController, FavouritesViewProtocol {

    @IBOutlet weak var tableView: UITableView!
    
    var presenter: FavouritesPresenterProtocol!
    
    // 🚨 Add Circular Progress Bar
    var activityIndicator = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = FavouritesPresenter(view: self)
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.loadFavourites()
    }
    
    private func setupTableView() {
        self.view.backgroundColor = .systemBackground
        self.tableView.backgroundColor = .systemBackground
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        let nib = UINib(nibName: "LeagueTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "LeagueCell")
        
        // 🚨 Setup the loader
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
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
    
    // 🚨 Safe Navigation
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

extension FavouritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.favouritesCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeagueCell", for: indexPath) as! LeagueTableViewCell
        
        let league = presenter.getFavourite(at: indexPath.row)
        cell.configure(with: league)
        
        cell.favoriteButton.isHidden = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    // 🚨 Added didSelectRowAt for Navigation!
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectFavourite(at: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            presenter.removeFavourite(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
