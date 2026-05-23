import Foundation

// The generic wrapper required by AllSportsAPI
struct APIResponse<T: Decodable>: Decodable {
    let success: Int?
    let result: [T]?
}
