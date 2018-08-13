//
//  ViewController.swift
//  SimpleKnight
//
//  Created by Ivan Babkin on 30.06.2018.
//  Copyright © 2018 Ivan Babkin. All rights reserved.
//

import UIKit
import StoreKit
import GameKit

class MenuButton: UIButton {
    override func draw(_ rect: CGRect) {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.cgColor
        self.setTitleColor(.black, for: .normal)
    }
}

class StartViewController: UIViewController, GKGameCenterControllerDelegate {
    
    // MARK: - lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        authenticateLocalPlayer()
        if UserDefaults.standard.bool(forKey: "CollectRulesShown") || UserDefaults.standard.bool(forKey: "CollectRulesShown") {
            if #available(iOS 10.3, *) {
                SKStoreReviewController.requestReview()
            }
        }
    }
    
    @IBAction func showLeaderboard(_ sender: UIButton) {
        let gcVC: GKGameCenterViewController = GKGameCenterViewController()
        gcVC.gameCenterDelegate = self
        gcVC.viewState = GKGameCenterViewControllerState.default
        self.present(gcVC, animated: true, completion: nil)
    }
    
    
    //MARK: - GKGameCenterControllerDelegate
    
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: - Game center methods
    
    
    func authenticateLocalPlayer() {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = { ViewController, error in
            if ViewController != nil {
                self.present(ViewController!, animated: true, completion: nil)
            }
        }
    }
}

