//
//  ViewController.swift
//  SimpleKnight
//
//  Created by Ivan Babkin on 30.06.2018.
//  Copyright © 2018 Ivan Babkin. All rights reserved.
//

import AppTrackingTransparency
import StoreKit
import GameKit

final class MenuButton: UIButton {
    override func draw(_ rect: CGRect) {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.cgColor
        self.setTitleColor(.black, for: .normal)
    }
}

final class StartViewController: UIViewController, GKGameCenterControllerDelegate {
    private let userDefaults = UserDefaults.standard
    
    // MARK: - lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        authenticateLocalPlayer()
        requestADIDPermission()
        if userDefaults.bool(forKey: "CollectRulesShown") || userDefaults.bool(forKey: "CollectRulesShown") {
                SKStoreReviewController.requestReview()
        }
    }

    @IBAction func showLeaderboard(_ sender: UIButton) {
        let gcVC = GKGameCenterViewController()
        gcVC.gameCenterDelegate = self
        gcVC.viewState = .default
        present(gcVC, animated: true)
    }
    
    //MARK: - GKGameCenterControllerDelegate
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true)
    }
    
    
    //MARK: - Game center methods
    
    private func authenticateLocalPlayer() {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.local
        
        localPlayer.authenticateHandler = { [weak self] viewController, error in
            if let viewController = viewController {
                self?.present(viewController, animated: true)
            }
        }
    }
    
    private func requestADIDPermission() {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { _ in }
        }
    }
}

