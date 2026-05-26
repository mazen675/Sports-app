import UIKit

class FavouritesViewController: UIViewController, FavouritesViewProtocol {

    @IBOutlet weak var tableView: UITableView!
    
    var presenter: FavouritesPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = FavouritesPresenter(view: self)
        setupTableView()
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                presenter.removeFavourite(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
}
