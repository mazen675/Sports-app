//
//  CoreDataManager.swift
//  SportsApp
//
//  Created by Mazen Amr on 25/05/2026.
//

import Foundation
import UIKit
import CoreData

protocol CoreDataManaging {
    func fetchAllFavorites() -> [NSObject]
    func deleteLeague(key: Int)
    func isFavorite(key: Int) -> Bool
    func toggleFavorite(league: LeagueModel, sport: String)
}

class CoreDataManager :CoreDataManaging{
    static let shared = CoreDataManager()
    private let context: NSManagedObjectContext
    private let entity :NSEntityDescription!
    
    init(context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)  {
            self.context = context
            self.entity = NSEntityDescription.entity(forEntityName: "FavouriteLeague", in: self.context)
     }
    
    func toggleFavorite(league: LeagueModel, sport: String) {
        guard let key = league.leagueKey else { return }
        
        if isFavorite(key: key) {
            deleteLeague(key: key)
        } else {
            saveLeague(league: league, sport: sport)
        }
    }
    
    private func saveLeague(league: LeagueModel, sport: String) {
        let fav = NSManagedObject(entity: entity, insertInto: context)
        
        fav.setValue(league.leagueKey, forKey: "key")
        fav.setValue(league.safeLeagueName, forKey: "name")
        fav.setValue(league.leagueLogo, forKey: "logo")
        fav.setValue(league.safeCountryName, forKey: "info")
        fav.setValue(sport, forKey: "sport")
        
        try? context.save()
    }
    
    func deleteLeague(key: Int) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavouriteLeague")
        fetchRequest.predicate = NSPredicate(format: "key == %d", key)
        
        if let results = try? context.fetch(fetchRequest), let leagueToDelete = results.first {
            context.delete(leagueToDelete)
            try? context.save()
        }
        
    }
    
    func isFavorite(key: Int) -> Bool {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavouriteLeague")
        fetchRequest.predicate = NSPredicate(format: "key == %d", key)
        let count = (try? context.count(for: fetchRequest)) ?? 0
        return count > 0
    }
    
    func fetchAllFavorites() -> [NSObject] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavouriteLeague")
        let favouriteLeagues = (try? context.fetch(fetchRequest)) ?? []
        return favouriteLeagues
        
    }
}
