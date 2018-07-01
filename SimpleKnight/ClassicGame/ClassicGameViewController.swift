//
//  GameViewController.swift
//  SimpleKnight
//
//  Created by Ivan Babkin on 30.06.2018.
//  Copyright © 2018 Ivan Babkin. All rights reserved.
//

import UIKit

class ClassicGameViewController: UIViewController, GameDelegate, FinishViewDelegate {

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
        
        updateLabels()
    }
    
    func updateLabels() {
        movesLabel.text = "Moves: \(game!.moves)"
        scoreLabel.text = "Score: \(game!.score)"
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
