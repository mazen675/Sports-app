import UIKit

class SportsViewController: UIViewController, SportsViewProtocol {

    // Connect this to the CollectionView in your Storyboard!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // The Presenter handles the logic
    var presenter: SportsPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1. Initialize Presenter
        presenter = SportsPresenter(view: self)
        
        // 2. Setup the UI
        setupCollectionView()
        
        // 3. Ask Presenter for data
        presenter.view?.displaySports()
    }
    
    func setupCollectionView() {
            collectionView.delegate = self
            collectionView.dataSource = self
            
            // 🚨 THE FIX: Tell Xcode to stop guessing the size and use our math instead!
            if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.estimatedItemSize = .zero
            }
            
            // Register the custom XIB your partner made
            let nib = UINib(nibName: "SportCollectionViewCell", bundle: nil)
            collectionView.register(nib, forCellWithReuseIdentifier: "SportCell")
            
            // Remove default background color so it matches your app theme
            collectionView.backgroundColor = .clear
        }
    
    // MARK: - MVP Methods
    func displaySports() {
        // This forces the blank screen to populate the 4 grids
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func navigateToLeagues(for sportName: String, endpoint: String) {
            // Instantiate the Leagues screen from the Storyboard
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let leaguesVC = storyboard.instantiateViewController(withIdentifier: "LeaguesViewController") as? LeaguesViewController {
                
                // Inject the Presenter with the correct endpoint (e.g., "tennis")
                leaguesVC.presenter = LeaguesPresenter(view: leaguesVC, sportEndpoint: endpoint)
                
                // Set the title for the navigation bar
                leaguesVC.title = "\(sportName) Leagues"
                
                // Push it onto the screen!
                self.navigationController?.pushViewController(leaguesVC, animated: true)
            }
        }
}

// MARK: - CollectionView DataSource & Delegate
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
    
    // MARK: - Dynamic Grid Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let padding: CGFloat = 16
        let spacingBetweenCells: CGFloat = 16
        
        // Calculate 50% width minus the padding
        let totalAvailableWidth = collectionView.bounds.width - (padding * 2) - spacingBetweenCells
        let cellWidth = totalAvailableWidth / 2
        
        // Height is slightly taller than width to match your mockups
        return CGSize(width: cellWidth, height: cellWidth * 1.2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16 // Vertical space between rows
    }
}
