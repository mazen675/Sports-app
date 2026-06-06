//
//  MockNetworkService.swift
//  SportsAppTests
//
//  Created by Mazen Amr on 05/06/2026.
//

import Foundation
@testable import SportsApp
class MockNetworkService :NetworkFetching {
    var shouldReturnError: Bool
    var fakeJSONObj: [String: Any]?
    
    init(shouldReturnError: Bool = false) {
        self.shouldReturnError = shouldReturnError
    }
    
    enum MockError: Error {
        case responseError
    }
    
    func fetchData<T: Decodable>(from url: String, completion: @escaping (Result<T, Error>) -> Void) {
        if shouldReturnError {
            completion(.failure(MockError.responseError))
            return
        }
        
        guard let fakeJSONObj = fakeJSONObj else { return }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: fakeJSONObj)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let result = try decoder.decode(T.self, from: data)
            completion(.success(result))
        } catch {
            completion(.failure(error))
        }
    }
}
