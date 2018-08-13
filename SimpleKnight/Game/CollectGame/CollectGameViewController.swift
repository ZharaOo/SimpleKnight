//
//  CollectGameViewController.swift
//  SimpleKnight
//
//  Created by Ivan Babkin on 30.06.2018.
//  Copyright © 2018 Ivan Babkin. All rights reserved.
//

import UIKit
import GameKit

class CollectGameViewController: GameViewController, GameDelegate {
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var field: CollectFieldView!
    
    @objc var game: CollectGame!
    var rulesView: RulesView!
    var observation: NSKeyValueObservation?
    
    deinit {
        observation?.invalidate()
    }
    
    
    // MARK: - lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timeLabel.layer.masksToBounds = true
        scoreLabel.layer.masksToBounds = true
        timeLabel.layer.cornerRadius = 8.0
        scoreLabel.layer.cornerRadius = 8.0
        scoreLabel.adjustsFontSizeToFitWidth = true;
        
        startGame()
        
        observation = self.observe(\.game.chips) { (cgvc, change)  in
            cgvc.checkChipsAchievements(collectedChips: cgvc.game.chips)
        }
    }
    
    override func viewDidLayoutSubviews() {
        if rulesView == nil && !UserDefaults.standard.bool(forKey: "CollectRulesShown") {
            rulesView = RulesView(frame: CGRect(x: 0.0, y: field.frame.maxY, width: view.frame.width, height: view.frame.height - field.frame.maxY))
            rulesView.setText(text: "Collect as many red chips as you can. Better not to step on cross cell.")
            view.addSubview(rulesView)
        }
    }
    
    
    // MARK: - IBActions
    
    @IBAction func pauseGame(_ sender: Any) {
        game.stopTimer()
        showPauseView()
    }
    
    
    // MARK: - GameDelegate
    
    func updateLabels() {
        timeLabel.text = "Time: \(game.time)"
        scoreLabel.text = "Score: \(game.score)"
        
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
    
    func finishGame(bestScore: Int) {
        UIView.animate(withDuration: 1.0, animations: { self.field.hideKnight() }, completion: { complete in
            self.showFinishView(score: self.game.score, bestScore: bestScore)
            self.showAd()
        })
        
        reportTimeToGameCenter(score: game.score, leaderboardID: "down_scores_challenge")
        configureAndPostAchievement(id: "fbeginner")
    }
    
    
    // MARK: - Override PauseViewDelegate methods
    
    override func resumeGame() {
        game.startTimer()
    }
    
    override func playAgainGame() {
        game.stopTimer()
        field.clearField()
        startGame()
    }
    
    
    // MARK: - Games methods
    
    func startGame() {
        game = CollectGame(field: field)
        game.delegate = self
        updateLabels()
    }
    
    // MARK: - Game Center methods
    
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
