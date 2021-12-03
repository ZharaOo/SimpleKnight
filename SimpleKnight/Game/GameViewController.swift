//
//  GameViewController.swift
//  SimpleKnight
//
//  Created by Ivan Babkin on 13.08.2018.
//  Copyright © 2018 Ivan Babkin. All rights reserved.
//

import UIKit
import GoogleMobileAds
import GameKit

class GameViewController: UIViewController, FinishViewDelegate, GADInterstitialDelegate, PauseViewDelegate {
    
    var interstitial: GADInterstitial?
    
    
    // MARK: - FinishViewDelegate & PauseViewDelegate
    
    func goToMainMenu() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func resumeGame() { }
    
    func playAgainGame() { }
    
    
    // MARK: - GADInterstitialDelegate
    
    func createAndLoadInterstitial(id: String) -> GADInterstitial {
        let interstitial = GADInterstitial(adUnitID: id)
        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
    }
    
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        interstitial?.present(fromRootViewController: self)
    }
    
    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
        interstitial = nil
    }
    
    
    // MARK: - Views Showing methods
    
    func showPauseView() {
        let pauseView = PauseView.instanceFromNib()
        pauseView.delegate = self
        self.view.addSubview(pauseView)
        pauseView.show()
    }
    
    func showFinishView(score: Int, bestScore: Int) {
        let finishView = FinishView.instanceFromNib(score: score, bestScore: bestScore)
        finishView.delegate = self
        self.view.addSubview(finishView)
    }
    
    func showAd() {
        let gamesPlayed = UserDefaults.standard.integer(forKey: "GamesPlayed")
        if gamesPlayed % 2 == 0 {
            self.interstitial = self.createAndLoadInterstitial(id: Google.classicAdID)
        }
        UserDefaults.standard.set(gamesPlayed + 1, forKey: "GamesPlayed")
    }
    
    
    // MARK: - GameCenter methods
    
    func configureAndPostAchievement(id: String) {
        let achievement = GKAchievement(identifier: id)
        achievement.percentComplete = 100.0
        achievement.showsCompletionBanner = true
        
        GKAchievement.report([achievement]) { error in
            if error != nil {
                print(error!.localizedDescription)
            }
            else {
                print("Score submitted")
            }
        }
    }
    
    func reportTimeToGameCenter(score: Int, leaderboardID: String) {
        let sScore = GKScore(leaderboardIdentifier: leaderboardID)
        sScore.value = Int64(score)
        
        GKScore.report([sScore], withCompletionHandler: { error in
            if error != nil {
                print(error!.localizedDescription)
            }
            else {
                print("Score submitted")
            }
        })
    }

}
