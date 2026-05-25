//
//  LeagueDetailsCollectionViewController.swift
//  SportsApp
//
//  Created by Mazen Amr on 23/05/2026.
//

import UIKit

private let reuseIdentifier = "Cell"

class LeagueDetailsCollectionViewController: UICollectionViewController , LeagueDetailsViewProtocol{

    var presenter: LeagueDetailsPresenter!
    override func viewDidLoad() {
            super.viewDidLoad()
        presenter = LeagueDetailsPresenter(view: self, sportEndpoint: "football", leagueId: "34")
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
            
            let headerNib = UINib(nibName: "SectionHeaderView", bundle: nil)
            collectionView.register(headerNib,
                                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                    withReuseIdentifier: "SectionHeader")
            
            presenter.fetchLeagueDetails()
        }
    
    func showLoading() {
            // Show an activity indicator
        }
        
        func hideLoading() {
            // Hide the activity indicator
        }
        
        func reloadData() {
            collectionView.reloadData()
        }
        
        func showError(_ message: String) {
            // Show UIAlertController
        }
    
    func setUpcomingEventsSection()->NSCollectionLayoutSection{

        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(200))
        
        let mygroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        mygroup.contentInsets = NSDirectionalEdgeInsets(top: 14, leading: 10, bottom: 10, trailing: 10)
        
        let section = NSCollectionLayoutSection(group: mygroup)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16)
        
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .absolute(44))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                 elementKind: UICollectionView.elementKindSectionHeader,
                                                                 alignment: .top)
        section.boundarySupplementaryItems = [header]
        return section
    }
    
    func setLatestEventsSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
       
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(150))
        let mygroup = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        mygroup.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16)
        
        let section = NSCollectionLayoutSection(group: mygroup)
        
        section.contentInsets = NSDirectionalEdgeInsets(top: 14, leading: 0, bottom: 16, trailing: 0)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        header.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    func setContestantsSection() -> NSCollectionLayoutSection {

        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3), heightDimension: .absolute(150))
        
        let mygroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        mygroup.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 16, bottom: 0, trailing: 0)
        
        let section = NSCollectionLayoutSection(group: mygroup)
        
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 0, bottom: 0, trailing: 0)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .absolute(60))

        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                 elementKind: UICollectionView.elementKindSectionHeader,
                                                                 alignment: .top)

        header.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16)
        
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "contestantCell", for: indexPath) as! ContestantCollectionViewCell
            cell.config(contestant: presenter.getTeam(at: indexPath.row))
            return cell
            
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "upcomingEventCell", for: indexPath) as! UpcomingEventCollectionViewCell
            cell.config(event: presenter.getUpcomingEvent(at: indexPath.row))
            return cell
            
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "latestEventCell", for: indexPath) as! LatestEventCollectionViewCell
            cell.config(event: presenter.getLatestEvent(at: indexPath.row))
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as! SectionHeaderView
        
        switch indexPath.section {
        case 0: header.titleLabel.text = "Teams"
        case 1: header.titleLabel.text = "Upcoming Events"
        case 2: header.titleLabel.text = "Latest Events"
        default: header.titleLabel.text = ""
        }
        
        return header
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
