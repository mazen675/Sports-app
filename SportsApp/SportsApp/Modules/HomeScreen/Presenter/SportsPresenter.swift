import Foundation

class SportsPresenter: SportsPresenterProtocol {
    
    weak var view: SportsViewProtocol?
    
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
        view?.navigateToLeagues(for: selectedSport.name, endpoint: selectedSport.apiEndpoint)
    }
}
