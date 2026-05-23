//
//  LeagueModel.swift
//  SportsApp
//
//  Created by Youssef Abd El-Fatah on 23/05/2026.
//


import Foundation

struct LeagueModel: Decodable {
    var leagueKey: String?
    let leagueName: String?
    let leagueLogo: String?
    let countryName: String?
    
    // Safe UI Properties
    var safeLeagueName: String { return leagueName ?? "Unknown League" }
    var safeLeagueLogo: String { return leagueLogo ?? "placeholder_logo" } 
    var safeCountryName: String { return countryName ?? "Unknown Country" }
    
    enum CodingKeys: String, CodingKey {
        case leagueKey = "league_key"
        case leagueName = "league_name"
        case leagueLogo = "league_logo"
        case countryName = "country_name"
    }
    
    // Bulletproof Decoder for Type Mismatches
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        leagueName = try container.decodeIfPresent(String.self, forKey: .leagueName)
        leagueLogo = try container.decodeIfPresent(String.self, forKey: .leagueLogo)
        countryName = try container.decodeIfPresent(String.self, forKey: .countryName)
        
        if let intKey = try? container.decodeIfPresent(Int.self, forKey: .leagueKey) {
            leagueKey = String(intKey)
        } else if let stringKey = try? container.decodeIfPresent(String.self, forKey: .leagueKey) {
            leagueKey = stringKey
        } else {
            leagueKey = nil
        }
    }
}