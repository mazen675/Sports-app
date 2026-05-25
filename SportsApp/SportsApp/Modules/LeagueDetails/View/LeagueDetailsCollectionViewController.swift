import UIKit

private let reuseIdentifier = "Cell"

class LeagueDetailsCollectionViewController: UICollectionViewController, LeagueDetailsViewProtocol {

    var presenter: LeagueDetailsPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        self.collectionView.backgroundColor = .systemBackground
        
        let layout = UICollectionViewCompositionalLayout { index, environment in
            switch index {
                case 0 : return self.setContestantsSection()
                case 1 : return self.setUpcomingEventsSection()
                case 2 : return self.setLatestEventsSection()
                default : return self.setLatestEventsSection()
            }
        }
        
        collectionView.setCollectionViewLayout(layout, animated: true)
        collectionView.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 0)
        
        // 🚨 THE FIX: We deleted the NIB registrations for the cells because they are in the Storyboard!
        // We ONLY register the Header because that one actually is a separate .xib file.
        let headerNib = UINib(nibName: "SectionHeaderView", bundle: nil)
        collectionView.register(headerNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeader")
        
        presenter.fetchLeagueDetails()
    }
    
    // MARK: - MVP Methods
    func showLoading() { print("Loading League Details...") }
    func hideLoading() { print("Finished Loading League Details") }
    func reloadData() {
        DispatchQueue.main.async { self.collectionView.reloadData() }
    }
    func showError(_ message: String) { print("Error: \(message)") }
    
    // MARK: - Layout Sections
    func setContestantsSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(120), heightDimension: .absolute(120))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
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
        return addHeader(to: section)
    }
    
    func setLatestEventsSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(150))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 16
        return addHeader(to: section)
    }
    
    private func addHeader(to section: NSCollectionLayoutSection) -> NSCollectionLayoutSection {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [header]
        return section
    }

    // MARK: - UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int { return 3 }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0: return presenter.teamsCount
        case 1: return presenter.upcomingEventsCount
        case 2: return presenter.latestEventsCount
        default: return 0
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            // 🚨 THE FIX: Changed to lowercase "contestantCell" to match Storyboard exactly!
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "contestantCell", for: indexPath) as! ContestantCollectionViewCell
            cell.config(contestant: presenter.getTeam(at: indexPath.row))
            return cell
            
        case 1:
            // 🚨 THE FIX: Changed to lowercase "upcomingEventCell"
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "upcomingEventCell", for: indexPath) as! UpcomingEventCollectionViewCell
            cell.config(event: presenter.getUpcomingEvent(at: indexPath.row))
            return cell
            
        case 2:
            // 🚨 THE FIX: Changed to lowercase "latestEventCell"
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "latestEventCell", for: indexPath) as! LatestEventCollectionViewCell
            cell.config(event: presenter.getLatestEvent(at: indexPath.row))
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as! SectionHeaderView
        switch indexPath.section {
        case 0: header.titleLabel.text = "Teams"
        case 1: header.titleLabel.text = "Upcoming Events"
        case 2: header.titleLabel.text = "Latest Events"
        default: header.titleLabel.text = ""
        }
        return header
    }

    // MARK: - Navigation to Final Screens
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.section == 0 else { return }
        
        let selectedTeam = presenter.getTeam(at: indexPath.row)
        guard let teamId = selectedTeam.teamKey else { return }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if presenter.sportEndpoint == "tennis" {
            if let tennisVC = storyboard.instantiateViewController(withIdentifier: "TennisPlayerViewController") as? TennisPlayerViewController {
                tennisVC.presenter = TennisPlayerPresenter(view: tennisVC, playerId: teamId)
                self.navigationController?.pushViewController(tennisVC, animated: true)
            }
        } else {
            if let teamVC = storyboard.instantiateViewController(withIdentifier: "TeamDetailsViewController") as? TeamDetailsViewController {
                teamVC.presenter = TeamDetailsPresenter(view: teamVC, sportEndpoint: presenter.sportEndpoint, teamId: teamId)
                self.navigationController?.pushViewController(teamVC, animated: true)
            }
        }
    }
}
