//
//  CollectGameViewController.swift
//  SimpleKnight
//
//  Created by Ivan Babkin on 30.06.2018.
//  Copyright © 2018 Ivan Babkin. All rights reserved.
//

import UIKit

class CollectGameViewController: UIViewController, GameDelegate, FinishViewDelegate {
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var field: CollectFieldView!
    
    var game: CollectGame!
    var rulesView: RulesView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timeLabel.layer.masksToBounds = true
        scoreLabel.layer.masksToBounds = true
        timeLabel.layer.cornerRadius = 8.0
        scoreLabel.layer.cornerRadius = 8.0
        startGame()
    }
    
    override func viewDidLayoutSubviews() {
        if rulesView == nil && !UserDefaults.standard.bool(forKey: "CollectRulesShown") {
            rulesView = RulesView(frame: CGRect(x: 0.0, y: field.frame.maxY, width: view.frame.width, height: view.frame.height - field.frame.maxY))
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
        
        if !UserDefaults.standard.bool(forKey: "ClassicRulesShown") {
            switch game!.score {
            case 0:
                rulesView.setText(text: "Collect as many red chips as you can. Better not to step on cross cell.")
            default:
                UserDefaults.standard.set(true, forKey: "RulesShown")
                rulesView.removeFromSuperview()
            }
        }
    }
    
    func goToMainMenu() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func finishGame() {
        UIView.animate(withDuration: 1.0, animations: { self.field.hideKnight() }, completion: { complete in
            let finishView = FinishView.instanceFromNib(score: self.game.score, bestScore: 0)
            finishView.delegate = self
            self.view.addSubview(finishView)
        })
    }
}
