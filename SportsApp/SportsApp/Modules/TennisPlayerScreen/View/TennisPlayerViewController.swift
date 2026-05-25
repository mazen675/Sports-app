import UIKit

class TennisPlayerViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, TennisPlayerViewProtocol {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var presenter: TennisPlayerPresenterProtocol!
    var tennisPlayer: TennisPlayerModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // 🚨 THE FIX: Deleted the NIB registrations for the cells! We only register the Header.
        let headerNib = UINib(nibName: "SectionHeaderView", bundle: nil)
        collectionView.register(headerNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeader")
        
        let layout = UICollectionViewCompositionalLayout { index, environment in
            switch index {
                case 0 : return self.setHeaderSection()
                case 1 : return self.setStatisticsSection()
                case 2 : return self.setTournamentsSection()
                default : return self.setTournamentsSection()
            }
        }
        
        collectionView.setCollectionViewLayout(layout, animated: true)
        
        presenter.fetchPlayerDetails()
    }
    
    // MARK: - MVP Methods
    func showLoading() { print("Loading Tennis Player...") }
    func hideLoading() { print("Finished Loading Player") }
    func showError(message: String) { print("Error: \(message)") }
    
    func displayPlayerDetails(player: TennisPlayerModel) {
        self.tennisPlayer = player
        DispatchQueue.main.async { self.collectionView.reloadData() }
    }
    
    // MARK: - Layout Sections
    func setHeaderSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        return NSCollectionLayoutSection(group: group)
    }
    
    func setStatisticsSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(160))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [header]
        return section
    }
    
    func setTournamentsSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(100))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [header]
        return section
    }
    
    // MARK: - UICollectionView Data Source
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return tennisPlayer == nil ? 0 : 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let player = tennisPlayer else { return 0 }
        switch section {
        case 0: return 1
        case 1: return player.safeStats.count
        case 2: return player.safeTournaments.count
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let player = tennisPlayer else { return UICollectionViewCell() }
        
        switch indexPath.section {
        case 0:
            // 🚨 THE FIX: lowercase "headerCell"
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "headerCell", for: indexPath) as! HeaderCollectionViewCell
            cell.config(with: player)
            return cell
            
        case 1:
            // 🚨 THE FIX: lowercase "statisticsCell"
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "statisticsCell", for: indexPath) as! StatisticsCollectionViewCell
            cell.config(with: player.safeStats[indexPath.row])
            return cell
            
        case 2:
            // 🚨 THE FIX: lowercase "tournamentCell"
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tournamentCell", for: indexPath) as! TournamentCollectionViewCell
            cell.config(with: player.safeTournaments[indexPath.row])
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as! SectionHeaderView
        switch indexPath.section {
        case 1: header.titleLabel.text = "Player Statistics"
        case 2: header.titleLabel.text = "Tournaments"
        default: header.titleLabel.text = ""
        }
        return header
    }
}
