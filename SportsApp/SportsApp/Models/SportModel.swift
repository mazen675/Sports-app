import Foundation

struct SportModel {
    let name: String
    let image: String
    let apiEndpoint: String 
}

let availableSports: [SportModel] = [
    SportModel(name: "Football", image: "football_bg", apiEndpoint: "football"),
    SportModel(name: "Basketball", image: "basketball_bg", apiEndpoint: "basketball"),
    SportModel(name: "Tennis", image: "tennis_bg", apiEndpoint: "tennis"),
    SportModel(name: "Cricket", image: "cricket_bg", apiEndpoint: "cricket")
]
