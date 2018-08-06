//
//  CollectGameViewController.swift
//  SimpleKnight
//
//  Created by Ivan Babkin on 30.06.2018.
//  Copyright © 2018 Ivan Babkin. All rights reserved.
//

import UIKit
import GoogleMobileAds
import GameKit

class CollectGameViewController: UIViewController, GameDelegate, FinishViewDelegate, PauseViewDelegate, GADInterstitialDelegate {
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var field: CollectFieldView!
    
    var game: CollectGame!
    var rulesView: RulesView!
    var interstitial: GADInterstitial?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timeLabel.layer.masksToBounds = true
        scoreLabel.layer.masksToBounds = true
        timeLabel.layer.cornerRadius = 8.0
        scoreLabel.layer.cornerRadius = 8.0
        scoreLabel.adjustsFontSizeToFitWidth = true;
        startGame()
    }
    
    override func viewDidLayoutSubviews() {
        if rulesView == nil && !UserDefaults.standard.bool(forKey: "CollectRulesShown") {
            rulesView = RulesView(frame: CGRect(x: 0.0, y: field.frame.maxY, width: view.frame.width, height: view.frame.height - field.frame.maxY))
            rulesView.setText(text: "Collect as many red chips as you can. Better not to step on cross cell.")
            view.addSubview(rulesView)
        }
    }
    
    func startGame() {
        game = CollectGame(field: field)
        game.delegate = self
        updateLabels()
    }
    
    func updateLabels() {
        timeLabel.text = "Time: \(game.time)"
        scoreLabel.text = "Score: \(game.score)"
        
        checkChipsAchievements(collectedChips: game.chips)
        
        if !UserDefaults.standard.bool(forKey: "CollectRulesShown") {
            switch game!.score {
            case 0:
                break
            default:
                UserDefaults.standard.set(true, forKey: "CollectRulesShown")
                rulesView.removeFromSuperview()
            }
        }
    }
    
    @IBAction func pauseGame(_ sender: Any) {
        game.stopTimer()
        let pauseView = PauseView.instanceFromNib(score: self.game.score, bestScore: 0)
        pauseView.delegate = self
        self.view.addSubview(pauseView)
        pauseView.show()
    }
    
    func goToMainMenu() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func resumeGame() {
        game.startTimer()
    }
    
    func playAgainGame() {
        game.stopTimer()
        field.clearField()
        startGame()
    }
    
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
    
    func finishGame(bestScore: Int) {
        UIView.animate(withDuration: 1.0, animations: { self.field.hideKnight() }, completion: { complete in
            let finishView = FinishView.instanceFromNib(score: self.game.score, bestScore: bestScore)
            finishView.delegate = self
            self.view.addSubview(finishView)
            self.interstitial = self.createAndLoadInterstitial(id: Google.collectAdID)
        })
        
        reportTimeToGameCenter(score: game.score)
        configureAndPostAchievement(id: "fbeginner")
    }
    
    
    //MARK: - Game Center methods
    
    
    func reportTimeToGameCenter(score: Int) {
        let leaderboardID = "down_scores_challenge"
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
    
    func checkChipsAchievements(collectedChips: Int) {
        switch collectedChips {
        case 10:
            configureAndPostAchievement(id: "10_chips")
        case 15:
            configureAndPostAchievement(id: "15_chips")
        case 20:
            configureAndPostAchievement(id: "20_chips")
        case 25:
            configureAndPostAchievement(id: "25_chips")
        case 30:
            configureAndPostAchievement(id: "30_chips")
        case 35:
            configureAndPostAchievement(id: "35_chips")
        case 50:
            configureAndPostAchievement(id: "50_chips")
        case 70:
            configureAndPostAchievement(id: "70_chips")
        default:
            break
        }
    }

}
