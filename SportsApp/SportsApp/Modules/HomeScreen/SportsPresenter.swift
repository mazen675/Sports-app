import Foundation

class SportsPresenter: SportsPresenterProtocol {
    
    // Weak reference to avoid memory leaks
    weak var view: SportsViewProtocol?
    
    // The local data source (from your SportModel.swift)
    private let sportsList = availableSports
    
    init(view: SportsViewProtocol) {
        self.view = view
    }
    
    var sportsCount: Int {
        return sportsList.count
    }
    
    func configureCell(at index: Int) -> SportModel {
        return sportsList[index]
    }
    
    func didSelectSport(at index: Int) {
        let selectedSport = sportsList[index]
        // Tell the view to navigate, passing the endpoint (e.g., "football")
        view?.navigateToLeagues(for: selectedSport.name, endpoint: selectedSport.apiEndpoint)
    }
}
