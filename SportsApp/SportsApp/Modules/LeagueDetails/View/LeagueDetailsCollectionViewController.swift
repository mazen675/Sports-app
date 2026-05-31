import UIKit

private let reuseIdentifier = "Cell"

class LeagueDetailsCollectionViewController: UICollectionViewController, LeagueDetailsViewProtocol {

    var presenter: LeagueDetailsPresenterProtocol!
    
    var activityIndicator = UIActivityIndicatorView(style: .large)
    
    var isLoading:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.color = .titles
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        
        let layout = UICollectionViewCompositionalLayout { index, environment in
            if index == 0 && self.presenter.teamsCount == 0 { return self.setEmptyStateSection() }
            if index == 1 && self.presenter.upcomingEventsCount == 0 { return self.setEmptyStateSection() }
            if index == 2 && self.presenter.latestEventsCount == 0 { return self.setEmptyStateSection() }
            
            switch index {
                case 0 : return self.setContestantsSection()
                case 1 : return self.setUpcomingEventsSection()
                case 2 : return self.setLatestEventsSection()
                default : return self.setLatestEventsSection()
            }
        }
        
        collectionView.setCollectionViewLayout(layout, animated: true)
        collectionView.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 0)
        
        let headerNib = UINib(nibName: "SectionHeaderView", bundle: nil)
        collectionView.register(headerNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeader")
        let emptyNib = UINib(nibName: "EmptyStateCollectionViewCell", bundle: nil)
        collectionView.register(emptyNib, forCellWithReuseIdentifier: "EmptyStateCell")
        presenter.fetchLeagueDetails()
    }
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            presenter.viewWillAppear()
        }
    
    func showLoading() {
        isLoading = true
        DispatchQueue.main.async { self.activityIndicator.startAnimating() }
    }
    
    func hideLoading() {
        isLoading = false
        DispatchQueue.main.async { self.activityIndicator.stopAnimating() }
    }
    
    func reloadData() {
        DispatchQueue.main.async { self.collectionView.reloadData() }
    }
    
    func showError(_ message: String) {
        DispatchQueue.main.async { print("Error: \(message)") }
    }
    
    func showComingSoonAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Coming Soon", message: "Team details for this sport will be available soon.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    func setContestantsSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(120), heightDimension: .absolute(120))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)
        return addHeader(to: section)
    }
    
    func setUpcomingEventsSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.85), heightDimension: .absolute(180))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.interGroupSpacing = 16
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)
        return addHeader(to: section)
    }
    
    func setLatestEventsSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(150))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 16
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)
        return addHeader(to: section)
    }
    
    func setEmptyStateSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 16, trailing: 16)
        
        return addHeader(to: section)
    }
    
    private func addHeader(to section: NSCollectionLayoutSection) -> NSCollectionLayoutSection {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [header]
        return section
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return isLoading || !presenter.isNetworkAvailable ? 0 : 3
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0: return max(1, presenter.teamsCount)
        case 1: return max(1, presenter.upcomingEventsCount)
        case 2: return max(1, presenter.latestEventsCount)
        default: return 0
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let placeHolder = getPlaceholderImage(for: presenter.sportEndpoint)
        switch indexPath.section {
        case 0:
            if presenter.teamsCount == 0 {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmptyStateCell", for: indexPath) as! EmptyStateCollectionViewCell
                    
                    cell.config(title: "No Teams", subtitle: "No teams available right now.")
                    return cell
                    
            }else{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "contestantCell", for: indexPath) as! ContestantCollectionViewCell
                cell.config(contestant: presenter.getTeam(at: indexPath.row), placeHolder: placeHolder )
                return cell
            }
         
        case 1:
            if presenter.upcomingEventsCount == 0 {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmptyStateCell", for: indexPath) as! EmptyStateCollectionViewCell
                    
                    cell.config(title: "No Upcoming Events", subtitle: "No upcoming Events available right now.")
                    return cell
                    
            }else{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "upcomingEventCell", for: indexPath) as! UpcomingEventCollectionViewCell
                cell.config(event: presenter.getUpcomingEvent(at: indexPath.row),placeHolder: placeHolder)
                return cell
            }
     
        case 2: 
            if presenter.latestEventsCount == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmptyStateCell", for: indexPath) as! EmptyStateCollectionViewCell
            
            cell.config(title: "No Latest Events", subtitle: "No latest Events available right now.")
            return cell
            
            }else{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "latestEventCell", for: indexPath) as! LatestEventCollectionViewCell
                cell.config(event: presenter.getLatestEvent(at: indexPath.row) ,placeHolder: placeHolder)
                return cell
            }
          
        default:
            return UICollectionViewCell()
        }
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as! SectionHeaderView
        switch indexPath.section {
        case 0: header.titleLabel.text = presenter.sportEndpoint == "tennis" ? "Players" : "Teams"
        case 1: header.titleLabel.text = "Upcoming Events"
        case 2: header.titleLabel.text = "Latest Events"
        default: header.titleLabel.text = ""
        }
        return header
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didSelectTeam(at: indexPath.row, section: indexPath.section)
    }
    
    func navigateToTennisPlayer(teamId: String) {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let tennisVC = storyboard.instantiateViewController(withIdentifier: "TennisPlayerViewController") as? TennisPlayerViewController else { return }
            tennisVC.presenter = TennisPlayerPresenter(view: tennisVC, playerId: teamId)
            self.navigationController?.pushViewController(tennisVC, animated: true)
        }
    }

    func navigateToTeamDetails(teamId: String, sportEndpoint: String, leagueName: String, leagueExtraInfo: String) {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let teamVC = storyboard.instantiateViewController(withIdentifier: "TeamDetailsViewController") as? TeamDetailsViewController else { return }
            teamVC.presenter = TeamDetailsPresenter(view: teamVC, sportEndpoint: sportEndpoint, teamId: teamId, leagueExtraInfo: leagueExtraInfo , leagueName: leagueName)
            self.navigationController?.pushViewController(teamVC, animated: true)
        }
    }
    
}
