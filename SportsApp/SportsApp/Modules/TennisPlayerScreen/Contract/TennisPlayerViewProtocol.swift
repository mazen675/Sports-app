//
//  TennisPlayerViewProtocol.swift
//  SportsApp
//
//  Created by Ahmed Tayseer on 25/05/2026.
//


import Foundation

protocol TennisPlayerViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func displayPlayerDetails(player: TennisPlayerModel)
    func showError(message: String)
    func showNetworkAlert()
}

protocol TennisPlayerPresenterProtocol {
    func fetchPlayerDetails()
    func viewWillAppear()
}
