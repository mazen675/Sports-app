//
//  CoreDataManager.swift
//  SportsApp
//
//  Created by Mazen Amr on 25/05/2026.
//

import Foundation
import UIKit
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private let entity :NSEntityDescription!
    private init() {
        entity = NSEntityDescription.entity(forEntityName: "FavouriteLeague", in: context)
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
    
    func deleteLeague(key: String) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavouriteLeague")
        fetchRequest.predicate = NSPredicate(format: "key == %@", key)
        
        if let results = try? context.fetch(fetchRequest), let leagueToDelete = results.first {
            context.delete(leagueToDelete)
            try? context.save()
        }
        
    }
    
    func isFavorite(key: String) -> Bool {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavouriteLeague")
        fetchRequest.predicate = NSPredicate(format: "key == %@", key)
        let count = (try? context.count(for: fetchRequest)) ?? 0
        return count > 0
    }
    
    func fetchAllFavorites() -> [NSManagedObject] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavouriteLeague")
        let favouriteLeagues = (try? context.fetch(fetchRequest)) ?? []
        return favouriteLeagues
        
    }
}
