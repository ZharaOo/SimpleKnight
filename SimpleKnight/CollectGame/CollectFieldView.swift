//
//  CollectFieldView.swift
//  SimpleKnight
//
//  Created by Ivan Babkin on 30.06.2018.
//  Copyright © 2018 Ivan Babkin. All rights reserved.
//

import UIKit

protocol ClassicFieldViewDelegate: class {
    func moveMade(score: Int, collected: Bool)
}

class CollectFieldView: FieldView {
    weak var delegate: ClassicFieldViewDelegate!
    
    var enemies = [CGPoint]()
    var collectPoint = CGPoint(x: 7, y: 7)
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        figure = Knight(location: CGPoint(x: 0, y: 0))
        buttons[CellButton.indexOf(figure.location)].occupied = true
        buttons[CellButton.indexOf(figure.location)].setBackgroundImage(UIImage(named: "KnightImage"), for: .normal)
        setCollectPointAndEnemies()
        buttons.forEach() { $0.setScore() }
    }
    
    override func buttonPressed(_ sender: CellButton) {
        if figure.canMakeMove(to: sender.location) && interactionAllowed {
            buttons[CellButton.indexOf(figure.location)].occupied = false
            buttons[CellButton.indexOf(figure.location)].setBackgroundImage(UIImage(), for: .normal)
            figure.move(to: sender.location)
            
            if sender.occupied {
                if sender.location == collectPoint {
                    delegate.moveMade(score: 200, collected: true)
                    
                    setCollectPointAndEnemies()
                    buttons.forEach() { $0.setScore() }
                }
                else if enemies.contains(where: {$0.x == sender.location.x && $0.y == sender.location.y}) {
                    delegate.moveMade(score: -200, collected: false)
                }
            }
            else {
                delegate.moveMade(score: sender.score - 50, collected: false)
            }
            
            buttons[CellButton.indexOf(figure.location)].setBackgroundImage(UIImage(named: "KnightImage"), for: .normal)
            buttons[CellButton.indexOf(figure.location)].occupied = true

        }
    }
    
    func setCollectPointAndEnemies() {
        clearCellsImages()
        generateCollectPoint(figureLocation: figure.location)
        generateEnemies(figureLocarion: figure.location, collectPointLocation: collectPoint)
    }
    
    func generateCollectPoint(figureLocation: CGPoint) {
        var collectPoint = CGPoint(x: Int(arc4random() % 8), y: Int(arc4random() % 8))
        while collectPoint ==  figureLocation {
            collectPoint = CGPoint(x: Int(arc4random() % 8), y: Int(arc4random() % 8))
        }
        
        self.collectPoint = collectPoint
        buttons[CellButton.indexOf(self.collectPoint)].setBackgroundImage(UIImage(named: "CollectImage"), for: .normal)
        buttons[CellButton.indexOf(self.collectPoint)].occupied = true
    }
    
    func generateEnemies(figureLocarion: CGPoint, collectPointLocation: CGPoint) {
        var hEnemies = [CGPoint]()
        
        let numberOfEnemies = 1 + arc4random() % 8
        
        for _ in 0...numberOfEnemies {
            var enemyLocation = CGPoint(x: Int(arc4random() % 8), y: Int(arc4random() % 8))
            while enemyLocation == figureLocarion || enemyLocation == collectPointLocation || hEnemies.contains(where: {$0.x == enemyLocation.x && $0.y == enemyLocation.y}) {
                enemyLocation = CGPoint(x: Int(arc4random() % 8), y: Int(arc4random() % 8))
            }
            
            hEnemies.append(enemyLocation)
        }
        
        self.enemies = hEnemies
        self.enemies.forEach() { enemy in
            buttons[CellButton.indexOf(enemy)].setBackgroundImage(UIImage(named: "EnemyImage"), for: .normal)
            buttons[CellButton.indexOf(enemy)].occupied = true
        }
    }
    
    func clearCellsImages() {
        enemies.forEach() { enemy in
            buttons[CellButton.indexOf(enemy)].setBackgroundImage(UIImage(), for: .normal)
            buttons[CellButton.indexOf(enemy)].occupied = false
        }
        
        buttons[CellButton.indexOf(collectPoint)].setBackgroundImage(UIImage(), for: .normal)
        buttons[CellButton.indexOf(collectPoint)].occupied = false
    }
}
