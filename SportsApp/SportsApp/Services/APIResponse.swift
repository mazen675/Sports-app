struct APIResponse<T: Decodable>: Decodable {
    let success: Int?
    let result: [T]?
}
