//
//  NetworkManager.swift
//  SportsApp
//
//  Created by Mazen Amr on 30/05/2026.
//

import Foundation
import Reachability

class NetworkManager {
    static let shared = NetworkManager()
    var reachability : Reachability?
    
    private init() {
      
    }
    
    func hasConnectivity() -> Bool {
        do {
            reachability = try? Reachability()
            print("result \(self.reachability?.connection != .unavailable)")
            return self.reachability?.connection != .unavailable
        } catch {
            print("Could not start reachability: \(error)")
            return false
        }
    }
}
