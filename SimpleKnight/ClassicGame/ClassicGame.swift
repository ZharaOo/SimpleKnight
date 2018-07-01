//
//  Game.swift
//  SimpleKnight
//
//  Created by Ivan Babkin on 30.06.2018.
//  Copyright © 2018 Ivan Babkin. All rights reserved.
//

import UIKit

protocol ClassicGameDelegate: class {
    func finishGame()
    func moveMade()
}

class ClassicGame: NSObject, ClassicFieldViewDelegate {
    weak var field: ClassicFieldView!
    weak var delegate: ClassicGameDelegate!
    
    var moves = 0
    var score = 0
    
    init(field: ClassicFieldView) {
        self.field = field
        
        super.init()
        
        self.field.delegate = self
    }
    
    func moveMade(score: Int) {
        self.score += score
        delegate.moveMade()
        
        if !field.canFigureMove() {
            finish()
        }
    }
    
    func finish() {
        delegate!.finishGame()
    }
}
