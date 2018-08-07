//
//  GameViewController.swift
//  SimpleKnight
//
//  Created by Ivan Babkin on 30.06.2018.
//  Copyright © 2018 Ivan Babkin. All rights reserved.
//

import UIKit
import GoogleMobileAds
import GameKit

class ClassicGameViewController: UIViewController, GameDelegate, FinishViewDelegate, PauseViewDelegate, GADInterstitialDelegate {

    @IBOutlet weak var field: ClassicFieldView!
    @IBOutlet weak var movesLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    var game: ClassicGame!
    var rulesView: RulesView!
    var interstitial: GADInterstitial?
    var allCornersVisited = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movesLabel.layer.masksToBounds = true
        scoreLabel.layer.masksToBounds = true
        movesLabel.layer.cornerRadius = 8.0
        scoreLabel.layer.cornerRadius = 8.0
        scoreLabel.adjustsFontSizeToFitWidth = true;
        startGame()
    }
    
    override func viewDidLayoutSubviews() {
        if rulesView == nil && !UserDefaults.standard.bool(forKey: "ClassicRulesShown") {
            rulesView = RulesView(frame: CGRect(x: 0.0, y: field.frame.maxY, width: view.frame.width, height: view.frame.height - field.frame.maxY))
            rulesView.setText(text: "Tap on any cell to place a knight.")
            view.addSubview(rulesView)
        }
    }
    
    func startGame() {
        game = ClassicGame(field: field)
        game.delegate = self
        
        updateLabels()
    }
    
    func updateLabels() {
        movesLabel.text = "Moves: \(game!.moves)"
        scoreLabel.text = "Score: \(game!.score)"
        
        checkMovesAchievements(moves: game.moves)
        
        if field.cornerPassed && !allCornersVisited {
            configureAndPostAchievement(id: "fa_corner")
            allCornersVisited = true
        }
        
        if !UserDefaults.standard.bool(forKey: "ClassicRulesShown") {
            switch game!.moves {
            case 0:
                break
            case 1:
                rulesView.setText(text: "Move knight like a chess knight.")
            case 2:
                rulesView.setText(text: "Your goal is to fill all field's cells. You can not step on the same cell twice. Good luck!")
            default:
                UserDefaults.standard.set(true, forKey: "ClassicRulesShown")
                rulesView.removeFromSuperview()
            }
        }
    }
    
    @IBAction func pauseGame(_ sender: Any) {
        let pauseView = PauseView.instanceFromNib(score: self.game.score, bestScore: 0)
        pauseView.delegate = self
        self.view.addSubview(pauseView)
        pauseView.show()
    }
    
    func goToMainMenu() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func resumeGame() {
        
    }
    
    func playAgainGame() {
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
            self.interstitial = self.createAndLoadInterstitial(id: Google.classicAdID)
        })
        
        reportTimeToGameCenter(score: game.score)
        configureAndPostAchievement(id: "fbeginner")
    }
    
    
    //MARK: - Game Center methods
    
    
    func reportTimeToGameCenter(score: Int) {
        let leaderboardID = "down_scores_classic"
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
    
    func checkMovesAchievements(moves: Int) {
        switch moves {
        case 60:
            configureAndPostAchievement(id: "fpole1_16")
        case 61:
            configureAndPostAchievement(id: "fpole1_8")
        case 62:
            configureAndPostAchievement(id: "fpole1_4")
        case 63:
            configureAndPostAchievement(id: "fpole1_2")
        case 64:
            configureAndPostAchievement(id: "fpole1_1")
        default:
            break
        }
    }
    
}
