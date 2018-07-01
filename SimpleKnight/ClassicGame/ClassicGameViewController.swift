//
//  GameViewController.swift
//  SimpleKnight
//
//  Created by Ivan Babkin on 30.06.2018.
//  Copyright © 2018 Ivan Babkin. All rights reserved.
//

import UIKit

class ClassicGameViewController: UIViewController, ClassicGameDelegate {

    @IBOutlet weak var field: ClassicFieldView!
    @IBOutlet weak var movesLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    var game: ClassicGame!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movesLabel.layer.masksToBounds = true
        scoreLabel.layer.masksToBounds = true
        movesLabel.layer.cornerRadius = 8.0
        scoreLabel.layer.cornerRadius = 8.0
        startGame()
    }
    
    func startGame() {
        game = ClassicGame(field: field)
        game.delegate = self
        
        movesLabel.text = "Moves: \(game!.moves)"
        scoreLabel.text = "Score: \(game!.score)"
    }
    
    func moveMade() {
        movesLabel.text = "Moves: \(game!.moves)"
        scoreLabel.text = "Score: \(game!.score)"
    }
    
    func finishGame() {
        UIView.animate(withDuration: 1.0) {
            self.field.hideKnight()
        }
    }
}
