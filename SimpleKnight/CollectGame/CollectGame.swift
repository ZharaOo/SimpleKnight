//
//  CollectGame.swift
//  SimpleKnight
//
//  Created by Ivan Babkin on 30.06.2018.
//  Copyright © 2018 Ivan Babkin. All rights reserved.
//

import UIKit

class CollectGame: NSObject, ClassicFieldViewDelegate {
    weak var field: CollectFieldView!
    weak var delegate: GameDelegate!
    
    var score = 0
    var time = 5
    
    private var timer: Timer!
    
    init(field: CollectFieldView) {
        self.field = field
        
        super.init()
        self.field.delegate = self
        startTimer()
    }
    
    @objc func timerTick() {
        time -= 1
        delegate.updateLabels()
        if time == 0 {
            finish()
        }
    }
    
    func moveMade(score: Int, collected: Bool) {
        if collected {
            time += 2
        }
        self.score += score
        delegate.updateLabels()
        
        if score < 0 {
            finish()
        }
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerTick), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        timer.invalidate()
    }
    
    func finish() {
        stopTimer()
        delegate.finishGame()
    }
}
