import Foundation
import Alamofire 

class NetworkService {
    
    // Singleton instance for global access
    static let shared = NetworkService()
    
    private init() {}
    
    /// A generic network request function using Alamofire
    func fetchData<T: Decodable>(from url: String, completion: @escaping (Result<T, Error>) -> Void) {
        
        AF.request(url).validate().responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let decodedData):
                completion(.success(decodedData))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
