//
//  LeagueDetailsCollectionViewController.swift
//  SportsApp
//
//  Created by Mazen Amr on 23/05/2026.
//

import UIKit

private let reuseIdentifier = "Cell"

class LeagueDetailsCollectionViewController: UICollectionViewController {

    var upcomingEvents: [Fixture]  = []
    var latestEvents: [Fixture]  = []
    var contestants: [Contestant]  = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        let layout = UICollectionViewCompositionalLayout{
            index,environment in
            switch index{
                case 0 : return self.setUpcomingEventsSection()
                case 1 : return self.setLatestEventsSection()
                case 2 : return self.setContestantsSection()
                default : return self.setContestantsSection()
            }
        }
        
        collectionView.setCollectionViewLayout(layout, animated: true)
        
        let headerNib = UINib(nibName: "SectionHeaderView", bundle: nil)
            collectionView.register(headerNib,
                                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                    withReuseIdentifier: "SectionHeader")
        
        // Register cell classes
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        
        let teamA = Contestant(id: 1, name: "Red Dragons", logoURL: "https://via.placeholder.com/150/FF0000/FFFFFF?text=Dragons")
            let teamB = Contestant(id: 2, name: "Blue Knights", logoURL: "https://via.placeholder.com/150/0000FF/FFFFFF?text=Knights")
            let teamC = Contestant(id: 3, name: "Green Eagles", logoURL: "https://via.placeholder.com/150/008000/FFFFFF?text=Eagles")
            let teamD = Contestant(id: 4, name: "Golden Lions", logoURL: "https://via.placeholder.com/150/FFD700/000000?text=Lions")
            
            // Assign to contestants array
            self.contestants = [teamA, teamB, teamC, teamD]
            
            // 2. Create Dummy Upcoming Events (now with IDs)
        self.upcomingEvents = [
                Fixture(id: 101, date: "25 May 2026", time: "18:00", status: "Scheduled", score: nil, homeContestant: teamA, awayContestant: teamB),
                Fixture(id: 102, date: "27 May 2026", time: "20:30", status: "Scheduled", score: nil, homeContestant: teamC, awayContestant: teamD)
            ]
            
            // 3. Create Dummy Latest Events (Added "Finished" status)
            self.latestEvents = [
                Fixture(id: 201, date: "20 May 2026", time: "19:00", status: "Finished", score: "2 - 1", homeContestant: teamB, awayContestant: teamC),
                Fixture(id: 202, date: "18 May 2026", time: "16:00", status: "Finished", score: "0 - 3", homeContestant: teamD, awayContestant: teamA),
                Fixture(id: 203, date: "15 May 2026", time: "21:00", status: "Finished", score: "1 - 1", homeContestant: teamA, awayContestant: teamC)
            ]
        
    }
    func setUpcomingEventsSection()->NSCollectionLayoutSection{

        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(200))
        
        let mygroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        mygroup.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        let section = NSCollectionLayoutSection(group: mygroup)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 0)
        
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .absolute(44))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                 elementKind: UICollectionView.elementKindSectionHeader,
                                                                 alignment: .top)
        section.boundarySupplementaryItems = [header]
        return section
    }
    
    func setLatestEventsSection()->NSCollectionLayoutSection{
        

        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(150))
        
        let mygroup = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        mygroup.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        let section = NSCollectionLayoutSection(group: mygroup)
        
        section.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 16, bottom: 16, trailing: 0)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .absolute(44))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                 elementKind: UICollectionView.elementKindSectionHeader,
                                                                 alignment: .top)
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    func setContestantsSection()->NSCollectionLayoutSection{

        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3), heightDimension: .absolute(150))
        
        let mygroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        mygroup.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)
        
        let section = NSCollectionLayoutSection(group: mygroup)
       
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 0, bottom: 16, trailing: 0)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .absolute(44))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                 elementKind: UICollectionView.elementKindSectionHeader,
                                                                 alignment: .top)
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
            case 0:
                return upcomingEvents.count
            case 1:
                return latestEvents.count
            case 2:
                return contestants.count
            default:
                return 0
            }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0 :
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "upcomingEventCell", for: indexPath) as! UpcomingEventCollectionViewCell
            
            cell.config(fixture: upcomingEvents[indexPath.row])
            return cell
            
        case 1 :
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "latestEventCell", for: indexPath) as! LatestEventCollectionViewCell
            cell.config(fixture: latestEvents[indexPath.row])
            return cell
        case 2 :
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "contestantCell", for: indexPath) as! ContestantCollectionViewCell
            cell.config(contestant: contestants[indexPath.row])
            return cell
        default :
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "contestantCell", for: indexPath)
            return cell
        }
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as! SectionHeaderView
        
        switch indexPath.section {
        case 0: header.titleLabel.text = "Upcoming Events"
        case 1: header.titleLabel.text = "Latest Events"
        case 2: header.titleLabel.text = "Teams"
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
