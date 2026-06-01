import UIKit

class TennisPlayerViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, TennisPlayerViewProtocol {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var presenter: TennisPlayerPresenterProtocol!
    var tennisPlayer: TennisPlayerModel?
    
    var activityIndicator = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        activityIndicator.color = .titles
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        
        let layout = UICollectionViewCompositionalLayout{
            index,environment in
            guard let player = self.tennisPlayer else { return nil }
            
            if index == 1 && player.safeStats.isEmpty { return self.setEmptyStateSection() }
            if index == 2 && player.safeTournaments.isEmpty { return self.setEmptyStateSection() }
            
            switch index{
            case 0 : return self.setHeaderSection()
            case 1 : return self.setStatisticsSection()
            case 2 : return self.setTournamentsSection()
            default : return self.setTournamentsSection()
            }
        }
        
        let headerNib = UINib(nibName: "SectionHeaderView", bundle: nil)
        collectionView.register(headerNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeader")
        let emptyNib = UINib(nibName: "EmptyStateCollectionViewCell", bundle: nil)
        collectionView.register(emptyNib, forCellWithReuseIdentifier: "EmptyStateCell")
        collectionView.setCollectionViewLayout(layout, animated: true)
        
        presenter.fetchPlayerDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            presenter.viewWillAppear()
    }
    
    func showLoading() {
        DispatchQueue.main.async { self.activityIndicator.startAnimating() }
    }
    
    func hideLoading() {
        DispatchQueue.main.async { self.activityIndicator.stopAnimating() }
    }
    
    func displayPlayerDetails(player: TennisPlayerModel) {
        self.tennisPlayer = player
        DispatchQueue.main.async { self.collectionView.reloadData() }
    }
    
    func showError(message: String) {
        DispatchQueue.main.async { print("Error: \(message)") }
    }
    
    func setHeaderSection() -> NSCollectionLayoutSection{
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(200))
        
        let mygroup = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        mygroup.contentInsets = NSDirectionalEdgeInsets(top: 14, leading: 10, bottom: 10, trailing: 10)
        
        let section = NSCollectionLayoutSection(group: mygroup)
        
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16)
        
        
        return section
    }
    
    func setStatisticsSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(300))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(300))
        let mygroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        mygroup.contentInsets = NSDirectionalEdgeInsets(top: 14, leading: 16, bottom: 10, trailing: 30)
        
        let section = NSCollectionLayoutSection(group: mygroup)
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 30)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    func setTournamentsSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(150))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(150))
        let mygroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: mygroup)
        section.interGroupSpacing = 16
        
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    func setEmptyStateSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return tennisPlayer == nil ? 0 : 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        guard let player = tennisPlayer else { return 0 }
        switch section {
        case 0: return 1
        case 1: return max(1, player.safeStats.count)
        case 2: return max(1, player.safeTournaments.count)
        default: return 0
        }
    }
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard tennisPlayer != nil else { return UICollectionViewCell() }
            switch indexPath.section {
            case 0 :
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "headerCell", for: indexPath) as! HeaderCollectionViewCell
                cell.config(with: tennisPlayer!)
                return cell
            case 1 :
                if tennisPlayer!.safeStats.isEmpty {
                            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmptyStateCell", for: indexPath) as! EmptyStateCollectionViewCell
                            let title = NSLocalizedString("no_statistics_title", comment: "No Statistics")
                            let subtitle = NSLocalizedString("no_statistics_subtitle", comment: "No stats available")
                            cell.config(title: title, subtitle: subtitle)
                            return cell
                }else{
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "statisticsCell", for: indexPath) as! StatisticsCollectionViewCell
                    cell.config(with: tennisPlayer!.stats![indexPath.row])
                    return cell
                }
                
                
            case 2 :
                if tennisPlayer!.safeTournaments.isEmpty {
                            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmptyStateCell", for: indexPath) as! EmptyStateCollectionViewCell
                            let title = NSLocalizedString("no_tournaments_title", comment: "No Tournaments")
                            let subtitle = NSLocalizedString("no_tournaments_subtitle", comment: "No recent tournaments")
                            cell.config(title: title, subtitle: subtitle)
                            return cell
                }else{
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tournamentCell", for: indexPath) as! TournamentCollectionViewCell
                    cell.config(with: tennisPlayer!.tournaments![indexPath.row])
                    return cell
                }
        
            default :
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tournamentCell", for: indexPath)
                return cell
            }
        }
        
        
        func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
            
            guard kind == UICollectionView.elementKindSectionHeader else {
                return UICollectionReusableView()
            }
            
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as! SectionHeaderView
            
            switch indexPath.section {
            case 1:
                header.titleLabel.text = NSLocalizedString("statistics_header", comment: "Statistics")
            case 2:
                header.titleLabel.text = NSLocalizedString("tournaments_header", comment: "Tournaments")
            default:
                header.titleLabel.text = ""
            }
            
            return header
        }
    }
