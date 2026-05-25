//
//  TennisPlayerViewController.swift
//  SportsApp
//
//  Created by Mazen Amr on 25/05/2026.
//

import UIKit

class TennisPlayerViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    var tennisPlayer:TennisPlayerModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tennisPlayer = getMockPlayer()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        // Do any additional setup after loading the view.
        let layout = UICollectionViewCompositionalLayout{
            index,environment in
            switch index{
                case 0 : return self.setHeaderSection()
                case 1 : return self.setStatisticsSection()
                case 2 : return self.setTournamentsSection()
                default : return self.setTournamentsSection()
            }
        }
        let headerNib = UINib(nibName: "SectionHeaderView", bundle: nil)
            collectionView.register(headerNib,
                                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                    withReuseIdentifier: "SectionHeader")
        
        collectionView.setCollectionViewLayout(layout, animated: true)
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
    func setStatisticsSection() -> NSCollectionLayoutSection{
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(300))
        
        let mygroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        mygroup.contentInsets = NSDirectionalEdgeInsets(top: 14, leading: 10, bottom: 10, trailing: 16)
        
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
    
    func setTournamentsSection() ->NSCollectionLayoutSection{
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(200))
        
        let mygroup = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        mygroup.contentInsets = NSDirectionalEdgeInsets(top: 14, leading: 10, bottom: 10, trailing: 10)
        
        let section = NSCollectionLayoutSection(group: mygroup)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16)
        
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .absolute(44))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                 elementKind: UICollectionView.elementKindSectionHeader,
                                                                 alignment: .top)
        section.boundarySupplementaryItems = [header]
        return section
    }

    
     func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }


     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        switch section {
            case 0:
                return 1
            case 1:
                return tennisPlayer!.stats!.count
            case 2:
                return tennisPlayer!.tournaments!.count
            default:
                return 0
            }
    }

     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0 :
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "headerCell", for: indexPath) as! HeaderCollectionViewCell
            cell.config(with: tennisPlayer!)
            return cell
        case 1 :
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "statisticsCell", for: indexPath) as! StatisticsCollectionViewCell
            cell.config(with: tennisPlayer!.stats![indexPath.row])
            return cell
            
        case 2 :
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tournamentCell", for: indexPath) as! TournamentCollectionViewCell
            cell.config(with: tennisPlayer!.tournaments![indexPath.row])
            return cell
     
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
        case 1: header.titleLabel.text = "Statistics"
        case 2: header.titleLabel.text = "Tournaments"
        default: header.titleLabel.text = ""
        }
        
        return header
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    func getMockPlayer() -> TennisPlayerModel? {
        let mockJSON = """
        {
            "player_key": "1905",
            "player_name": "N. Djokovic",
            "player_country": "Serbia",
            "player_bday": "22.05.1987",
            "player_logo": "https://apiv2.allsportsapi.com/logo-tennis/1905_n-djokovic.jpg",
            "stats": [
                {
                    "season": "2021", "type": "doubles", "rank": "255",
                    "titles": "0", "matches_won": "6", "matches_lost": "4"
                },
                {
                    "season": "2020", "type": "singles", "rank": "1",
                    "titles": "4", "matches_won": "41", "matches_lost": "5"
                }
            ],
            "tournaments": [
                {
                    "name": "Rome", "season": "2022", "type": "singles",
                    "surface": "clay", "prize": "€4,332,325"
                },
                {
                    "name": "Wimbledon", "season": "2021", "type": "singles",
                    "surface": "grass", "prize": "£13,490,000"
                }
            ]
        }
        """.data(using: .utf8)!

        do {
            return try JSONDecoder().decode(TennisPlayerModel.self, from: mockJSON)
        } catch {
            print("Mock decoding failed: \(error)")
            return nil
        }
    }
}



