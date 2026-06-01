import UIKit

class SportsViewController: UIViewController, SportsViewProtocol {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var presenter: SportsPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "home_title".localized
        
        if let tabItems = self.tabBarController?.tabBar.items {
                    tabItems[0].title = "sports_tab".localized
                    tabItems[1].title = "favourites_tab".localized
                }
        
        presenter = SportsPresenter(view: self)
        setupCollectionView()
        presenter.view?.displaySports()
        
        let settingsButton = UIBarButtonItem(
            image: UIImage(systemName: "gearshape.fill"),
            style: .plain,
            target: self,
            action: #selector(settingsTapped)
        )
        navigationItem.rightBarButtonItem = settingsButton
    }
    
    @objc private func settingsTapped() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let settingsVC = storyboard.instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController {
            self.navigationController?.pushViewController(settingsVC, animated: true)
        }
    }
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.estimatedItemSize = .zero
        }
        
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
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let leaguesVC = storyboard.instantiateViewController(withIdentifier: "LeaguesViewController") as? LeaguesViewController {
            leaguesVC.presenter = LeaguesPresenter(view: leaguesVC, sportEndpoint: endpoint)
            
            leaguesVC.title = String(format: "leagues_title_format".localized, sportName.localized)
            
            self.navigationController?.pushViewController(leaguesVC, animated: true)
        }
    }
}

extension SportsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.sportsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SportCell", for: indexPath) as! SportCollectionViewCell
    
        let sportData = presenter.configureCell(at: indexPath.row)
        
        // 🌍 Apply Localization to the sport name inside the cell
        cell.setupCell(title: sportData.name.localized, imageName: sportData.image)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didSelectSport(at: indexPath.row)
    }
    
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
