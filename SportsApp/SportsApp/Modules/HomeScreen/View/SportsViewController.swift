import UIKit

class SportsViewController: UIViewController, SportsViewProtocol {

    @IBOutlet weak var collectionView: UICollectionView!
    
    // The Presenter handles the logic
    var presenter: SportsPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(named: "AppBackground")
        presenter = SportsPresenter(view: self)
        setupCollectionView()
        presenter.view?.displaySports()
    }
    
    func setupCollectionView() {
            collectionView.delegate = self
            collectionView.dataSource = self
            
            if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.estimatedItemSize = .zero
            }
            
            // custom XIB
            let nib = UINib(nibName: "SportCollectionViewCell", bundle: nil)
            collectionView.register(nib, forCellWithReuseIdentifier: "SportCell")
            
            collectionView.backgroundColor = .clear
        }
    
    
    func displaySports() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func navigateToLeagues(for sportName: String, endpoint: String) {
            // Instantiate the Leagues screen from the Storyboard
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let leaguesVC = storyboard.instantiateViewController(withIdentifier: "LeaguesViewController") as? LeaguesViewController {
                
                // Inject the Presenter with the correct endpoint
                leaguesVC.presenter = LeaguesPresenter(view: leaguesVC, sportEndpoint: endpoint)
                
                // Set the title for the navigation bar
                leaguesVC.title = "\(sportName) Leagues"
                
                // Push it onto the screen
                self.navigationController?.pushViewController(leaguesVC, animated: true)
            }
        }
}

// CollectionView DataSource & Delegate
extension SportsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.sportsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SportCell", for: indexPath) as! SportCollectionViewCell
        
        // Pull the exact sport from our local array
        let sportData = presenter.configureCell(at: indexPath.row)
        cell.setupCell(title: sportData.name, imageName: sportData.image)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didSelectSport(at: indexPath.row)
    }
    
    // Dynamic Grid Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let padding: CGFloat = 16
        let spacingBetweenCells: CGFloat = 16
        
        let totalAvailableWidth = collectionView.bounds.width - (padding * 2) - spacingBetweenCells
        let cellWidth = totalAvailableWidth / 2
        
        return CGSize(width: cellWidth, height: cellWidth * 1.2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}
