//
//  GameViewController.swift
//  SimpleKnight
//
//  Created by Ivan Babkin on 30.06.2018.
//  Copyright © 2018 Ivan Babkin. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ClassicGameViewController: UIViewController, GameDelegate, FinishViewDelegate, PauseViewDelegate, GADInterstitialDelegate {

    @IBOutlet weak var field: ClassicFieldView!
    @IBOutlet weak var movesLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    var game: ClassicGame!
    var rulesView: RulesView!
    var interstitial: GADInterstitial?
    
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
    }
}
