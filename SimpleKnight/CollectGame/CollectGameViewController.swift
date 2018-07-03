//
//  CollectGameViewController.swift
//  SimpleKnight
//
//  Created by Ivan Babkin on 30.06.2018.
//  Copyright © 2018 Ivan Babkin. All rights reserved.
//

import UIKit
import GoogleMobileAds

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
    }
}
