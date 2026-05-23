//
//  SportModel.swift
//  SportsApp
//
//  Created by Youssef Abd El-Fatah on 23/05/2026.
//


import Foundation

// Used for the first screen (Tabs). Does not need Decodable because it is local data.
struct SportModel {
    let name: String
    let image: String // The exact name of the image in your Assets.xcassets
    let apiEndpoint: String 
}

let availableSports: [SportModel] = [
    SportModel(name: "Football", image: "football_bg", apiEndpoint: "football"),
    SportModel(name: "Basketball", image: "basketball_bg", apiEndpoint: "basketball"),
    SportModel(name: "Tennis", image: "tennis_bg", apiEndpoint: "tennis"),
    SportModel(name: "Cricket", image: "cricket_bg", apiEndpoint: "cricket")
]