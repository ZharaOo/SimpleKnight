//
//  Game.swift
//  SimpleKnight
//
//  Created by Ivan Babkin on 30.06.2018.
//  Copyright © 2018 Ivan Babkin. All rights reserved.
//

import UIKit

class ClassicGame: NSObject, FieldViewDelegate {
    weak var field: ClassicFieldView!
    weak var delegate: GameDelegate!
    
    var moves = 0
    var score = 0
    
    init(field: ClassicFieldView) {
        self.field = field
        
        super.init()
        
        self.field.delegate = self
    }
    
    func moveMade(score: Int) {
        self.score += score
        self.moves += 1
        delegate.updateLabels()
        
        if !field.canFigureMove() {
            finish()
        }
    }
    
    func finish() {
        delegate!.finishGame()
    }
}
