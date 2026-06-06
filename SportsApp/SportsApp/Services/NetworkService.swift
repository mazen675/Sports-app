import Foundation
import Alamofire

protocol NetworkFetching {
    func fetchData<T: Decodable>(from url: String, completion: @escaping (Result<T, Error>) -> Void)
}

class NetworkService : NetworkFetching{
    static let shared = NetworkService()
    
    private init() {}
    
    func fetchData<T: Decodable>(from url: String, completion: @escaping (Result<T, Error>) -> Void) {
        
        let customDecoder = JSONDecoder()
        customDecoder.keyDecodingStrategy = .convertFromSnakeCase

        AF.request(url).responseDecodable(of: T.self, decoder: customDecoder) { response in
            switch response.result {
            case .success(let decodedData):
                completion(.success(decodedData))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
