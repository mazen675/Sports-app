import UIKit

class FavouritesViewController: UIViewController, FavouritesViewProtocol {

    @IBOutlet weak var tableView: UITableView!
    
    var presenter: FavouritesPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize the Presenter
        presenter = FavouritesPresenter(view: self)
        
        setupTableView()
        
        // Ask the presenter to load the data
        presenter.loadFavourites()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        let nib = UINib(nibName: "LeagueTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "LeagueCell")
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

// TableView Configuration
extension FavouritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.favouritesCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeagueCell", for: indexPath) as! LeagueTableViewCell
        
        let league = presenter.getFavourite(at: indexPath.row)
        cell.configure(with: league)
        
        // Visually activate the heart for favorites
        cell.favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        cell.favoriteButton.tintColor = .red
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
