//
//  GameViewController.swift
//  SimpleKnight
//
//  Created by Ivan Babkin on 30.06.2018.
//  Copyright © 2018 Ivan Babkin. All rights reserved.
//

import UIKit
import GameKit

class ClassicGameViewController: GameViewController, GameDelegate {

    @IBOutlet weak var field: ClassicFieldView!
    @IBOutlet weak var movesLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    var game: ClassicGame!
    var rulesView: RulesView!
    var allCornersVisited = false
    
    
    // MARK: - lifecycle
    
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
    
    
    // MARK: - IBActions
    
    @IBAction func pauseGame(_ sender: Any) {
        showPauseView()
    }
    
    
    // MARK: - GameDelegate
    
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
    
    func finishGame(bestScore: Int) {
        UIView.animate(withDuration: 1.0, animations: { self.field.hideKnight() }, completion: { complete in
            self.showFinishView(score: self.game.score, bestScore: bestScore)
            self.showAd()
        })
        
        reportTimeToGameCenter(score: game.score, leaderboardID: "down_scores_classic")
        configureAndPostAchievement(id: "fbeginner")
    }
    
    
    // MARK: - Override PauseViewDelegate methods
    
    override func playAgainGame() {
        field.clearField()
        startGame()
    }
    
    
    // MARK: - Game methods
    
    func startGame() {
        game = ClassicGame(field: field)
        game.delegate = self
        updateLabels()
    }
    
    //MARK: - Game Center methods
    
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
