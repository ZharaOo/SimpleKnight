//
//  CollectGame.swift
//  SimpleKnight
//
//  Created by Ivan Babkin on 30.06.2018.
//  Copyright © 2018 Ivan Babkin. All rights reserved.
//

import UIKit

class CollectGame: NSObject, CollectFieldViewDelegate {
    weak var field: CollectFieldView!
    weak var delegate: GameDelegate!
    
    var score = 0
    var time = 64
    @objc dynamic var chips = 0
    
    private let ud = UserDefaults.standard
    
    private var timer: Timer!
    
    init(field: CollectFieldView) {
        self.field = field
        
        super.init()
        self.field.delegate = self
        startTimer()
    }
    
    
    // MARK: - ClassicFieldViewDelegate
    
    func moveMade(score: Int, collected: Bool) {
        if collected {
            time += 1
            chips += 1
        }
        
        self.score += score
        delegate.updateLabels()
        
        if score < 0 {
            finish()
        }
    }
    
    
    // MARK: - Finish game methods
    
    func finish() {
        stopTimer()
        delegate.finishGame(bestScore: writeBestScore())
    }
    
    func writeBestScore() -> Int {
        if ud.integer(forKey: "CollectBestScore") < score {
            ud.set(score, forKey: "CollectBestScore")
        }
        
        return ud.integer(forKey: "CollectBestScore")
    }
    
    
    // MARK: - Timer methods
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerTick), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        timer.invalidate()
    }
    
    @objc func timerTick() {
        time -= 1
        delegate.updateLabels()
        if time == 0 {
            finish()
        }
    }
}
