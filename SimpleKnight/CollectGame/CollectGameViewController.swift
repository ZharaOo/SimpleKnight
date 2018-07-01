//
//  CollectGameViewController.swift
//  SimpleKnight
//
//  Created by Ivan Babkin on 30.06.2018.
//  Copyright © 2018 Ivan Babkin. All rights reserved.
//

import UIKit

class CollectGameViewController: UIViewController, GameDelegate {
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var field: CollectFieldView!
    
    var game: CollectGame!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timeLabel.layer.masksToBounds = true
        scoreLabel.layer.masksToBounds = true
        timeLabel.layer.cornerRadius = 8.0
        scoreLabel.layer.cornerRadius = 8.0
        startGame()
    }
    
    func startGame() {
        game = CollectGame(field: field)
        game.delegate = self
        updateLabels()
    }
    
    func updateLabels() {
        timeLabel.text = "Time: \(game.time)"
        scoreLabel.text = "Score: \(game.score)"
    }
    
    func finishGame() {
        UIView.animate(withDuration: 1.0) {
            self.field.hideKnight()
        }
    }
}
