//
//  Fixture.swift
//  SportsApp
//
//  Created by Mazen Amr on 23/05/2026.
//

import Foundation

struct Fixture {
    let id: Int
    let date: String
    let time: String
    let status: String?
    let score: String?
    
    let homeContestant: Contestant
    let awayContestant: Contestant

}
