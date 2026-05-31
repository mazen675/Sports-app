import Foundation
import Alamofire 

class NetworkService {
    
    static let shared = NetworkService()
    
    private init() {}
    
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
