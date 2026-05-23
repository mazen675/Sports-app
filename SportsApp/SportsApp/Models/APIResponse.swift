//
//  APIResponse.swift
//  SportsApp
//
//  Created by Youssef Abd El-Fatah on 23/05/2026.
//


import Foundation

// The generic wrapper required by AllSportsAPI
struct APIResponse<T: Decodable>: Decodable {
    let success: Int?
    let result: [T]?
}