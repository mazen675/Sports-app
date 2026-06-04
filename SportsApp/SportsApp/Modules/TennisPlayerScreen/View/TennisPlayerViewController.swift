import UIKit

class TennisPlayerViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, TennisPlayerViewProtocol {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var presenter: TennisPlayerPresenterProtocol!
    
    var activityIndicator = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.fetchPlayerDetails()
    }
    
    private func setupUI(){
        collectionView.dataSource = self
        collectionView.delegate = self
        
        activityIndicator.color = .titles
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        
        let layout = UICollectionViewCompositionalLayout { [weak self] index, environment in
            guard let self = self else { return nil }
            
            switch index {
            case 0 : return self.setHeaderSection()
            case 1 : return !self.presenter.hasStats() ? self.setEmptyStateSection() : self.setStatisticsSection()
            case 2 : return !self.presenter.hasTournaments() ? self.setEmptyStateSection() :  self.setTournamentsSection()
            default : return self.setTournamentsSection()
            }
        }
        
        let headerNib = UINib(nibName: "SectionHeaderView", bundle: nil)
        collectionView.register(headerNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeader")
        
        let emptyNib = UINib(nibName: "EmptyStateCollectionViewCell", bundle: nil)
        collectionView.register(emptyNib, forCellWithReuseIdentifier: "EmptyStateCell")
        
        collectionView.setCollectionViewLayout(layout, animated: true)
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
    
    func reloadData() {
        DispatchQueue.main.async { self.collectionView.reloadData() }
    }
    
    func showError(message: String) {
        DispatchQueue.main.async { print("Error: \(message)") }
    }
    
    
    func setHeaderSection() -> NSCollectionLayoutSection {
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
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(320))
        let mygroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
       
        mygroup.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 16)
        
        let section = NSCollectionLayoutSection(group: mygroup)
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 16)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    func setTournamentsSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(100))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(100))
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
        return presenter.numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.numberOfItems(in: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let item = presenter.item(at: indexPath)
            
            switch item {
            case .header(let playerInfo):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "headerCell", for: indexPath) as! HeaderCollectionViewCell
                cell.config(with: playerInfo)
                return cell
                
            case .stat(let stat):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "statisticsCell", for: indexPath) as! StatisticsCollectionViewCell
                cell.config(with: stat)
                return cell
                
            case .tournament(let tournament):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tournamentCell", for: indexPath) as! TournamentCollectionViewCell
                cell.config(with: tournament)
                return cell
                
            case .emptyState(let title, let subtitle):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmptyStateCell", for: indexPath) as! EmptyStateCollectionViewCell
                cell.config(title: title, subtitle: subtitle)
                return cell
            }
     }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as! SectionHeaderView
        
        switch indexPath.section {
        case 1: header.titleLabel.text = "statistics_header".localized
        case 2: header.titleLabel.text = "tournaments_header".localized
        default: header.titleLabel.text = ""
        }
        
        return header
    }
}
