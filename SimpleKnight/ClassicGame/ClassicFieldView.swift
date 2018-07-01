//
//  ClassicFieldView.swift
//  SimpleKnight
//
//  Created by Ivan Babkin on 30.06.2018.
//  Copyright © 2018 Ivan Babkin. All rights reserved.
//

import UIKit

protocol ClassicFieldViewDelegate: class {
    func moveMade(score: Int)
}

class ClassicFieldView: FieldView {
    var delegate: ClassicFieldViewDelegate!
    
    override func buttonPressed(_ sender: CellButton) {
        if figure.canMakeMove(to: sender.location) {
            figure.move(to: sender.location)
            
            sender.setBackgroundImage(UIImage(named: "KnightImage"), for: .normal)
            
            buttons.forEach() { button in
                if button.past {
                    button.setBackgroundImage(UIImage(named: "PastCellImage"), for: .normal)
                }
            }
            
            delegate.moveMade(score: sender.score)
            sender.past = true
            buttons.forEach() { $0.setScore() }
        }
    }
    
    func canFigureMove() -> Bool {
        for i in 0..<8 {
            for j in 0..<8 {
                let location = CGPoint(x: i, y: j)
                if figure.canMakeMove(to: location) && !locationPased(location) {
                    return true
                }
            }
        }
        
        return false
    }

    func locationPased(_ location: CGPoint) -> Bool {
        if location.x < 0 || location.x > 7 || location.y < 0 || location.y > 7 {
            return true
        }
        
        for button in buttons {
            if button.past && button.location == location {
                return true
            }
        }
        
        return false
    }
}